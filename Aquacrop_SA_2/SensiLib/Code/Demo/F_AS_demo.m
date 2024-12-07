function [vs_indices,v_out_mat,v_in_mat]= F_AS_demo(v_lib_dir)
% Test des m�thodes d'analyse de sensibilit�. 
%Test dei metodi di analisi di sensibilit�
%  
% Cette fonction permet de tester les m�thodes d'analyse de sensibilit� sur les
% diff�rents mod�les tests impl�ment�s. Pour changer le mod�le ou la
% m�thode test� il faut commenter/d�commenter les lignes correspondantes
% dans le script.
%
% Questa funzione permette di testare i metodi di analisi di sensibilit�
% sui differenti modelli test implementati. Per cambiare il modello o il
% metodo da testare, commentare/decommentare le linee corrispondenti nello
% script. 
%
%
%   CONTENU : 
%     - D�finition des lois de distributions des facteurs d'entr�e et de leur
%       param�tres selon le mod�le utilis� ;
%     - D�finition des param�tres de la m�thode utilis�e et appel de la 
%       fonction de g�n�ration des variants
%     - Appel du mod�le � analyser pour l'�chantillon de variant g�n�r�
%       v_in_mat
%     - Appel � la fonction de calcul des indices de sensibilit�
%   
%   CONTENUTO :
%     - Definizione delle leggi di distribuzione dei fattori di input e
%       dei loro parametri a seconda del modello utilizzato ;
%     - Definizione dei parametri del metodo utilizzato e richiamo della
%       funzione di generazione delle varianti
%     - Richiamo del modello da analizzare per il campione della variante
%       generata v_in_mat
%     - Richiamo della funzione di calcolo degli indici di sensitivit�
% 
%   ENTREES :
%
%     - v_lib_dir : chemin d'acc�s � la biblioth�que SensiLib.
%
%   INPUT  :
%
%     - v_lib_dir : path della cartella Sensilib
%
%   APPEL(S): liste des fonctions appel�es
%   RICHIAMI: lista delle funzioni richiamate
%      - F_gen_variant_efast
%      - F_jumping_man
%      - F_ishigami
%      - F_g_function
%      - F_sensi_analysis_efast
%      - F_gen_variant_Morris 
%      - F_sensi_analysis_Morris
%
%  
%  AUTEUR(S): S. Buis
%  DATE: 31-Aug-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-08-01 15:24:54 +0200 (jeu., 01 août 2013) $
%    $Author: sbuis $
%    $Revision: 71 $
%  
%  
% See also F_gen_variant_efast, F_jumping_man, F_ishigami, F_g_function,
% F_sensi_analysis_efast 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vs_indices=[];                                     % vettore vuoto

%% Path 
% (Dichiarazione dei percorsi)

% Ajout des r�pertoires contenant les fonctions de Sensilib dans le PATH
% Matlab.
addpath(fullfile(v_lib_dir,'SensiLib\Code\Tools'),'-end');
addpath(fullfile(v_lib_dir,'SensiLib\Code\Methods'),'-end');
addpath(fullfile(v_lib_dir,'SensiLib\Code\Models'),'-end');
addpath(fullfile(v_lib_dir,'Tools\Matlab\generic_codes'),'-end');

%% Legge di didistribuzione dei fattori di input
%Definizione delle leggi di distribuzione dei fattori d'entrata e dei loro
%parametri socondo il modello utilizzato degli eventuali parametri dei
%modelli
%
% D�finition des lois de distributions des facteurs d'entr�e et de leur
% param�tres selon le mod�le utilis� et des �ventuels param�tres des
% mod�les
%

%    Jumping man
%vs_factors_def.DistParams={[40,60],[67,74],[20,40]};
%vs_factors_def.Nb=3;

%    Ishigami
%vs_factors_def.DistParams={[-pi pi]};
%
% vs_factors_def.Nb=3;
 
%    G-function
vs_factors_def.Nb=8;

%    Fang 
%vs_factors_def.Dist={'exponential','weibull','normal','beta','gamma'};
%vs_factors_def.DistParams={[0.5],[1.5,3],[0,sqrt(0.25)],[1.5 2.5 0 1],[3.5,0.5]};

%% Modelli SA
% Generazione delle Varianti
%
% G�n�ration des variants

%FAST
vs_method_options.NsIni=1250;
vs_method_options.Nrep=5;
[v_in_mat,v_Ns,v_w]=F_gen_variant_efast(vs_factors_def,vs_method_options);

% % MORRIS
% vs_method_options.p = 8;
% vs_method_options.n = 1 ; 
% vs_method_options.r = 10 ; 
% vs_method_options.Q = 50;
% %vs_method_options.m = 10 ;
% %vs_method_options.incert = 'r�plication';
% vs_method_options.graph = 1;
% v_in_mat = F_gen_variant_Morris(vs_factors_def,vs_method_options);

% Appel du mod�le � analyser pour l'�chantillon de variant g�n�r�

%    Jumping man
%v_out_mat=F_jumping_man(v_in_mat);

%    Ishigami
%v_out_mat=F_ishigami(v_in_mat);

%    G-function 
v_a=[0;1;4.5;9;99;99;99;99];
%v_a=[99;0;9;0;99;4.5;1;99];
%v_a=zeros(length(v_cdf_p1),1);
%v_a=[0.;0.;3.;9.;9.;9.;9.;9.];
%v_a=ones(length(v_cdf_p1),1)*99;
v_out_mat=F_g_function(v_in_mat,v_a);
v_out_mat=[v_out_mat,v_out_mat];

% Fang
% v_out_mat=F_Fang(v_in_mat);

% Calcul des indices de sensibilit�
[vs_indices.v_S,vs_indices.v_ST]=F_sensi_analysis_efast(vs_method_options,v_out_mat);
% [vs_indices.vm_F, vs_indices.vm_G, vs_indices.vm_mu, vs_indices.vm_sigma, vs_indices.vm_mu_star, vs_indices.vm_mu_uncert, vs_indices.vm_sigma_uncert, vs_indices.vm_mu_star_uncert] = F_sensi_analysis_Morris(v_in_mat, v_out_mat, vs_factors_def, vs_method_options);