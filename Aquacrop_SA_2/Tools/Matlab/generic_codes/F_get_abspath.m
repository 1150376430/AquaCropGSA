function [v_abs_path,varargout] = F_get_abspath(varargin)
%F_GET_ABSPATH  Renvoie un chemin absolu de fichier/repertoire
%   [v_abs_path[,v_exist]] = F_get_abspath([v_dir])
%  
%   ENTREE(S): 
%      - v_file: optionnel, nom ou chemin d'un repertoire/fichier (relatif)
%  
%   SORTIE(S): 
%      - v_abs_path : chemin absolu du repertoire/fichier
%      en option :
%      - v_exist : 1 si le repertoire/fichier existe, 0 sinon
%  
%   CONTENU: 
%      Obtention d'un chemin absolu pour un repertoire ou un fichier a
%      partir d'un chemin relatif et eventuellement de l'existance.
%  
%   APPEL(S): 
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_get_abspath
%      - F_get_abspath('dirname') ou F_get_abspath('filename')
%      - F_get_abspath('.\dirname') ou F_get_abspath('.\filename')
%      - F_get_abspath('dirname1\dirname2') ou F_get_abspath('dirname\filename')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 19-Nov-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also pwd, cd, exist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Repertoire de depart
v_startdir=pwd;

switch nargin
    case 0 % chemin absolu du repertoire courant
        v_abs_path=v_startdir;
    case 1 % chemin absolu d'un repertoire/fichier fourni
        if isempty(varargin{1}) 
            v_abs_path=v_startdir;
        elseif ~ischar(varargin{1})
           v_abs_path='';
        else
            v_file=varargin{1};
            try
                cd(v_file);
                v_abs_path=pwd;
                cd(v_startdir);
            catch
                % Le repertoire n'existe pas ou c'est un fichier
                % Si c'est un chemin absolu (unix ou Windows)
                if (strcmp(v_file(1),filesep) && isunix) || (~isempty(strfind(v_file,':\')==2) && ispc)
                    v_abs_path=v_file;
                    % Sinon c'est un chemin relatif, dans le repertoire courant
                else
                    if strcmp(v_file(1),'.')
                        v_file=v_file(2:end);
                    end
                    if strcmp(v_file(1),filesep)
                        v_file=v_file(2:end);
                    end
                    v_abs_path=fullfile(v_startdir,v_file);
                end
            end
        end
end
if nargout>1 % si status demande en sortie
    varargout{1}=false;
    if exist(v_abs_path,'dir') || exist(v_abs_path,'file')
        varargout{1}=true;
    end
end
