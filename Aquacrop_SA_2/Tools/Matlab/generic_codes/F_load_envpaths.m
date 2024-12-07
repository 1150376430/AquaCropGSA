function varargout=F_load_envpaths(varargin)
%F_LOAD_ENVPATHS  Chargement de variables contenue dans envpaths.mat
%   [v_lib_root,v_lib_dirs,v_lib_paths,v_user_dirs,v_lib_temp_dir] 
%   = F_load_envpaths(['root','dirs','paths','user','temp'[,'all'],v_lib_path])
%
%   ENTREE(S): descriptif des arguments d'entree
%      options:
%      - mots cles parmi : 'root','dirs','paths','user','temp'
%      - 'all' : correspond a la liste complete des mots cles
%      - v_lib_path: chemin du repertoire racine de la distrib. a utiliser
%
%   SORTIE(S): 
%      - v_lib_root : repertoire racine de l'installation ou lecteur reseau
%      contenant les fichiers multisimlib
%      - v_lib_dirs : repertoires (chemins relatifs) necessaires au
%      fonctionnement)
%      - v_lib_paths : chemins relatifs vers les repertoires contenant les
%      fonctions
%      - v_user_dirs : repertoires de travail et de stockage des fichiers
%       de sortie
%      - v_lib_temp_dir : repertoire temporaire multisimlib cree dans le
%       repertoire temporaire windows de l'utilisateur (stockage des
%       fichiers envpaths.mat, F_set_path.m, F_load_envpaths.m,claspath.txt)
%
%   CONTENU:
%      - Sans argument d'entree,sortie : permet de verifier l'existence
%      des chemins renseignes dans les differentes variables provenant du
%      fichier envpaths.mat
%      - Permet de recuperer les variables contenues dans le fichier
%      envpaths.mat cree par la fonction F_startup dans un sous-repertoire
%      (multisimlib) dans le repertoire temporaire de l'utilisateur
%      - Realise les verifications necessaires, pour l'instant l'existence
%      des repertoires et des chemins (ajoutes au path par F_set_path).
%
%   APPEL(S): 
%      - F_get_tmp_path
%
%   EXEMPLE(S): 
%      - F_load_envpaths
%      - [v_lib_root,v_lib_dirs]=F_load_envpaths('root','dirs')
%
%      - [v_lib_root,v_lib_dirs]=F_load_envpaths('root','dirs','d:\chemin_racine_distribution')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 19-Sep-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%
% See also F_test_mfile_rev,F_get_tmp_path,
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

% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
F_test_mfile_rev('F_load_envpaths','$Revision: 939 $',v_args{:});

nargs=numel(varargs);
if nargs==0
    if nargout
        varargout{1}={};
    end
    return;
end
% Liste des mots cles et des variables correspondantes dans envpaths.m
v_argin_keys_list={'root','dirs','paths','user','temp'};
v_avail_var_list={'v_lib_root','v_lib_dirs','v_lib_paths','v_user_dirs','v_lib_temp_dir'};

% Si 'all' est detecte on fixe les arguments d'entree a l'ensemble des
% variables a extraire + les autres arguments que 'all'
if nargs && any(ismember(varargs,'all'))
    v_argin={varargs{~ismember(varargs,'all')} v_argin_keys_list{:}};
else
    v_argin=varargs;
end
%
% Extraction du chemin si fourni
if ~all(ismember(v_argin,v_argin_keys_list))
    % recuperation de l'argument qui n'est pas un mot cle == chemin lib
    vc_non_key_list=v_argin(~ismember(v_argin,v_argin_keys_list));
    if ~isempty(vc_non_key_list) %
        if length(vc_non_key_list)==1 && isdir(vc_non_key_list{1})
            v_lib_path=vc_non_key_list{1};
            v_argin=v_argin(ismember(v_argin,v_argin_keys_list));
        else
            % Ajouter la liste des mots/chemins qui ne sont pas des
            % mots cle ou un chemin existant !!!!!!!
            v_msg=sprintf('''%s'' ',v_argin_keys_list{:},'all');
            error('Erreur sur les mots cles en argument.\nListe des mots cles disponibles : %s',...
                v_msg);
        end
    end
end


% Chargement de envpaths
try
    if exist('v_lib_path','var')
        v_tmp_path=F_get_tmp_path(v_lib_path,v_args{:});
    else
        v_tmp_path=F_get_tmp_path(v_args{:});
    end
    load(fullfile(v_tmp_path,'envpaths.mat'));
catch
    error('Le fichier requis n''a pas ete trouve dans le chemin : %s \nEmplacement normal : %s\n%s','envpaths.mat',...
        v_tmp_path,'Executer le script F_startup.m (dans le sous repertoire Conf du repertoire d''installation');
end

% Verification de l'existence des variables
% 'v_lib_root','v_lib_dirs','v_lib_paths','v_dirs','v_work_dirs',
% 'v_lib_temp_dir'
if ~all(cellfun(@exist, v_avail_var_list))
    error('Certains elements sont absents du fichier %s \n Re-executer le script F_startup.m', 'envpaths.mat')
end
switch length(v_argin)
    case 0 % verification de l'existence des variables dans envpaths.m
        % Message d'erreur
        v_err_msg=['Le chemin specifie n''existe pas ou a ete modifie : \n %s\n'...
            'Executer a nouveau la fonction F_startup \ndans le repertoire ou elle se trouve.'];
        % test root
        if ~exist(v_lib_root,'dir')
            error(v_err_msg,v_lib_root);
        end
        % test existence v_lib_dirs
        v_names=fieldnames(v_lib_dirs);
        for i=1:length(v_names)
            v_path=fullfile(v_lib_root,v_lib_dirs.(v_names{i}));
            if ~exist(v_path,'dir')
                error(v_err_msg,v_path);
            end
        end
        % test existence v_lib_paths
        v_fnames=fieldnames(v_lib_paths);
        for i=1:length(v_fnames)
            for j=1:length(v_lib_paths.(v_fnames{i}))
                v_path=fullfile(v_lib_root,v_lib_paths.(v_fnames{i}){i});
                if ~exist(v_path,'dir')
                    error(v_err_msg,v_path);
                end
            end
        end
        %
        % Verification existence variable v_user_dirs....
        v_fnames=fieldnames(v_user_dirs);
        for i=1:length(v_fnames)
            if ~v_user_dirs.(v_fnames{i}).isset
                error('Le chemin n''est pas renseigne pour %s',v_fnames{i})
            else
                if ~exist(v_user_dirs.(v_fnames{i}).path,'dir')
                    error('Le chemin specifie n''existe pas : %s',v_user_dirs.(v_fnames{i}).path)
                end
            end
        end
    otherwise % Extraction des valeurs des arguments de sortie en fonction des arguments d'entree
        varargout=cell(1,length(v_argin));
        for i=1:length(v_argin)
            v_index=find(ismember(v_argin_keys_list,v_argin{i}));
            if ~isempty(v_index) && length(v_index)==1
                varargout{i}=eval(v_avail_var_list{v_index});
            end
        end
            
end
