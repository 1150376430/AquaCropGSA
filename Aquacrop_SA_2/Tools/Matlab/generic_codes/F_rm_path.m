function F_rm_path(varargin)
%F_RM_PATH  Description d'une ligne a placer ici
%   F_rm_path([v_lib_root,'purge','delete'])
%  
%   ENTREE(S):
%    Optionnels:
%      - v_lib_root: chemin d'une librairie
%      - mot cle: 'purge' pour eliminer tous les paths ne contenant pas
%      le chemin vers le repertoire racine de la distribution specifiee
%      dans v_lib_root
%      - mot cle 'delete': suppression physique du/des repertoire(s)
%      temporaire(s) d'une/de distributions (si v_lib_root et 'purge'
%      sont fournis)
%  
%  
%   SORTIE(S): 
%      
%  
%   CONTENU:
%   - Sans argument: suppression des chemins dans le path de la distrib
%   - 'delete' seul: suppression du rep. temporaire de la distrib. en cours
%   - v_lib_root: suppression des chemins dans le path des chemins associes
%   au chemin de la distrib specifiee dans cette variable, si on ajoute
%   'purge', suppression des chemins associes aux autres distrib.
%   - Ajout de 'delete': suppression du ou des repertoires temporaires de
%   la (en cours, ou v_lib_root) ou des distrib (ajout de 'purge').
%  
%   APPEL(S): 
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 22-Sep-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_test_mfile_rev,F_get_tmp_path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib

v_args={};
varargs={};
v_logical_arg=cellfun(@islogical,varargin);
if any(v_logical_arg)
    v_args=varargin(v_logical_arg);
    varargs=varargin(~v_logical_arg);
else
    varargs=varargin;
end

F_test_mfile_rev('F_rm_path','$Revision: 940 $',v_args{:})


v_purge=false;
v_rm_tmp_dirs=false;

% Args. fournis
nargs=length(varargs);
if nargs
    for n=1:nargs
        if ischar(varargs{n})
            if strcmp(varargs{n},'purge')
                v_purge=true;
            elseif strcmp(varargs{n},'delete')
                v_rm_tmp_dirs=true;
            else
                v_lib_root={varargs{n}};
            end
        end
    end
end

% Si on n'a pas fourni un chemin
if ~exist('v_lib_root','var')
    % Recuperation des infos sur les distrib. referencees
    [v_lib_tmp_path, vs_referenced_paths] = F_get_tmp_path(v_args{:});
else
    [v_lib_tmp_path, vs_referenced_paths] = F_get_tmp_path(v_lib_root,v_args{:});
end
% Listes des repertoires
vc_lib_root={vs_referenced_paths.lib_root};
vc_lib_tmp={vs_referenced_paths.lib_tmp_path};

% Selection a eliminer
vv_unwanted=~ismember({vs_referenced_paths.lib_tmp_path},v_lib_tmp_path);
% Si la distrib. specifiee est a eliminer et non pas les autres
if ~v_purge
    vv_unwanted=~vv_unwanted;
end
% Selection des repertoires a eliminer
if ~isempty(vv_unwanted)
    vc_lib_root=vc_lib_root(vv_unwanted);
    vc_lib_tmp=vc_lib_tmp(vv_unwanted);
end

% Delimiter path specifique de l'OS 
v_delim=';';
if any([ismac isunix])
    v_delim=':';
end
% Traitement des chemins a retirer du path
vc_paths=textscan(path,'%s','delimiter',v_delim);

vc_paths=vc_paths{1};
vv_index_1=cell2mat(cellfun(@(x) find(strcmp(x,vc_paths)),vc_lib_root,'UniformOutput',false));
vv_index_2=cell2mat(cellfun(@(x) find(strcmp([x filesep],vc_paths)),vc_lib_root,'UniformOutput',false));

% Liste des chemins a supprimer
vc_paths2rm=vc_paths(unique([vv_index_1 vv_index_2]));

% Suppression des chemins dans le path
for i=1:length(vc_paths2rm)
    rmpath(vc_paths2rm{i});
end

% Suppression des chemins tmp dans le path et 
% des repertoires si demande
for j=1:length(vc_lib_tmp)
    vv_tmp_path_index=strcmp(vc_lib_tmp{j},vc_paths);
    if any(vv_tmp_path_index)
        rmpath(vc_lib_tmp{j});
    end
    % Effacement des repertoires
    if v_rm_tmp_dirs
        fileattrib(vc_lib_tmp{j},'+w');
        rmdir(vc_lib_tmp{j},'s');
    end
end
