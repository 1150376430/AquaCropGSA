%% Morris Method 
function [v_in_mat,v_in_mat_real,v_out_mat,vs_indices,CC_m]=Morris(fileinput,vs_factors_def,Param,v_lib_dir)
 % Morris Method for Sensitivity Analysis
%% Modelli per analisi di Sensitività, creazione  delle r traiettorie 
%  (vedi Campolongo et al. 2007)
% INPUT 
% fileinput:
% vs_factors_def:
% Param: 
% v_lib_dir
%  MORRIS
%  Input per Morris
%   - vs_method_options : struttura di definizione delle opzioni del metodo
%                   o   vs_method_options.p : numero di colonne (livelli) della griglia regolare.
%                       Tipo: scalare se tutti i fattori hanno lo stesso numero di colonne   
%                       (livelli), vettore di dimensione pari al numero di fattori se il 
%                       numero di livelli è differente per ciascun fattore
%                   o   vs_method_options.n : (OPTIONNEL) rapporto Delta/dimensione di un 
%                       pas. (?) () (taille valant 1/(p-1))
%                       ATTENZIONE: non può essere superiore o uguale a p
%                       Valore di default : 2. (anche se nell’esempio Demo
%                       è 1…) DEVE ESSERE UN NUMERO INTERO
%                       Tipo: scalare se tutti i fattori hanno lo stesso numero di colonne
%                       (livelli), vettore di dimensione pari al numero di fattori se il 
%                       numero di livelli è differente per ciascun fattore
%                   o   vs_method_options.r : numero di traiettorie (tipo: scalare)
%                   o   vs_method_options.Q : (Opzionale) numero del gruppo di r      
%                       traiettorie sulle quali si effettua la selezione delle r             
%                       traiettorie (tipo: scalare). Valore di default : 100 . (Demo = 50, 
%                       M in Campolongo et al., con valori tra 500 e 1000…)
%                   o vs_method_options.incert : (OPTIONNEL) metodo di stima delle incertezze sugli indici calcolati: ‘bootstrap’ …
%                   o vs_method_options.m : (OPTIONNEL) …   
% 
vs_method_options.p =  fileinput.vs_method_options.p;
vs_method_options.n = fileinput.vs_method_options.n ; 
vs_method_options.r = fileinput.vs_method_options.r ; 
vs_method_options.Q = fileinput.vs_method_options.Q ;
% vs_method_options.m = fileinput.vs_method_options.m ;
% vs_method_options.incert = fileinput.vs_method_options.incert;   

p=vs_method_options.p;
k=vs_factors_def.Nb;

vs_method_options.graph = 1;            % non so a cosa serve... 
v_in_mat = F_gen_variant_Morris(vs_factors_def,vs_method_options);
%   Trasformazione da ipercubo unitario a iperspazio "reale": 
%   Creazione della matrice v_in_mat_real. Questa matrice contiene i punti dell'iperspazio (in valori reali)
%   calcolati tramite il metodo OAT (che invece richiede valori unitari) 
%   Struttura: v_in_mat_real(r*(k+1),p)

v_in_mat_real=F_conv_int01_to_real(Param,v_in_mat,k,p);

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
 [CC_m,Yield_m]=F_Aquacrop_multipleIn(N,Paths);         
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

%% Calcolo degli indici di Morris
[vs_indices.vm_F, vs_indices.vm_G, vs_indices.vm_mu, vs_indices.vm_sigma, vs_indices.vm_mu_star, vs_indices.vm_mu_uncert, vs_indices.vm_sigma_uncert, vs_indices.vm_mu_star_uncert] = F_sensi_analysis_Morris(v_in_mat, v_out_mat, vs_factors_def, vs_method_options);
