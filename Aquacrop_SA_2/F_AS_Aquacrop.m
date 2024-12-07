function [vs_indices,v_out_mat,v_in_mat,v_in_mat_real,LAI_m]= F_AS_Aquacrop(fileinput,Param)
%% Funzione che effettua l'analisi di sensitività tramite i metodi di Morris e EFAST per il modello Aquacrop

% INPUT: 
% fileinput : file .mat contenente tutti gli input richiesti. Prendere come
%             riferimento fileinput_ref.mat
% Param     : file . mat contenente il valore nominale dei parametri del
%             modello. I parametri qui scelti saranno quelli 
%             che Campolongo et al. 2007 definiscono: imput factors. 
%             Vedere struttura di riferimento Param_ref. 
%          
%% OUTPUT:  
% vs_indices : Indici (diversi a secondo del metodo scelto) che permettono
% di stabilire se un Parametro è influente
% v_out_mat : Per Aquacrop gli output sono LAI e Biomass
% v_in_mat : 
%           Per Morris: gruppo di r triettorie di distanza interna massimale
%            Tipo: matrice di dimensioni (r*(Nb+1),Nb). Creato tramite
%            F_gen_variant_Morris(vs_factors_def,vs_method_options),
%            vs_factors_def e vs_method_options sono definiti in fileinput.
%            Seguono le caratteristiche descritte nello script
%            F_gen_variant_Morris, (INPUT).
%           Per EFAST: ... (vedere F_gen_variant_efast)  
%% PATH
v_lib_dir=pwd;
addpath(genpath(v_lib_dir));

%% Legge di didistribuzione dei fattori di input
%  MORRIS
%   - vs_factors_def : struttura di definizione dei fattori 
%                      E' DEFINITO IN: fileinput.vs_factors_def.mat, sottostruttura composta da:  
%                  o  vs_factors_def.Dist (Opzionale) :  vettore cella contenente il tipo di distribuzione   
%                       per ogni fattore. Per vedere la lista delle distribuzioni disponibili eseguire la  
%                       funzione F_create_sample() senza argomento 
%                       ATTENZIONE: per utilizzare delle leggi oltre che le leggi uniforme 
%                       e triangolare è necessario avere il toolbox matlab “statistics”.   
%                       il metodo non funziona con la distribuzione discreta
%                       se questo campo non è specificato le distribuzioni saranno tutte uniformi
%                       se il vettore contiene una sola distribuzione, allora tutti i fattori avranno la stessa 
%                       distribuzione.
%                       IN QUESTI 2 CASI IL CAMPO Nb DOVRA’ ESSERE SPECIFICATO
%                   o  vs_factors_def.DistParams (Opzionale): vettore cella contenente il vettore dei 
%                        parametri della distribuzione per ciascun fattore.
%                        Per vedere la lista dei parametri richiesti per ciascuna distribuzione disponibile, 
%                        eseguire la funzione F_create_sample() senza argomento 
%                        IN QUESTI 2 ULTIMI CASI IL CAMPO Nb DOVRà ESSERE SPECIFICATO
%                   o   vs_factors_def.Nb (Opzionale) : scalare contenente il numero dei fattori (k in Campolongo et al.)
%                       Obbligatorio se il campo Dist non è precisato, è vuoto o contiene una sola distribuzione.
%  EFAST 
%   - vs_factors_def : structure di definizione de fattori
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



% INPUT
vs_indices=[];         % vettore vuoto

k=length(Param.num(:,3));
fileinput.vs_factors_def.Nb=k;
vs_factors_def.Nb=k;



% Method
% Condizione che determina la scelta del Metodo (Morris o EFAST)
mor=strcmp('Mor',fileinput.SensAna.char);
if mor==1
[v_in_mat,v_in_mat_real,v_out_mat,vs_indices,LAI_m]=Morris(fileinput,vs_factors_def,Param,v_lib_dir);
else
    efa=strcmp('EF',fileinput.SensAna.char);
   if efa==1
       [v_in_mat,v_Ns,v_w,v_in_mat_real,v_out_mat,vs_indices,LAI_m]=EFAST(fileinput,vs_factors_def,Param,v_lib_dir);
   else 
       v_in_mat=0;v_in_mat_real=0;v_out_mat=0;vs_indices=0;LAI_m=0;
       disp 'fileinput.SensAna.char must be 'Mor' or 'EF' '
   end
end
