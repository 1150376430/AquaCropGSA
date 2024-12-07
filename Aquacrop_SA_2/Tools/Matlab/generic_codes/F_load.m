function [v_mat_obj, v_var_name] = F_load(v_file_path,varargin)
%F_LOAD  Chargement d'une variable contenue dans un fichier mat
%   v_mat_obj = F_load(v_file_path [,v_var_name])   
%  
%   ENTREE(S):
%      - v_file_path : nom ou chemin relatif ou chemin complet du fichier
%      mat a charger, avec ou sans extension .mat
%      - nom de la variable a renvoyer
%  
%   SORTIE(S): 
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
%  DATE: 17-Apr-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also F_get_abspath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% On fixe le controle des erreurs et affichages : infos,erreurs,warnings
global v_display;
F_set_display;


% initialisation
v_mat_obj=[];

vs_fparts=F_file_parts(v_file_path);
if isempty(vs_fparts.dir)
    vs_fparts.dir='.';
end
if isempty(vs_fparts.ext)
    vs_fparts.ext='.mat';
end
v_abs_dir_path=F_get_abspath(vs_fparts.dir);
v_file_path=fullfile(v_abs_dir_path,[vs_fparts.name vs_fparts.ext]);
%
if ~exist(v_file_path,'file') || ~strcmp(vs_fparts.ext,'.mat' )
    error('Le fichier %s n''existe pas dans %s \nou n''est pas un fichier mat!!!',[vs_fparts.name vs_fparts.ext],v_abs_dir_path)
end

% Traitement arg supplementaire : nom de la variable a recuperer si il en
% existe plusieurs ou si le nom est different du nom du fichier mat
if nargin>1
    v_var_name=varargin{1};
else
    v_var_name=vs_fparts.name;
end

v_tmp_obj=load(v_file_path);
if isfield(v_tmp_obj,v_var_name)
    % Il y a plusieurs variables dans le fichier mat
    v_mat_obj=v_tmp_obj.(v_var_name);
else
    % Il n'y a qu'un seul champ donc une seule variable a retourner
    vc_fields=fieldnames(v_tmp_obj);
    if all(size(vc_fields)==1)
        v_field=vc_fields{1};
        v_mat_obj=v_tmp_obj.(v_field);
        v_var_name=v_field;
    end
end
