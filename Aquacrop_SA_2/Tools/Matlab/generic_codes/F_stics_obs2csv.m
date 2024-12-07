function [vm_data_obs, vc_col_names]=F_stics_obs2csv(v_obs_filepath,v_var_mod_filepath,v_csv_filepath)
%F_STICS_OBS2CSV Transformation fichier obs Stics au format csv
%   [vm_data_obs,vc_col_names]=F_stics_obs2csv(v_obs_filepath,
%                             v_var_mod_filepath,v_csv_filepath)
%  
%   ENTREE(S):
%      - v_obs_filepath : chemin du fichier obs
%      - v_var_mod_filepath : chemin du fichier 'var.mod' du modele
%      contenant la liste des noms de variables
%      - v_csv_filepath: chemin du fichier csv a creer (optionnel)
%  
%   SORTIE(S):
%      - vm_data_obs: matrice des dates+valeurs observees (valeurs
%      manquantes codees par -999)
%      - vc_col_names: noms des colonnes de vm_data_obs
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_get_var_list
%      - F_export_csv
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_stics_obs2csv('fichier.obs','var.mod');
%      - F_stics_obs2csv('fichier.obs','var.mod','fichierobscsv.csv')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 25-Jun-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_export_csv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisations
% Suffixe a concatener avec le nom du fichier d'origine
v_trans_suf_ext='_csv.obs';
if ~nargin
    vm_data_obs=v_trans_suf_ext;
    return
end
vm_data_obs=[];
vc_col_names={};


% liste des variables: fixe pour les versions 5,6
vc_default_var_list={'lai(n)' ; 'masec(n)' ; 'mafruit' ; 'HR(1)' ; 'HR(2)' ; 'HR(3)' ; 'HR(4)' ;...
    'HR(5)' ; 'resmes' ; 'drain' ; 'esol' ; 'et' ; 'zrac' ; 'tcult' ; 'AZnit(1)' ; 'AZnit(2)' ;...
    'AZnit(3)' ; 'AZnit(4)' ; 'AZnit(5)' ; 'QLES' ; 'QNplante' ; 'azomes' ; 'inn' ; 'chargefruit' ;...
    'AZamm(1)' ; 'AZamm(2)' ; 'AZamm(3)' ; 'AZamm(4)' ; 'AZamm(5)' ; 'CNgrain' ; 'concNO3les' ; 'drat' ;...
    'fapar' ; 'hauteur' ; 'Hmax' ; 'humidite' ; 'lrach(1)' ; 'lrach(2)' ; 'lrach(3)' ; 'lrach(4)' ; ...
    'lrach(5)' ; 'mafrais' ; 'pdsfruitfrais' ; 'Qdrain' ; 'rnet'};

% Verif. args entree
if nargin<1
    disp('Arguments insuffisants')
    disp('Au minimum: nom fichier obs, liste des variables du fichier');
    return;
end
% on fourni ou pas le chemin du fichier var.mod
if nargin<2
    vc_var_list=vc_default_var_list;
else
    % extraction des noms des variables 
    vc_var_list=F_get_var_list(v_var_mod_filepath);
end

% Traitement du nom du fichier de sortie
if nargin>2 && ischar(v_csv_filepath)
    v_csv_file=v_csv_filepath;
else % creation du nom du fichier
    vs_fparts=F_file_parts(v_obs_filepath);
    % nom du fichier csv par defaut
    v_csv_file=fullfile(vs_fparts.dir,[vs_fparts.name v_trans_suf_ext]);
end

try  
    if ~exist(v_obs_filepath,'file')
        error('Le fichier %s n''existe pas !',v_obs_filepath);
    end
    % Verification du format : si csv on sort
    v_fid=fopen(v_obs_filepath,'r');
    v_line=fgetl(v_fid);
    fclose(v_fid);
    if ~isempty(strfind(v_line,';'))
       error('Le fichier %s est deje au format csv !',v_obs_filepath); 
    end
    % le fichier existe deje
    if exist(v_csv_file,'file')
        error('Le fichier %s existe deje !',v_csv_file); 
    end
    % extraction des donnees du fichier obs 
    [vm_data, v_var_names,v_str_dates] = F_read_data_file(v_obs_filepath,'obs',vc_var_list);
	
	if isempty(vm_data), error('Le fichier %s ne contient pas de donnees',v_obs_filepath); end
    % Extraction de la matrice des dates (qui sont retournees en
    % caracteres: v_str_dates
    v_dates=cell2mat(cellfun(@(x) textscan(x,'%f','delimiter','/'),v_str_dates))';
    % tri colonnes : annee, mois, jour
    v_dates=v_dates(:,end:-1:1);
    % calcul du numero de jour dans l'annee
    v_jul=datenum(v_dates(:,1),v_dates(:,2),v_dates(:,3))-datenum(v_dates(:,1),1,1)+1;
    % creation cell nom des lignes pour exportation csv
    v_years=arrayfun(@(x) num2str(x),v_dates(:,1),'UniformOutput',false);
    % Affectation des arg de sortie
    vm_data_obs=[v_dates v_jul vm_data'];
    vc_col_names={ 'ian' 'mo' 'jo' 'jul' v_var_names{:}};
    % Creation du fichier csv
    F_export_csv(v_csv_file,vm_data_obs(:,2:end),v_years,{vc_col_names{2:end}},'ian');
    
catch le
    disp('Le fichier n''a pu etre genere ...');
    disp('Cf. message suivant:')
    fclose all;
    disp(le.message);
end



function vc_var_list = F_get_var_list(v_file_path_varmod)

% Ouverture et lecture du fichier
v_fid=fopen(v_file_path_varmod,'r');
% Lecture de la premiere colonne seulement  = nom des variables de sortie
vc_var_list=textscan(v_fid, '%s%*[^\n]');
vc_var_list=vc_var_list{1};
fclose(v_fid);
