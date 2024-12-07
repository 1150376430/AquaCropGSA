function F_stics_files_obs2csv(vc_files_or_dir,v_file_ext)
%F_STICS_FILES_OBS2CSV  Transformation de fichiers obs/repertoire en csv
%   F_stics_files_obs2csv(vc_files_or_dir,v_file_ext)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - vc_files_or_dir: fichier, repertoire, liste de fichiers
%      - v_file_ext: extension ('.obs par defaut, si non fourni)
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - 
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 15-Apr-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_stics_obs2csv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<1 
    F_disp('Aucun fichier ou reertoire specifie en entree !');
    return
end

% On fixe l'extension par defaut
if nargin<2
    v_file_ext='.obs';
end

% Repertoire
if ischar(vc_files_or_dir) && isdir(vc_files_or_dir)
    vs_files_list=dir([vc_files_or_dir filesep '*' v_file_ext]);
    if isempty(vs_files_list)
        return
    end
    % Filtrage des fichiers deja transformes contenant v_trans_suf_ext
    v_trans_suf_ext=F_stics_obs2csv;
    vs_files_list=vs_files_list(cellfun(@(x) isempty(strfind(x,v_trans_suf_ext)),{vs_files_list.name}));
    vc_files_list=arrayfun(@(x) {fullfile(vc_files_or_dir,x.name)},vs_files_list);
% Liste de fichiers/chemins
elseif iscell(vc_files_or_dir)
    vv_exist=cellfun(@(x) exist(x,'file'),vc_files_or_dir)>0;
    vc_files_list=vc_files_or_dir(vv_exist);
% Fichier/chemin
elseif ischar(vc_files_or_dir)
    vc_files_list={vc_files_or_dir};
end

% Transformation
for i=1:length(vc_files_list)
    F_stics_obs2csv(vc_files_list{i});
end
