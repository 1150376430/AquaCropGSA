function vm_sample = F_create_sample(vc_distribution,vc_distr_param,v_sample_size,v_sampling_method)
% Genere un echantillon pour n facteurs selon des lois et une methode de tirage definis 
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - vc_distribution: vecteur de cell contenant le type de distribution pour
%      chaque facteur
%      - vc_distr_param: vecteur de cell contenant les parametres des
%      distributions de chaque facteur
%      - v_sample_size: taille de l'echantillon a tirer
%      - v_sampling_method: methode d'echantillonnage
%
%   Executer la methode sans argument pour voir la liste des distributions
%   disponibles.
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vm_sample: matrice contenant l'echantillon avec autant de lignes que la taille de
%      l'echantillon et autant de colonnes que le nombre de parametres e
%      estimer
%
%
%  AUTEUR(S): S. Buis
%  DATE: 06-may-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    F_check_distr
    return
end

vc_method_list={'rand','lhs','lptau','fullfact'};

if nargin==0
    vm_sample=vc_method_list;
    return
end

if isempty(v_sampling_method)
    v_sampling_method='lhs';
end

v_nbfactors=length(vc_distribution);

% Tirage selon la methode demandee

% switch sur la methode et tirage sur [0,1] selon une loi uniforme
switch lower(v_sampling_method)
    case 'rand' 
        vm_sample_ini=rand(v_sample_size,v_nbfactors);
    case 'lhs' 
        try
            % Utilisation de la stat toolbox par defaut
            vm_sample_ini=lhsdesign(v_sample_size,v_nbfactors);
        catch
            % Si elle n'est pas dispo, utilisation de la version
            % de la bibliotheque
            vm_sample_ini=F_opti_gen_variant_lh(zeros(1,v_nbfactors),ones(1,v_nbfactors),v_sample_size);
        end
    case 'lptau'
        v_flag=(exist('sobolset')==2)+(exist('addFacUnif')==2)*2;
    
        switch v_flag
            case {1,3}  % utilisation de la toolbox statistics de Matlab
                vm_p=sobolset(v_nbfactors);
                vm_p = scramble(vm_p,'MatousekAffineOwen');
                vm_sample_ini=net(vm_p,v_sample_size);
            case 2 % utilisation du logiciel SimLab
                gsaBegin;
                for i=1:v_nbfactors
                    addFacUnif(['x' num2str(i)],1,[0;1;1]);
                end
                setMethodLptau(v_sample_size);     
                vm_sample_ini(:,:)=createSample;
                gsaEnd;               
            otherwise
                error('Pour effectuer un tirage avec la methode lptau il est necessaire d''avoir la toolbox Matlab statistic ou le logiciel Simlab.')
       end
    case 'fullfact'     
        for i=1:v_nbfactors
            if ~(strcmp(vc_distribution(i),'discrete'))
               error('Au moins un des facteurs n''a pas une loi discrete. Tous les facteurs doivent avoir une loi de probabilite discrete lorsque l''on souhaite utiliser la methode plan factoriel complet (fullfact)')
            end
            v_levels(i)=length(vc_distr_param{i});
        end
        v_design=fullfact(v_levels);
        for i=1:v_nbfactors
            v_tmp=cumsum(ones(v_levels(i),1)./v_levels(i))-1/(2*v_levels(i));
            vm_sample_ini(:,i)=v_tmp(v_design(:,i))';
        end
    otherwise
        error('Erreur dans la fonction d''echantillonnage: %s ne fait pas partie des methodes disponibles.', ...
            v_sampling_method);
end

% Transformation selon les lois demandees.
for i=1:v_nbfactors
    [v_flag_truncated,vm_sample_ini(:,i)] = F_inverse_cdf(vc_distribution{i},vc_distr_param{i}, vm_sample_ini(:,i));
    
    % Cas des lois tronquees (par algorithme d'acceptation-rejet)
    % Ce n'est pas vraiment compatible avec un tirage LHS ou LPtau en ND. La solution choisie est de faire un premier tirage selon la 
    % methode demandee puis de completer si besoin avec un tirage random.
    if v_flag_truncated
        [vm_sample(:,i),v_flag_completed] = F_acceptance_rejection(vc_distribution{i},vc_distr_param{i},vm_sample_ini(:,i));
        while ~v_flag_completed
            vm_sample_new=rand(v_sample_size,1);  % on complete avec du random ...
            [v_flag_truncated,vm_sample_new] = F_inverse_cdf(vc_distribution{i},vc_distr_param{i}, vm_sample_new);
            [vm_sample(:,i),v_flag_completed] = F_acceptance_rejection(vc_distribution{i},vc_distr_param{i}, vm_sample_new,vm_sample(:,i));
        end
    else
        vm_sample(:,i) = vm_sample_ini(:,i);
    end    
end
