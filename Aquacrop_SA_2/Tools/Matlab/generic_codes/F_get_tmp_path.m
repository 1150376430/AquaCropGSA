function [v_lib_tmp_path, vs_referenced_paths,v_temp_dir] = F_get_tmp_path(varargin)
%F_GET_TMP_PATH  chemin du repertoire temporaire mslib utilisateur
%   v_lib_tmp_path = F_get_tmp_path([v_in_lib_root])
%  
%   ENTREE(S): 
%      Optionnelle:
%      - v_in_lib_root: chemin racine du dossier de la distribution
%       des fonctions 
%  
%   SORTIE(S): 
%      - v_lib_tmp_path : chemin absolu du répertoire temporaire (stockage
%      envpaths.mat)
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S):
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      recuperation du chemin actuel
%      - v_lib_tmp_path = F_get_tmp_path
%      recuperation du chemin pour une autre distrib referencee ou non
%      par F_startup
%      v_lib_tmp_path = F_get_tmp_path(chemin_repertoire_distribution)
%  
%  AUTEUR(S): Nom inconnu
%  DATE: 31-Mar-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-17 15:10:57 +0200 (mer., 17 avr. 2013) $
%    $Author: plecharpent $
%    $Revision: 850 $
%  
%  
% See also F_test_mfile_rev,F_load_envpaths,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v_in_args=varargin;

v_args={};
varargs={};
v_logical_arg=cellfun(@islogical,v_in_args);
if any(v_logical_arg)
    v_args=v_in_args(v_logical_arg);
    varargs=v_in_args(~v_logical_arg);
else
    varargs=v_in_args;
end

F_test_mfile_rev('F_get_tmp_path','$Revision: 850 $',v_args{:});

% declaration des systemes supportes par Matlab 
vc_system={'PCWIN','GLNX','SOL','MAC'};
vc_names={'Windows','Linux','Solaris','Mac'};
% 
nargs=numel(varargs);

if nargs
    
    v_in_lib_root=varargs{1};
else
    try 
        load('envpaths','v_lib_root')
        v_in_lib_root=v_lib_root;
    catch
         v_in_lib_root='';
    end
end
if isunix
    v_temp_dir_name='HOME';
    v_mslib_dir_prefix='.multisimlib';
elseif ispc
    v_temp_dir_name='Temp';
    v_mslib_dir_prefix='multisimlib';
else
    error('Système %s : non pris en charge actuellement',vc_names{strmatch(computer,vc_system)});
end
% Calulate mslib temp dir prefix length
v_mslibdirprefix_size=length(v_mslib_dir_prefix);

v_temp_dir=getenv(v_temp_dir_name);
if isempty(v_temp_dir)
    v_temp_dir_name=lower(v_temp_dir_name);
    v_temp_dir=getenv(v_temp_dir_name);
end

%% Pour Windows : Extraction seulement du chemin jusqu'au repertoire Temp
% pour eviter la creation de fichiers dans un sous-repertoire
% du repertoire temporaire (peut etre different d'une session a l'autre)
if ispc
    v_temp_dir=v_temp_dir(1:strfind(v_temp_dir,v_temp_dir_name)+length(v_temp_dir_name)-1);
end
vs_mslib_dirs=dir(fullfile(v_temp_dir,[v_mslib_dir_prefix '*']));
vs_mslib_dirs=vs_mslib_dirs([vs_mslib_dirs.isdir]);
if ~isempty(vs_mslib_dirs)
    vv_num_dir=[];
    v_break=0;
    j=0;
    for i=1:length(vs_mslib_dirs)
        try
            load(fullfile(v_temp_dir,[vs_mslib_dirs(i).name filesep 'envpaths']),'v_lib_root','v_lib_temp_dir');
            
        catch
            % ce n'est pas un répertoire temoraire pour MultisimLib
            % on l'ignore.
            continue
        end
        j=j+1;
        vs_referenced_paths(j).lib_root=v_lib_root;
        vs_referenced_paths(j).lib_tmp_path=v_lib_temp_dir;
        vs_referenced_paths(j).exists=true;
        if ~isdir(v_lib_root)
            vs_referenced_paths(j).exists=false;
        end
        % Si le chemin temporaire associé à la librairie existe
        if strcmp(v_lib_root,v_in_lib_root)
            v_dir_name=vs_mslib_dirs(j).name;
        elseif length(vs_mslib_dirs(j).name)>v_mslibdirprefix_size
            vv_num_dir=[vv_num_dir str2double(vs_mslib_dirs(j).name(v_mslibdirprefix_size+1:end))];
        end
    end
    if ~exist('v_dir_name','var')
        if isempty(vv_num_dir) && j>1
            v_dir_name=[v_mslib_dir_prefix '2'];
        else
            v_dir_name=[v_mslib_dir_prefix num2str(max(vv_num_dir)+1)];
        end
    end
else
    v_dir_name=v_mslib_dir_prefix;
end

v_lib_tmp_path=fullfile(v_temp_dir,v_dir_name);

if ~exist('vs_referenced_paths','var')
    vs_referenced_paths.lib_root='';
    vs_referenced_paths.lib_tmp_path=v_lib_tmp_path;
    vs_referenced_paths.exists=false;
elseif ~isdir(v_lib_tmp_path)
    v_nb_elts=length(vs_referenced_paths);
    vs_referenced_paths(v_nb_elts+1).lib_root='';
    vs_referenced_paths(v_nb_elts+1).lib_tmp_path=v_lib_tmp_path;
    vs_referenced_paths(v_nb_elts+1).exists=false;
end

