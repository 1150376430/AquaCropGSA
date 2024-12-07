function vs_file = F_file_parts(v_file_path,varargin)
%F_FILE_PARTS  Extraction des parties du chemin d'un fichier/repertoire
%   vs_file = F_file_parts(v_file_path[,v_target_part,v_path_type])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_file_path : chemin, nom d'un fichier
%      - optionnels:
%         - v_target_path : mot cle parmi 'dir', 'name','ext','versn' pour
%         extraire une partie specifique du chemin
%         - v_path_type : mot cle 'abs' pour recalcul du chemin absolu du
%         fichier (par defaut le chemin est relatif,'rel')
%  
%   SORTIE(S): 
%      - vs_file:
%         * si v_target_part est fourni : valeur correspondante
%         * sinon: structure avec les champs correspodants aux differentes
%         parties du chemin extraites
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): 
%      - F_get_abspath
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      v_file_name=F_file_parts(v_file_path,'name')
%      vs_file = F_file_parts(v_file_path)
%      v_file_dir=F_file_parts(v_file_path,'dir','abs')
%      vs_file = F_file_parts(v_file_path,'abs')
%
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 18-Nov-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also F_get_abspath, fileparts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisations
v_path_type='rel';
v_target_part='';
vs_file=struct;

% Traitement des args optionnels
for i=1:length(varargin)
    if ismember(varargin{i},{'dir','name','ext'})
        v_target_part=varargin{i};
    end
    if ismember(varargin{i},{'rel','abs'})
        v_path_type=varargin{i};
    end
end

% Suppression filesep(s) en fin de chaine du chemin
v_file_path=F_detrail(v_file_path,0,filesep);

% Recalcul du chemin absolu
if strcmp(v_path_type,'abs')
    v_file_path=F_get_abspath(v_file_path);
end
% Extraction des parties du chemin
[vs_file.dir,vs_file.name, vs_file.ext] = fileparts(v_file_path);
% Calcul de l'argument de retour
if ~isempty(v_target_part) && isfield(vs_file,v_target_part)
    vs_file=vs_file.(v_target_part);
end
