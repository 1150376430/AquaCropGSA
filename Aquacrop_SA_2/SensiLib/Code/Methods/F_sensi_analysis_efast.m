function [v_S,v_ST]=F_sensi_analysis_efast(vs_method_options,v_out_mat)
% Calcul des indices se sensibilite avec la methode FAST.
%
% Cette fonction sert a calculer les indices de sensibilite principaux de 
% 1er ordre et les indices de sensibilite totaux selon la methode Extended 
% Fast. Cette methode est decrite en detail dans le document 
% "La methode FAST et ses extensions" qui servira de reference dans les 
% commentaires suivants (notamment pour les formules utilisees).
%
% ENTREES :
%
%      - vs_method_options : structure de definition des options de la
%        methode
%          o vs_method_options.NsIni : scalaire entier contenant la taille de
%            l'echantillon souhaitee par l'utilisateur. Cette taille doit 
%            etre superieure ou egale a 65.
%            Le calcul des frequences a partir de Ns impose que 
%            (Ns-1) soit un multiple de (2*M)^2). Si tel n'est pas le
%            cas pour NsIni, on prendra le plus grand no inferieur a 
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
%          o vs_method_options.M (OPTIONNEL) : nombre maximal d'harmonique
%            pris en compte dans la methode.
%            Vaut 4 par defaut.
%        ATTENTION : les valeurs de ces options doivent etre identiques a
%        celles donnees en argument de F_gen_variant_efast.
%
%       - v_out_mat : 
%          matrice de type flottant de taille : 
%             no de simulations * no de variables
%          contenant les valeurs des sorties du modeles correspondant aux 
%          variants generes par F_gen_variant_efast. 
%
%
% SORTIE :
%       - v_S : 
%          tableau de type flottant de taille 
%            Nrep * no de parametres * no de variables de sortie, 
%          contenant les differents replicats des indices principaux de 
%          1er ordre calcules pour les differentes variables de sortie par 
%          rapport aux differents parametres variants. 
%
%       - v_ST : 
%          tableau de type flottant de taille 
%            Nrep * no de parametres * no de variables de sortie, 
%          contenant les differents replicats des indices totaux calcules 
%          pour les differentes variables de sortie par rapport aux 
%          differents parametres variants.
%
%       ATTENTION : si l'option "parametre dummy" a ete choisie dans
%       F_gen_variant_efast, v_S(:,no de parametres+1,:) et v_ST(:,no de
%       parametres+1,:) contiendront les indices calcules pour ce
%       parametre. 
%       Les valeurs de v_S(:,no de parametres+1,:) devraient etre 
%       negligeables. Si ce n'est pas le cas, recommencer l'analyse avec une 
%       taille d'echantillon superieure. Les indices principaux des parametres 
%       qui ont une valeur inferieure a celles des indices principaux du
%       parametre dummy, doivent etre consideres comme negligeables.
%       Les valeurs de v_ST(:,no de parametres+1,:) donnent les 
%       parts de variance qui ne peuvent pas etre affectees aux variations 
%       des parametres. Cette part devrait etre retiree des indices totaux
%       des autres parametres.
%
% CONTENU :
%        On commence par calculer la taille de l'echantillon, les
%        variations de s et la liste de frequence, comme dans
%        F_gen_variant_efast.
%        Puis, pour chaque variable consideree, pour chaque replicats, et 
%        chaque facteur :
%              - mise a jour de la liste des frequences (la frequence 
%                maximum est affectee au parametre pour lequel on calcule 
%                les effets, les frequences des autres parametres etant 
%                issue de la liste de frequence calculee au debut) ;
%              - calcul de la transformee de Fourier et des coeff. de
%                Fourier ;
%              - calcul des variances totales et partielles ;
%              - calcul des indices totaux et principaux.
%        Le calcul des indices est detaille dans la documentation associee.        
%
% AUTEUR : S. BUIS ET H.V VARELLA 
%         (merci a J.Jacques et C.Naud pour leurs contributions)
% DATE : 04-mai-2007
% VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition du tableau contenant les options de la methode
vc_options_desc=struct('name',{'NsIni','Nrep','M'},...
    'datatype',{'uint32','uint32','uint32'},...
    'status',{'non optional','optional','optional'},...
    'defaultvalue',{[],1,4},...
    'comments',{'Taille de l''echantillon souhaitee par l''utilisateur', ...
                'Nombre de replicat de la methode',...
                'Nombre maximal d''harmoniques prises en compte'});

