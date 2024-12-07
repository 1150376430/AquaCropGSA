function [vm_F, vm_G, vm_mu, vm_sigma, vm_mu_star, vm_mu_uncert, vm_sigma_uncert, vm_mu_star_uncert] = F_sensi_analysis_Morris(vm_in_mat, vm_out_mat, vs_factors_def, vs_method_options)
% Generation des variants pour la methode de Morris.
%
% Cette fonction donne en sortie les matrices de valeur moyenne des taux
%      d'accroissement, de la vakeur absolue de ceux-ci et les indices de
%      Morris
%
%
% ENTREES :
%
%      - vm_in_mat : plan d'expérience des données à analyser (type : matrice de format ((k+1)*r*vs_method_options.m,k)
%        avec r le nombre de trajectoires dans l'espace des phases
%        constituant le plan d'expérience et k nombre de paramètres en entrée 
%        à analyser et m décrits ci-dessous
%
%       - vm_out_mat : f(v_in_mat) avec f le modèle à analyser 
%
%      - vs_factors_def : structure de definition des facteurs
%          o vs_factors_def.Dist (OPTIONNEL) : vecteur de cell contenant le type de distribution pour
%            chaque facteur.
%            Pour voir la liste des distributions disponibles, executer la
%            fonction F_create_sample() sans argument.
%            ATTENTION: pour utiliser des lois autres que les lois uniforme et 
%            triangulaire il est necessaire d'avoir la toolbox matlab "statistics".
%            ATTENTION: la methode ne fonctionne pas avec la distribution
%            'discrete'.
%            Si ce champ n'est pas precise ou est vide, les distributions des facteurs seront toutes fixees e
%            'uniform'. 
%            Si le vecteur ne contient qu'une seule distribution alors tous les facteurs auront
%            la distribution donnee.
%            Dans ces deux derniers cas le champ Nb devra etre
%            precise (cf. ci-apres).
%          o vs_factors_def.DistParams (OPTIONNEL) : vecteur de cell
%            contenant le vecteur des parametres de la distribution 
%            pour chaque facteur. 
%            Pour voir la liste des parametres requis pour chaque distribution
%            disponible, executer la fonction F_create_sample() sans argument.
%            Si ce champ n'est pas fourni ou est vide, les parametres
%            seront fixes a 0 et 1.
%            Si ce champ ne contient qu'un vecteur de parametre, ces
%            parametres seront utilises pour toutes les distributions.
%          o vs_factors_def.Nb (OPTIONNEL) : scalaire contenant le
%            nombre de facteurs. Obligatoire si le champ Dist n'est pas
%            precise, est vide ou ne contient qu'une seule distribution. 
%
%      - vs_method_options : structure de definition des options de la
%        methode
%          o vs_method_options.graph : (OPTIONNEL) 'Si graph = 1, un graphique de sigma 
%           en fonction de mu est généré pour chaque variable en sortie, sinon non.
%           Valeur par défaut : 1.
%          o vs_method_options.incert : (OPTIONNEL) methode d'estimation des
%          incertitudes sur les indices calculés : 'bootstrap' (par
%          bootstrap, i.e. par ré-échantillonnage de m groupes de trajectoires 
%          parmi les r  -> r*(k+1) simulations du modèle), ou 'réplication'
%          (par réplication, i.e. qu'on répète m fois le plan d'expérience
%          de r trajectoires -> r*(k+1)*m simulations du modèle).
%          Valeur par défaut : bootstrap.
%          o vs_method_options.m : (OPTIONNEL) nombre de
%            ré-échantillonnage boostrap ou nombre de réplicats de groupes de r 
%            trajectoires contenus dans la matrice en sortie ou  (selon valeur de vs_method_options.incert).
%            Valeur par défaut : r si bootstrap, 5 si réplication.
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vm_F : distribution finie Fi (voir "Choix des méthodes
%      d'estimation de paramètres pour le projet OptimiSTICS" de Samuel
%      BUIS et Daniel WALLACH - version du 07/11/07), matrice de format (nombre
%        de facteurs en entrée, nombre de tajectoires par groupe de trajectoires)
%        de matrices elle-mêmes de format (nombre de variables en sortie, nombre
%        de réplicats de groupes de trajectoires), ce qui donne un matrice 
%        "de dimension 4"
%      - vm_G : distribution Gi (voir même document), matrice de format (nombre
%        de facteurs en entrée, nombre de tajectoires par groupe de trajectoires)
%        de matrices elle-mêmes de format (nombre de variables en sortie, nombre
%        de réplicats de groupes de trajectoires), ce qui donne un matrice 
%        "de dimension 4"
%      - vm_mu :  matrice contenant les valeurs moyennes sur l'ensemble des 
%                 réplicats des valeurs moyennes sur l'ensemble 
%                 des r trajectoires des valeurs en vm_F, avec chaque ligne 
%                 correspondant à un paramètre en entrée et chaque colonne 
%                 correspondant à une variable en sortie
%      - vm_sigma : matrice contenant les valeurs moyennes sur l'ensemble des 
%                   réplicats des écarts types sur l'ensemble des
%                   trajectoires des valeurs en vm_F, avec chaque ligne 
%                   correspondant à un paramètre en entrée et chaque colonne 
%                   correspondant à une variable en sortie
%      - vm_mu_star : matrice contenant les valeurs moyennes sur l'ensemble des 
%                     réplicats des valeurs moyennes sur l'ensemble
%                     trajectoires des valeurs en vm_G, avec chaque ligne 
%                     correspondant à un paramètre en entrée et chaque colonne 
%                     correspondant à une variable en sortie
%      - vm_mu_uncert : matrice contenant les écarts-type sur l'ensemble
%                       des réplicats des valeurs de vm_mu, avec chaque ligne 
%                       correspondant à un paramètre en entrée et chaque colonne 
%                       correspondant à une variable en sortie
%      - vm_sigma_uncert : matrice contenant les écarts-type sur l'ensemble
%                          des réplicats des valeurs de vm_sigma, avec chaque ligne 
%                          correspondant à un paramètre en entrée et chaque colonne 
%                          correspondant à une variable en sortie
%      -vm_mu_star_uncert : matrice contenant les écarts-type sur l'ensemble
%                           des réplicats des valeurs de vm_mu_star, avec chaque ligne 
%                           correspondant à un paramètre en entrée et chaque colonne 
%                           correspondant à une variable en sortie
%  
%   CONTENU: descriptif de la fonction
%      - donne en sortie les matrices de valeur moyenne des taux
%      d'accroissement, de la valeur absolue de ceux-ci et les indices de
%      Morris ainsi que lmeurs écarts-types sur l'ensemble des m réplicats
%     
%  AUTEUR(S): Cyril AUCLAIR (stagiaire de Samuel BUIS à l'INRA PACA mai-septembre 2013)
%  DATE CREATION: 13-Jun-2013
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Definition du tableau contenant les options de la methode
vc_options_desc=struct('name',{'graph','incert','m'},...
    'datatype',{'uint32','char','uint32'},...
    'status',{'optional','optional','optional'},...
    'defaultvalue',{1,'bootstrap',[]},...
    'comments',{'Si graph = 1, un graphique de sigma sur |mu| est généré pour chaque variable en sortie, sinon non.',...
                'Méthode d''estimation des incertitudes sur les indices calculés : ''bootstrap'' ou ''réplication''',...
                'Nombre de ré-échantillonnages boostrap ou nombre de réplicats de groupes r trajectoires'});

%% Retour de la structure pour verification si appel sans arguments
if nargin==0
    vm_F=vc_options_desc;
    return
end

%% Renseignement des options par defaut
for i=1:length(vc_options_desc)
    if ~isfield(vs_method_options,vc_options_desc(i).name)
        if strmatch('optional',vc_options_desc(i).status,'exact')
            vs_method_options.(vc_options_desc(i).name)=vc_options_desc(i).defaultvalue;
        else
            error(['L''option ' vc_options_desc(i).name ' doit etre renseignee.'])
        end
    end
end
if ~isfield(vs_method_options,'m') || isempty(vs_method_options.m)
    if strcmp(lower(vs_method_options.incert),'bootstrap')
        vs_method_options.m=vs_method_options.r;
    elseif strcmp(lower(vs_method_options.incert),'replication')
        vs_method_options.m=5;
    end
end

%% Tests divers sur les arguments
if ~isfield(vs_factors_def,'Dist') || isempty(vs_factors_def.Dist)
    vs_factors_def.Dist={'uniform'};
end
if length(vs_factors_def.Dist)==1
    F_create_message('Probleme dans les arguments en entree',...
            'Lorsque le champ dist de l''argument vs_factors_def n''est pas fourni ou ne contient qu''une distribution, le champ Nb de l''argument vs_factors_def doit etre defini.',...
            ~isfield(vs_factors_def,'Nb') || isempty(vs_factors_def.Nb),1);
    vs_factors_def.Dist=mat2cell(repmat(vs_factors_def.Dist{1},vs_factors_def.Nb,1),ones(1,vs_factors_def.Nb),length(vs_factors_def.Dist{1}));
else
    vs_factors_def.Nb=length(vs_factors_def.Dist);
end
F_create_message('',...
    'La methode ne fonctionne pas avec la distribution ''discrete''.',...
    ~isempty(strmatch('discrete',vs_factors_def.Dist,'exact')),1);
if ~isfield(vs_factors_def,'DistParams') || isempty(vs_factors_def.DistParams)
    vs_factors_def.DistParams={[0,1]};
end
if length(vs_factors_def.DistParams)==1
    for i=2:vs_factors_def.Nb
        vs_factors_def.DistParams{i}=vs_factors_def.DistParams{1};
    end
end      
for i=1:vs_factors_def.Nb
    [v_checked, v_flag_bounded] = F_check_distr(vs_factors_def.Dist{i},vs_factors_def.DistParams{i});
    F_create_message(['Problème avec la distribution du facteur ' num2str(i)],...
        'La methode ne fonctionne pas avec les distributions non bornées.',...
        ~v_flag_bounded,1);
    F_create_message(['Problème avec la distribution du facteur ' num2str(i)],...
        'Voir messages ci-dessus.',...
        ~v_checked,1);
end

%% Code de la fonction

m = vs_method_options.m;
k = size(vm_in_mat,2); % dimension de la grille régulière
n = size(vm_out_mat,2); % nombre de variables de sortie

% On recalcule le plan d'expérience normalisé
vm_in_mat_norm=zeros(size(vm_in_mat));
for i=1:k
    [v_tmp, vm_in_mat_norm(:,i)]=F_cdf(vs_factors_def.Dist{i},vs_factors_def.DistParams{i},vm_in_mat(:,i));
end

% On enlève les trajectoire dans lesquelles il y a des pb dans la
% simulation
v_ind=sum(isnan(vm_out_mat)+isinf(vm_out_mat),2);
v_indtraj=unique(floor((find(v_ind)-1)/(k+1)));
v_indremove=[];
for i=1:length(v_indtraj)
    v_indremove=[v_indremove,v_indtraj(i)*(k+1)+1:(v_indtraj(i)+1)*(k+1)];
end
vm_in_mat_norm(v_indremove,:)=[];
vm_out_mat(v_indremove,:)=[];
if strcmpi(vs_method_options.incert,'bootstrap')
    r = size(vm_in_mat_norm,1)/(k+1); % nombre de trajectoires 
    vm_F = zeros(k,m,n,m); % matrice de format(k,r,n,m) destinee à contenir toutes les matrices Fm,i
    vm_F_concat = zeros(k,m*m,n);  % matrice de format(k,r*m,n) destinee à contenir toutes les matrices Fm,i de façon concaténée
elseif strcmpi(vs_method_options.incert,'replication')
    r = size(vm_in_mat_norm,1)/((k+1)*m) ; % nombre de trajectoires 
    vm_F = zeros(k,r,n,m); % matrice de format(k,r,n,m) destinee à contenir toutes les matrices Fm,i
    vm_F_concat = zeros(k,r*m,n);  % matrice de format(k,r*m,n) destinee à contenir toutes les matrices Fm,i de façon concaténée
end
if ~isempty(v_indremove)
    F_disp(sprintf('\nAttention des trajectoires ont été enlevées dans le plan d''experience de la méthode de Morris, il en reste %s',num2str(r)))
end
vm_M001 = zeros(k,k,m); % matrice de format (k,k) dont tous les éléments valent zéro initialement
vv_j = 1 : k;
vv_d = zeros(k,n,m); % matrice de de format (k,n,m) destinee a contenir à chacune la valeur d = +/- delta pour le parametre correspondant dupliquee à chaque colonne

for l = 1 : m
    if strcmpi(vs_method_options.incert,'bootstrap')
        ind=randsample(r,m,true); % ré-échantillonnage avec remise des trajectoires 
        for i=1:m
            vm_in_mat_norm_l((i-1)*(k+1)+1:i*(k+1),:)=vm_in_mat_norm((ind(i)-1)*(k+1)+1:ind(i)*(k+1),:);
            vm_out_mat_l((i-1)*(k+1)+1:i*(k+1),:)=vm_out_mat((ind(i)-1)*(k+1)+1:ind(i)*(k+1),:);
        end
    elseif strcmpi(vs_method_options.incert,'replication')
        vm_in_mat_norm_l=vm_in_mat_norm((l-1)*r*(k+1)+1:l*r*(k+1),:);
        vm_out_mat_l=vm_out_mat((l-1)*r*(k+1)+1:l*r*(k+1),:);
    end
    for i = 1:size(vm_in_mat_norm_l,1)/(k+1)
            vm_M001(:,vv_j,l) = vm_in_mat_norm_l((i-1)*(k+1)+vv_j+1,:)-vm_in_mat_norm_l((i-1)*(k+1)+vv_j,:); % matrice tels que vm_M1(j,:) = Bi*(j+1,:)-Bi*(j,:)
            vm_M004 = sum(vm_M001,2);
            for j = 1:n
                vv_d(:,j,l) = vm_M004(:,:,l);
            end
            vm_M002 = vm_M001|0;
            vv_m = vm_M002(:,:,l)*(vv_j');  
            vm_M005 = (vm_out_mat_l((i-1)*(k+1)+vv_j+1,:)-vm_out_mat_l((i-1)*(k+1)+vv_j,:));
            vm_M005=vm_M005./vv_d(:,:,l);
            for j = 1 : k
                vm_F(vv_m(j),i,:,l) = vm_M005(j,:);
                vm_F_concat(vv_m(j),(l-1)*r+i,:) = vm_M005(j,:);
            end
    end
end
vm_G = abs(vm_F);
vm_mu_rep = reshape(mean(vm_F(:,:,:,:),2),k,n,m);
vm_mu = reshape(mean(vm_mu_rep,3),k,n);
vm_mu_star_rep = reshape(mean(vm_G(:,:,:,:),2),k,n,m);
vm_mu_star = reshape(mean(vm_mu_star_rep,3),k,n);
vm_sigma_rep = reshape(std(vm_F(:,:,:,:),0,2),k,n,m);
vm_sigma = reshape(std(vm_F_concat,0,2),k,n);

vm_mu_uncert = reshape(std(vm_mu_rep,0,3),k,n);
vm_mu_star_uncert = reshape(std(vm_mu_star_rep,0,3),k,n);
vm_sigma_uncert = reshape(std(vm_sigma_rep,0,3),k,n);



if vs_method_options.graph == 1
    
    for j = 1:n
        
        [vm_mu_star_decroissant, vv_index_mu_star_decroissant] = sort(vm_mu_star(:,j), 'descend');
        vv_chaineDeCaracteresSortie1 = '  ';
        vv_chaineDeCaracteresSortie2 = 'µ* : ';
        disp(['valeur de µ* pour les différents paramètres pour la variable ' num2str(j)])
        for i = 1:size(vm_mu_star)
            vv_chaineDeCaracteresSortie1 = [vv_chaineDeCaracteresSortie1, '   X', num2str(vv_index_mu_star_decroissant(i)),'      '];
            vv_chaineDeCaracteresSortie2 = [vv_chaineDeCaracteresSortie2, num2str(vm_mu_star_decroissant(i), '%3.2e'),' ; ' ];
        end
        disp(vv_chaineDeCaracteresSortie1);
        %disp(['µ* : ', num2str(vm_mu_star_decroissant', '%3.2e')]);
        disp(vv_chaineDeCaracteresSortie2);

        figure
        hold on
        if m>1
          errorbar(vm_mu(:,j), vm_sigma(:,j), vm_sigma_uncert(:,j), '.') % on pourrait tracer des boxplot fin (est-ce que ça existe en horizontal ?) ...
          herrorbar(vm_mu(:,j), vm_sigma(:,j), vm_mu_uncert(:,j), '.') % ... ou le min et max (mais retourner en sortie les ect)
        end
        xlim([min(-1.1*max(abs(vm_mu(:,j))+vm_mu_uncert(:,j)),-0.1) max(1.1*max(abs(vm_mu(:,j))+vm_mu_uncert(:,j)),0.1)])
        ylim([min(min(abs(vm_sigma(:,j))-vm_sigma_uncert(:,j))-0.1*abs(min(abs(vm_sigma(:,j))-vm_sigma_uncert(:,j))),0) max(1.1*max(abs(vm_sigma(:,j))+vm_sigma_uncert(:,j)),0.1)])
        plot([0 0],ylim,'--')
        xminmax=xlim;
        yminmax=ylim;
        xoffset=diff(xlim)/100;
        yoffset=diff(ylim)/50;
        text(vm_mu(:,j)+xoffset, vm_sigma(:,j)+yoffset,num2str([1 : k]'))
        plot([max(xminmax(1),-yminmax(2)) 0],[abs(max(xminmax(1),-yminmax(2))) 0],'r--')
        plot([0 min(xminmax(2),yminmax(2))],[0 min(xminmax(2),yminmax(2))],'r--')
        hold off
        xlabel('µ');
        ylabel('sigma');
        title(['indice de Morris des différents paramètres, variable ' num2str(j)])
    
        figure
        for i=1:k
            subplot(ceil(sqrt(k)),ceil(sqrt(k)),i)
            hist(squeeze(vm_F_concat(i,:,j)),20);
            title(['Histogramme F, paramètre ' num2str(i) ', variable ' num2str(j)])
        end
        
    end
end
end