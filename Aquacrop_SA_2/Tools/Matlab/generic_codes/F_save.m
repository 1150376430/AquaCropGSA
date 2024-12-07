function F_save(v_name,varargin)
%F_SAVE  Chargement d'une variable ou plusieurs variables dans un fichier mat
%   F_save(v_name,[v_dir_path,var1, var2,...])   
%  
%   ENTREE(S):
%      - v_name : nom du fichier mat a creer
%      - v_dir_path : chemin du repertoire de stockage
%      - var1, var2,.. : liste des variables a inclure dans le fichier 
%  
%   SORTIE(S): 
%      - 
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): 
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
%    $Date: 2012-07-27 08:28:18 +0200 (ven., 27 juil. 2012) $
%    $Author: plecharpent $
%    $Revision: 631 $
%  
%  
% See also F_get_abspath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% On fixe le controle des erreurs et affichages : infos,erreurs,warnings
global v_display;
F_set_display;

vc_vars={};
vc_vars_list={};
v_dir_path='';
v=1;
if nargin>1
    for i=1:length(varargin)
        if ischar(varargin{i}) && isdir(varargin{i}) && isempty(v_dir_path)
            v_dir_path=F_get_abspath(varargin{i});

        else
            vc_vars_list{v}=inputname(i+1);
            vc_vars{v}=varargin{i};
            v=v+1;
        end
    end
end

if isempty(vc_vars_list)
    vc_vars_list={inputname(1)};
    vc_vars={v_name};
else
    vc_vars_list={inputname(1) vc_vars_list{:}};
    vc_vars={v_name,vc_vars{:}};
end

v_file_path=fullfile(v_dir_path,[inputname(1) '.mat']);

for j=1:length(vc_vars_list)
    eval([vc_vars_list{j} '=vc_vars{j};']);
end
save(v_file_path,vc_vars_list{:});

