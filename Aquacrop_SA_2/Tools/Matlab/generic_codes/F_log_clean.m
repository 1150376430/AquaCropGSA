function F_log_clean(v_in_dir,v_log_path)
%F_LOG_CLEAN  Deplacement des fichiers *.log d'une arborescence de dossiers
%  vers un sous-repertoire LOG 
%   F_log_clean(v_in_dir)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_in_dir: repertoire source
%      - v_log_path: optionnel, repertoire de stockage des fichiers log
%        (cas appel recursif, sous-repertoires)
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
%  DATE: 05-Oct-2012
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-06 09:40:28 +0200 (jeu., 06 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 910 $
%  
% See also F_read_config,F_get_abspath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2
    v_log_path=F_get_abspath(fullfile(v_in_dir,'LOG'));
end

if ~exist(v_log_path,'dir')
    mkdir('LOG')
end

v_in_dir=F_get_abspath(v_in_dir);
if strcmp(v_log_path,v_in_dir)
    return
end

vs_dir=dir(v_in_dir);

% Selecting sub dirs
vs_dir= vs_dir(cellfun(@isempty,strfind({vs_dir.name},'.')) & [vs_dir.isdir]);
% Recursive call for subdirs
for i=1:length(vs_dir)
   F_log_clean(fullfile(v_in_dir,vs_dir(i).name),v_log_path); 
end
% Moving *.log files to v_log_path
% log files list
vs_log_dir=dir([v_in_dir filesep '*.log']);
%
% If a log file is already active, filtering it
if F_log
    v_filter=~ismember({vs_log_dir.name},F_log('name'));
    vs_log_dir=vs_log_dir(v_filter);
end
% moving files
arrayfun(@(x) movefile(fullfile(v_in_dir,x.name),v_log_path),vs_log_dir);

