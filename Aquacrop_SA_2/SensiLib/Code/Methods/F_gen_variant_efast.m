function [v_in_mat,v_Ns,v_w]=F_gen_variant_efast(vs_factors_def,vs_method_options)
% Generation des variants pour la methode FAST.
%
% Cette fonction sert a generer un echantillon pour le calcul des indices 
% principaux et totaux avec la methode Extended FAST. Cette methode est
% decrite en detail dans le document "La methode FAST et ses extensions"
% qui servira de reference dans les commentaires suivants (notamment pour 
% les formules utilisees).
%
%
% ENTREES :
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
%          o vs_method_options.NsIni : scalaire entier contenant la taille de
%            l'echantillon souhaitee par l'utilisateur. Cette taille doit 
%            etre superieure ou egale a 65.
%            Le calcul des frequences a partir de Ns impose que 
%            (Ns-1) soit un multiple de (2*M)^2). Si tel n'est pas le
%            cas pour NsIni, on prendra le plus grand ne inferieur a 
%            NsIni qui satisfait cette condition. 
%            La taille reelle de l'echantillon sera donc :
%             v_Ns=(NsIni-mod(NsIni-1,(2*M)^2));
%            Le nombre total de simulations a realiser pour calculer les
%            indices sera alors de v_C=v_Ns*(Nb+1)*Nrep, ou Nb est 
%            le nombre de parametres variant.
%          o vs_method_options.Nrep (OPTIONNEL) : scalaire entier contenant le no de re-echantillonage ou de 
%            replicat i.e. le no de fois que les indices doivent etre 
%            calcules de facon independante (no de tirages aleatoires du 
%            shift phi). 
%            Vaut 1 par defaut. 
%          o vs_method_options.Seed (OPTIONNEL) : scalaire contenant la
%            graine pour le tirage aleatoire du shift phi.
%            Sa valeur par defaut change systematiquement afin que la
%            valeur de phi soit toujours differente. Si Seed est fixe, la
%            valeur de phi sera differente entre les Nrep repetitions interne, 
%            mais identique entre 2 appels a F_gen_variant_EFAST.
%          o vs_method_options.FlagDummy (OPTIONNEL) : scalaire booleen : 
%             * 1 pour considerer un parametre supplementaire, appele parametre 
%               dummy, qui n'intervient pas dans le modele, pour tester la 
%               significativite des indices calcules.
%               Dans ce cas, Ns*Nrep simulations supplementaires du
%               modele seront effectues par rapport au cas sans parametre
%               dummy.
%             * 0 sinon.
%            Vaut 1 par defaut.
%          o vs_method_options.M (OPTIONNEL) : nombre maximal d'harmonique
%            pris en compte dans la methode.
%            Vaut 4 par defaut.
%
% SORTIE :
%       - v_in_mat : 
%          matrice de type flottant, de taille (v_C=v_Ns*(Nb+1)*Nrep,Nb), 
%          contenant l'echantillon. 
%          ou Nb est le no de parametres variants.
%
%       - v_Ns : 
%          scalaire entier contenant la taille reelle de
%          l'echantillon utilisee. Cette taille vaut :
%           v_Ns=(NsIni-mod(NsIni-1,(2*M)^2));
%          Le nombre total de simulations a realiser pour calculer les
%          indices est alors de v_C=v_Ns*(Nb+1)*Nrep, ou Nb est 
%          le nombre de parametres variant.
%
%       - v_w : 
%          vecteur entier de taille le nombre de parametres variants 
%          contenant la liste des frequences utilisees dans la methode.
%
%
% CONTENU :
%      On commence par definir la taille de l'echantillon a partir de celle
%      donnee par l'utilisateur (la taille de l'echantillon -1 doit etre un 
%      multiple de (2*M)^2), ou M est le no maximum d'harmoniques
%      prises en compte.
%      On definie ensuite les variations de la variable s dans ]-pi,pi[ a 
%      partir duquel on va calculer les variants.
%      On definie la liste de frequence a partir de la taille d'echantillon
%      avec l'algorithme propose dans Saltelli et al 1999.
%      On tire aleatoirement autant de shift phi que de parametres.
%      Puis, pour chaque parametre : 
%           - on met a jour la liste des frequences (la frequence maximum
%             est affectee au parametre pour lequel on calcule les effets, 
%             les frequences des autres parametres etant issue de la liste 
%             de frequence calculee au debut)
%           - on applique la fonction de transformation Gi pour obtenir les
%             variant normalises a partir de s, des frequences et des phi;
%           - on transforme les variants dans l'espace des parametres a 
%             partir de la loi donnee par l'utilisateur;
%      et on obtient ainsi la liste des variants pour le calcul des indices
%      de chaque parametre ... et on fait ca Nrep fois.
%     
% AUTEUR : S. BUIS ET H.V VARELLA 
%         (merci a J.Jacques et C.Naud pour leurs contributions)
% DATE : 25-mai-2007
% VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Definition du tableau contenant les options de la methode
vc_options_desc=struct('name',{'NsIni','Nrep','Seed','FlagDummy','M'},...
    'datatype',{'uint32','uint32','double','uint32','uint32'},...
    'status',{'non optional','optional','optional','optional','optional'},...
    'defaultvalue',{[],1,[],1,4},...
    'comments',{'Taille de l''echantillon souhaitee par l''utilisateur', ...
                'Nombre de replicat de la methode',...
                'Graine pour le tirage aleatoire du shift phi',...
                '1 pour considerer un parametre dummy, 0 sinon',...
                'Nombre maximal d''harmoniques prises en compte'});

%% Retour de la structure pour verification si appel sans arguments
if nargin==0
    v_in_mat=vc_options_desc;
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
v_Nrep=vs_method_options.Nrep;
v_M=vs_method_options.M;
v_flag_dummy=vs_method_options.FlagDummy;
v_Ns_ini=vs_method_options.NsIni;
v_Seed=vs_method_options.Seed;
v_n=vs_factors_def.Nb;
vc_distribution=vs_factors_def.Dist;
vc_distr_param=vs_factors_def.DistParams;

% Verification du nombre de phi
if (v_Nrep<=0)
   error('Erreur : Nrep doit etre superieur a 0.');
end  

% Ajout du parametre Dummy dans les vecteurs v_cdf_p1,v_cdf_p2 et
% v_distribution_law si necessaire
if v_flag_dummy
    vc_distribution{end+1}='uniform';
    vc_distr_param{end+1}=[0,1];
    v_n=v_n+1;
end

% Initialisation
v_c1=1./pi; 

% Initialisation de l'algorithme de tirage aleatoire
F_rand_init(v_Seed);

% Verification de la taille de l'echantillon

if (v_Ns_ini<(2*v_M)^2+1)
   error(['La taille de l''echantillon est trop faible : elle doit etre superieure a ' int2str((2*v_M)^2+1)]);
end

% Calcul de la taille de l'echantillon pour le calcul des effets totaux
% v_Ns-1 doit etre un multiple de (2*v_M)^2 pour la definition
% des frequences (formules (28) et (30)).
v_Ns=(v_Ns_ini-mod(v_Ns_ini-1,(2*v_M)^2));

% Variations du parametre s dans ]-pi,pi[ (formule 20).
v_step_s=2*pi/v_Ns;
for i=1:v_Ns
   v_s(i)=-pi+pi/v_Ns+(i-1)*v_step_s;
end

% Calcul de la frequence maximale et de la liste de frequence
% a partir de la taille de l'echantillon selon l'algorithme presente
% section IV.3
v_wmax=(v_Ns-1)/(2*v_M);
v_step_w=floor((v_wmax/(2*v_M))/v_n);
if v_step_w==0   % cas ou plusieurs frequences sont identiques mais 
    v_step_w=1;  % differentes de 1
end
v_max_wmi=v_wmax/(2*v_M);
v_w_tmp(1)=1;
for i=2:v_n
    if (v_w_tmp(i-1)==v_max_wmi)
        v_w_tmp(i)=1;
    else
        v_w_tmp(i)=v_w_tmp(i-1)+v_step_w;
    end
end

v_indmin=1;

% Boucle sur le nombre de replicats
for i=1:v_Nrep
        
   % tirage aleatoire du shift phi
   v_phi=rand(v_n,1)*2*pi;
   %v_phi=zeros(v_n,1);
        
   for j=1:v_n

      % Mise a jour de la liste de frequence
      v_w=v_w_tmp;
      v_w(j)=v_wmax;

      v_indmax=v_indmin+v_Ns-1;

      % Creation des variants normalises.
      % Utilisation de la fonction de transformation Gi definie formule (7)
      % et du changement de variable definis formule (31)
      for k=1:v_n-v_flag_dummy
         v_in_mat(v_indmin:v_indmax,k)=0.5+v_c1*asin(sin(v_w(k)*v_s+v_phi(k)));
      end
            
      % Transformation dans l'espace des parametres a partir des lois choisies
      % par l'utilisateur      
      for k=1:v_n-v_flag_dummy
         [v_flag_truncated, v_in_mat(v_indmin:v_indmax,k)]=F_inverse_cdf(vc_distribution{k},vc_distr_param{k},v_in_mat(v_indmin:v_indmax,k));
         F_create_message(['Facteur ' num2str(k)],...
            'La methode ne fonctionne pas avec les distributions tronquees.',...
            v_flag_truncated,1);
      end 
            
      v_indmin=v_indmax+1;

   end 

   % On reaffecte a v_w la liste originale, la frequence maximale etant 
   % stockee en v_w(1) (v_w_tmp(1) valant toujours 1 ...)
   v_w=v_w_tmp;
   v_w(1)=v_wmax;
   
end
