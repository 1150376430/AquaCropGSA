%% Extended FAST method
function [v_in_mat,v_Ns,v_w,v_in_mat_real,v_out_mat,vs_indices,Lai_m]=EFAST(fileinput,vs_factors_def,Param,v_lib_dir)

% EFAST Method for Sensitivity Analysis
% Generazioen delle traiettorie per il metodo EFAST
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
% INPUT :
vs_method_options.NsIni=fileinput.vs_method_options.EFAST.NsIni;
vs_method_options.Nrep=fileinput.vs_method_options.EFAST.Nrep;


% OUTPUT 1 :
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
[v_in_mat,v_Ns,v_w]=F_gen_variant_efast(vs_factors_def,vs_method_options);
 
v_in_mat_real=F_conv_unit2real_EFAST(v_in_mat,Param);

%% Aquacrop
%  Calcolo del CC tramite Aquacrop
N=length(v_in_mat_real(:,1));  % N=r(k+1)
Law=v_in_mat_real';

 %% AC 1. Generazione dei file .txt, Input di Aquacrop. Tali file vengono salvati in 
 %  C:\Users\PaoloCosmo\Documents\Dottorato\Sensitivity Analysis\Aquacrop_SA\Aquacrop_plugin\LIST
 %  generation of corresponding N input files for running Aquacrop until T1

    % First day of simulation         
    spidd=cell2mat(fileinput.simdate.first(1));          %giorno (dd) formattato come richiesto dalla funzione dataconv.m 
    spimm=cell2mat(fileinput.simdate.first(2));          %mese (mm) da scrivere come richiesto in dataconv (jan,feb,mar,etc.)
    spiyy=cell2mat(fileinput.simdate.first(3));          %anno (yy)     
    Ini_sim= dataconv(spidd,spimm,spiyy); %First day of simulation 

    % Last day of simulation         
    endDay=cell2mat(fileinput.simdate.last(1));
    endMonth=cell2mat(fileinput.simdate.last(2));
    endYear=cell2mat(fileinput.simdate.last(3)); 
    Fin_sim= dataconv(endDay,endMonth,endYear); %Last day of simulation 
    crfdd=cell2mat(fileinput.cropdate.last(1)); %Last day of crop
    crfmm=cell2mat(fileinput.cropdate.last(2));
    crfyy=cell2mat(fileinput.cropdate.last(3));
    End_crop= dataconv(crfdd,crfmm,crfyy);
    
   [Paths]=f_in_aquacrop(fileinput,endDay,endMonth, Param, Law) ; %generates Aquacrop input files

%% LAI & Yield

%   Lancio del Plugin di Aquacrop. Il programma verrà lanciato N volte, dove N è il numero di file .pro precedentemente elaborati.      
   
    
    cd(cell2mat(Paths(4,1)))
    dos ACsaV40.exe            %AquaCrop Plug-In running
    cd(v_lib_dir)

% LAI & Yield
% Stima di LAI e Yield (funzione giornaliera) per ogni punto dell'iperspazio.   
 [Lai_m,Yield_m]=F_Aquacrop_multipleIn(N,Paths);         
% Creazione del vettore v_out_mat.
% La struttura è quella richiesta da F_sensi_analysis_Morris. E' composto
% da tutti i massimi di Yield. Ad ogni punto dell'iperspazio (set di
% parametri) corrisponde un solo Yield MAX (espresso appunto in v_out_mat)
v_out_mat(1:length(Yield_m(:,1)))=0;
v_out_mat=v_out_mat';
for i=1:length(Yield_m(:,1))
v_out_mat(i)=max(Yield_m(i,:));
end

v_out_mat=[v_out_mat,v_out_mat];               % non so perché...


%% Calclolo degli indici di EFAST
[vs_indices.v_S,vs_indices.v_ST]=F_sensi_analysis_efast(vs_method_options,v_out_mat);