%% Retour de la structure pour verification si appel sans arguments
if nargin==0
    v_S=vc_options_desc;
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
v_Nrep=vs_method_options.Nrep;
v_M=vs_method_options.M;
v_Ns_ini=vs_method_options.NsIni;

% Calcul de la taille de l'echantillon pour le calcul des effets totaux
% v_Ns-1 doit etre un multiple de (2*v_M)^2 pour la definition
% des frequences (formules (28) et (30)).
v_Ns=(v_Ns_ini-mod(v_Ns_ini-1,(2*v_M)^2));

% Initialisation
v_C=size(v_out_mat,1);
v_n=v_C/(v_Ns*v_Nrep);
if v_n<=1
    v_out_mat=v_out_mat';
    v_C=size(v_out_mat,1);
    v_n=v_C/(v_Ns*v_Nrep);    
    if v_n<=1
        error(['L''argument v_out_mat n''a pas la taille attendu.'])
    end
end
v_nb_var=size(v_out_mat,2);

v_S=zeros(v_Nrep,v_n,v_nb_var);
v_ST=zeros(v_Nrep,v_n,v_nb_var);

% Calcul de la frequence maximale et de la liste de frequence
% a partir de la taille de l'echantillon selon l'algorithme presente 
% section IV.3
v_wmax=(v_Ns-1)/(2*v_M);

% Boucle sur le no de variables de sorties a analyser
for ivar=1:v_nb_var

    v_indmin=1;
    
    % Boucle sur l'aleas du shift phi
    for i=1:v_Nrep
       
        % Boucle sur le no de facteurs
        for j=1:v_n

            % Calcul de la transformee de Fourier. On n'utilise pas les
            % formules definies en (21) pour le calcul des coef. de Fourier
            % Aj et Bj, mais la fonction fft2 de matlab qui permet de 
            % calculer ces quantites de facon beaucoup plus efficace.   
            v_indmax=v_indmin+v_Ns-1;
            v_F=fft2(v_out_mat(v_indmin:v_indmax,ivar));
            v_indmin=v_indmax+1;

            % Calcul des coefficients de Fourier
            v_kmax=((v_Ns)-1)/2;
            for k=1:v_kmax
                v_a(k)=real(v_F(k+1))/v_Ns;
                v_b(k)=imag(v_F(k+1))/v_Ns;
            end

            % Calcul du spectre de v_F de 1 a (Ns-1)/2
            v_Spectre=v_a.^2+v_b.^2;
            
            % Calcul de la variance totale (formule (22)).
            v_D=2*sum(v_Spectre);

            % Calcul de la variance expliquee par le facteur j (formule
            % (23))
            v_Di=2*sum(v_Spectre(v_wmax:v_wmax:v_M*v_wmax));

            % Calcul de la variance expliquee par les facteurs 
            % complementaires (formule (18))  
            v_Dmi=2*sum(v_Spectre(1:v_wmax/2));
           
            % Calcul des indices totaux et principaux 
            if abs(v_D)<=eps(0.)
                v_ST(i,j,ivar)=0;
                v_S(i,j,ivar)=0;
            else
                v_ST(i,j,ivar)=1-v_Dmi/v_D;
                v_S(i,j,ivar)=v_Di/v_D;
            end
        end
      
    
    end
        
end
