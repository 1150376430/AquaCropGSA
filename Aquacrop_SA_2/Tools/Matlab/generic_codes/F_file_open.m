function v_fid = F_file_open(v_file_path, varargin)
%F_FILE OPEN Ouverture de fichier,gestion des messages d'erreurs/permissions
%   v_fid = F_fopen(v_file_path [,v_permission])
%  
%   ENTREE(S): 
%      - v_file_path: nom ou chemin du fichier
%     Optionnels
%     - v_permission: code de permission
%     parmi: 'a' 'w' 'r' 'a+' 'w+' 'r+' (defaut: 'r', si non fourni)
%  
%   SORTIE(S):
%      - v_fid: nombre entier > 0 (si le fichier a pu etre ouvert)
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - v_fid = F_file_open('fichier.txt,'w')
%      - v_fid = F_file_open('fichier.txt')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 06-Oct-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-21 14:52:09 +0200 (mar., 21 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 896 $
%  
%  
% See also F_create_message, F_gen_error_struct, fopen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Liste des permissions
vc_permissions={'a' 'w' 'r' 'a+' 'w+' 'r+'};
% Permission pas defaut
v_permission='r';
% Arg supple. : permission
if nargin>1 && ismember(varargin{1},vc_permissions)
   v_permission=varargin{1}; 
end
% Ouverture fichier
[v_fid, v_message] = fopen(v_file_path,v_permission);
% Gestion des erreurs
if v_fid == -1
    if ~exist(v_file_path,'file')
        lsterr=F_gen_error_struct('MSLIB:fileNotFound','Erreur a l''ouverture du fichier');
        v_comment='Le fichier n''existe pas / ne peut etre cree!';
    else
        switch v_permission
            case 'r'
                lsterr=F_gen_error_struct('MSLIB:fileReadError','Erreur a l''ouverture du fichier');
                v_comment='Le fichier n''a pu etre lu ';
            case 'r+'
                lsterr=F_gen_error_struct('MSLIB:fileWriteError','Erreur a l''ouverture du fichier');
                v_comment='Le fichier n''a pu etre lu, modifie ';
            case {'w' 'w+'}
                lsterr=F_gen_error_struct('MSLIB:fileWriteError','Erreur a l''ouverture du fichier');
                v_comment='Le fichier n''a pu etre cree, modifie ';
            case {'a' 'a+'}
                lsterr=F_gen_error_struct('MSLIB:fileWriteError','Erreur a l''ouverture du fichier');
                v_comment='Le fichier n''a pu etre complete, lu ';
        end
    end
    F_create_message(v_file_path,[ v_comment '(' v_message ')'],1,1,lsterr);
end
