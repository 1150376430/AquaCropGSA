function [v_checked, v_flag_bounded] = F_check_distr(v_distribution,v_distr_param)
% Verifie si la distribution donnee est implementee et si le nombre de parametres est correct. 
% 
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%
%   Executer la methode sans argument pour voir la liste des distributions
%   fprintfonibles.
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_checked: 1 si tout semble OK, 0 s'il y a un probleme.
%      - v_flag_bounded : 1 si la distribution est bornée, 0 sinon. 
%
%    
%
%  AUTEUR(S): S. Buis
%  DATE: 10-aout-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-07-11 15:23:32 +0200 (jeu., 11 juil. 2013) $
%    $Author: cauclair $
%    $Revision: 962 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    disp('uniform : Loi uniforme ; 2 parametres : borne inferieure et borne superieure')
    disp('triangular : Loi triangulaire ; 3 parametres : borne inferieure, abscisse du pic et borne superieure')
    disp('beta : Loi beta ; 2, 3 ou 4 parametres : alpha, beta + borne inferieure si differente de 0 + borne superieure si differente 1 (dans ce cas, la borne inferieure doit etre donnee meme si elle vaut 0)')
    disp('gamma : Loi gamma ; 2, 3 ou 4 parametres : alpha (forme) et beta (echelle) + borne inferieure (decalage de la pdf) si differente de 0 + borne superieure (troncature - dans ce cas, la borne inferieure doit etre donnee meme si elle vaut 0)')
    disp('normal : Loi normale ; 2, 3 ou 4 parametres : moyenne et ecart type + borne inferieure (troncature) + borne superieure (troncature, si troncature a droite mais pas a gauche, mettre -Inf pour la borne inferieure)')
    disp('lognormal : Loi log-normale ; 2, 3 ou 4 parametres : moyenne et ecart type du logarithme de la variable + borne inferieure (decalage de la pdf) si differente de zero + borne superieure (troncature - dans ce cas, la borne inferieure doit etre donnee meme si elle vaut 0)')
    disp('weibull : Loi de Weibull ; 2, 3 ou 4 parametres : lambda (echelle) et k (forme) + borne inferieure (decalage de la pdf) si differente de 0 + borne superieure (troncature - dans ce cas, la borne inferieure doit etre donnee meme si elle vaut 0)')
    disp('exponential : Loi exponentielle ; 1, 2 ou 3 parametres : lambda + borne inferieure (decalage de la pdf) si differente de 0 + borne superieure (troncature - dans ce cas, la borne inferieure doit etre donnee meme si elle vaut 0)')
    disp('discrete : Loi discrete ; n parametres : modalites equiprobable.')
    return
end

v_checked=1;
v_flag_bounded=0;
if any(isnan(v_distr_param))
    fprintf('Erreur dans la definition d''une loi %s : certains parametres de la loi n''ont pas ete definis ou valent NaN.\n',lower(v_distribution))
    v_checked=0;
else
    switch lower(v_distribution)
        case 'uniform'
            if length(v_distr_param)~=2
                fprintf('Erreur dans la definition d''une loi uniforme : %s parametres ont ete definis pour cette loi (elle en necessite 2).\n',num2str(length(v_distr_param)))
                v_checked=0;
            elseif v_distr_param(2)<=v_distr_param(1)
                fprintf('Erreur dans la definition d''une loi uniforme : la borne inferieure (=%s) est superieure ou egale a la borne superieure (=%s).\n',v_distr_param(1),v_distr_param(2));
                v_checked=0;
            end
            v_flag_bounded=1;
        case 'triangular'
            if length(v_distr_param)~=3
                fprintf('Erreur dans la definition d''une loi triangulaire : %s parametres ont ete definis pour cette loi (elle en necessite 3).\n',num2str(length(v_distr_param)))
                v_checked=0;
            elseif v_distr_param(2)<v_distr_param(1) || v_distr_param(3)<v_distr_param(2) || v_distr_param(1)==v_distr_param(3)
                fprintf('Erreur dans la definition d''une loi triangulaire : les parametres doivent respecter l''inegalite : param1<=param2<=param3.\n');
                v_checked=0;
            end
            v_flag_bounded=1;
        case 'beta'
            if length(v_distr_param)==2
                v_distr_param(3)=0;
                v_distr_param(4)=1;
            elseif length(v_distr_param)==3
                v_distr_param(4)=1;
            end
            if length(v_distr_param)~=2 && length(v_distr_param)~=3 && length(v_distr_param)~=4
                fprintf('Erreur dans la definition d''une loi beta : %s parametres ont ete definis pour cette loi (elle en necessite 2, 3 ou 4).\n',num2str(length(v_distr_param)))
                v_checked=0;
            elseif v_distr_param(4)<=v_distr_param(3)
                fprintf('Erreur dans la definition d''une loi beta : la borne inferieure (=%s) est superieure ou egale a la borne superieure (=%s).\n',v_distr_param(3),v_distr_param(4));
                v_checked=0;
            end
            v_flag_bounded=1;
        case 'gamma'
            if length(v_distr_param)~=2 && length(v_distr_param)~=3 && length(v_distr_param)~=4
                fprintf('Erreur dans la definition d''une loi gamma : %s parametres ont ete definis pour cette loi (elle en necessite 2, 3 ou 4).\n',num2str(length(v_distr_param)))
                v_checked=0;
            end
            if length(v_distr_param)==4
               v_flag_bounded=1;
            end
        case 'normal'
            if length(v_distr_param)~=2 && length(v_distr_param)~=3 && length(v_distr_param)~=4
                fprintf('Erreur dans la definition d''une loi normale : %s parametres ont ete definis pour cette loi (elle en necessite 2, 3 ou 4).\n',num2str(length(v_distr_param)))
                v_checked=0;
            end
            if length(v_distr_param)==4
               v_flag_bounded=1;
            end
        case 'lognormal'
            if length(v_distr_param)~=2 && length(v_distr_param)~=3 && length(v_distr_param)~=4
                fprintf('Erreur dans la definition d''une loi lognormale : %s parametres ont ete definis pour cette loi (elle en necessite 2, 3 ou 4).\n',num2str(length(v_distr_param)))
                v_checked=0;
            end
            if length(v_distr_param)==4
               v_flag_bounded=1;
            end
        case 'weibull'
            if length(v_distr_param)~=2 && length(v_distr_param)~=3 && length(v_distr_param)~=4
                fprintf('Erreur dans la definition d''une loi de Weibull : %s parametres ont ete definis pour cette loi (elle en necessite 2, 3 ou 4).\n',num2str(length(v_distr_param)))
                v_checked=0;
            end
            if length(v_distr_param)==4
               v_flag_bounded=1;
            end
        case 'exponential'
            if length(v_distr_param)~=1 && length(v_distr_param)~=2 && length(v_distr_param)~=3
                fprintf('Erreur dans la definition d''une loi exponentielle : %s parametres ont ete definis pour cette loi (elle en necessite 1, 2 ou 3).\n',num2str(length(v_distr_param)))
                v_checked=0;
            end
        case 'discrete'
            if length(v_distr_param)==0
                fprintf('Erreur dans la definition d''une loi discrete : aucune modalite n''a ete defini pour cette loi (elle en necessite au moins une).\n')
                v_checked=0;
            end
            if length(v_distr_param)==3
               v_flag_bounded=1;
            end
        otherwise 
            fprintf('%s ne fait pas partie des distributions disponibles.\n', ...
                v_distribution);
            v_checked=0;
    end
end
if ~v_checked
   fprintf('Executer la commande F_create_sample() pour voir la liste des distributions disponibles et leurs parametres.\n');
end
