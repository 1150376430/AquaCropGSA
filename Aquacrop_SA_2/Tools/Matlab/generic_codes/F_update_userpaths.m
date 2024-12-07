function varargout=F_update_userpaths(varargin)
%F_UPDATE_USERPATHS  Mise a jour des chemins utilisateurs dans envpaths.mat
%   F_update_userpaths([v_type,v_path,v_rename])
%
%   ENTREE(S):
%      Arguments optionnels
%      - v_type : 'workspace'ou 'output'
%      - v_path : chemin de repertoire
%      - v_rename : par defaut = 1 , le repertoire de sortie est renomme
%                   un nouveau repertoire de sortie est cree
%                   0 si on veut conserver le repertoire
%
%   SORTIE(S): aucun argument de sortie
%      - seul un fichier est mis a jour envpaths.mat
%      - argument optionnel (appel sans argument d'entree): 
%        v_success :1 si les chemins enregistres sont coherents, 0 sinon
%
%   CONTENU: Chargement des chemins utilisateurs (workspace et output)
%            contenus dans envpaths.mat. 
%            - Verification de la coherence (sans argument)
%            ou
%            - Mise a jour des chemins, et
%            eventuellement creation du repertoire output apres renommage
%            eventuel de l'ancien si il n'est pas vide. Sauvegarde des
%            infos dans le fichier envpaths.mat
%
%   APPEL(S):
%      - F_load_envpaths
%      -
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_update_userpaths (verification de la coherence des chemins)
%      - F_update_userpaths('output','NomRepertoire')
%      - F_update_userpaths('output','CheminRepertoire')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 03-Jul-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-17 11:52:00 +0200 (lun., 17 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 926 $
%  
%
% See also F_load_envpaths, save, F_set_overwrite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



v_types={'workspace','output'};
[v_temp_dir,v_user_dirs]=F_load_envpaths('temp','user');

switch nargin
    case 0 % Verification de la coherence des infos dans le fichier
        varargout{1}=F_check_paths;
        return;
    case 1
        % A VOIR: si ce cas est utilise ou non ????????
        v_rename=logical(varargin{1});
        v_type='output';
        v_path=v_user_dirs.output.path;
    case 2
        v_type=varargin{1};
        v_path=varargin{2};
        v_rename=true;
    case 3
        v_type=varargin{1};
        v_path=varargin{2};
        v_rename=logical(varargin{3});
end

% Verification du mot cle fourni
if ~ismember(v_type,v_types)
    error('Il n''existe pas de chemin associe au mot cle %s',v_type)
end

% Recalcul systematique du repertoire en chemin absolu.
[v_tmp_path,v_exist]=F_get_abspath(v_path);

switch v_type
    case 'workspace'
        if ~v_exist
            try
                error('MSLIB:dirNotFound','Erreur sur le repertoire');
            catch
                F_create_message(v_user_dirs.workspace.path,'Repertoire inexistant',1,1,lasterror);
            end
        end

    case 'output'
        if isempty(v_path)
            F_create_message('Erreur sue le repertoire de sortie','Le chemin n''a ete specifie!',1,1);
        end
        
        % Xtraction du repertoire parent du repertoire output
        % si output n'existe pas
        if ~v_exist
            vs_fparts=F_file_parts(v_tmp_path);
            if ~exist(vs_fparts.dir,'dir')
                try
                    error('MSLIB:dirNotFound','Erreur sur le repertoire ...');
                catch
                    F_create_message(vs_fparts.dir,'Le repertoire n''existe pas',1,1,lasterror);
                end
            end
        end
%         % Le chemin de sortie est valide
%         v_user_dirs.output.path=v_tmp_path;
%         v_user_dirs.output.isset=1;
end

% Le chemin (workspace ou output) est valide
v_user_dirs.(v_type).path=v_tmp_path;
v_user_dirs.(v_type).isset=1;

% Gestion du repertoire output et de son contenu si il existe
% A VOIR : si execution systematique necessaire qq soit v_type ou
% uniquement si == 'output'
if v_user_dirs.(v_type).isset
    if v_rename
        F_gen_out_path;
    end
end

% Mise a jour des donnees dans le fichier de preferences envpaths.mat
save(fullfile(v_temp_dir,'envpaths.mat'),'-append','v_user_dirs');

% Si le fichier de log est actif, il est deplace
F_log('move');


    function F_gen_out_path
        global v_overwrite;
        F_set_overwrite;
        
        % Creation du repertoire de sortie ou nettoyage/deplacement des
        % fichiers si le repertoire existe
        v_mkdir=1;
        v_mvdir=0;
        if exist(v_user_dirs.output.path,'dir')
            % Si le repertoire n'est pas vide
            % Effacement du contenu ou creation d'un repertoire de
            % sauvegarde des fichiers
            if length(dir(v_user_dirs.output.path))>2 && v_rename 
                vs_dir_list=dir(v_user_dirs.output.path);
                v_filter_list={'.' '..'};
                % Si le log est actif on ne le supprime pas
                if F_log && ismember(F_log('name'),{vs_dir_list.name})
                    % Recuperation du nom du fichier log dans la liste de
                    % filtrage
                    v_filter_list={'.','..',F_log('name')};
                end
                vc_diff_files_list=setdiff({vs_dir_list.name},v_filter_list);
                if ~isempty(vc_diff_files_list);
                    % forcage de l'effacement
                    if ~v_overwrite
                        v_purge=F_user_input(sprintf('\nLe repertoire %s n''est pas vide \n%s\n',v_user_dirs.output.path,...
                        'Supprimer les fichiers et repertoires ?'),{'oui','non (sauvegarde)'},[true false],false);
                    else
                        v_purge=true;
                    end
                    % Effacement des sous-repertoires et des fichiers
                    % autres que le fichier de log en cours
                    if v_purge
                        % Suppression des repertoires et fichiers
                        for v_file=vc_diff_files_list
                            v_path=fullfile(v_user_dirs.output.path,v_file{1});
                            try
                                warning('OFF','MATLAB:DELETE:Permission');
                                if isdir(v_path)
                                    rmdir(v_path,'s');
                                else
                                    delete(v_path);
                                end
                                switch exist(v_path,'file')
                                    case 2
                                        error('Probleme sur un fichier');
                                    case 7
                                        error('Probleme sur un repertoire');
                                end

                            catch
                                F_create_message(v_path,'Le repertoire/fichier n''a pu etre efface. Verifier les droits ou son utilisation par une autre application',...
                                    1,1,lasterror);
                            end
                        end
                        warning('ON','MATLAB:DELETE:Permission');
                        F_disp(sprintf('Les fichiers ont ete supprimes du repertoire \n%s\n',v_user_dirs.output.path));
                        v_mkdir=0;

                    else
                        vs_log_list=dir([v_user_dirs.output.path filesep '*.log']);
                        if ~F_log && ~isempty(vs_log_list)
                            % si le fichier log n'est pas actif et qu'il y
                            % a un fichier log present
                            % recuperation de la date de debut d'ecriture du fichier log
                            % le plus recent pour extraire la date a ajouter au nom du
                            % repertoire
                            v_log_filename=vs_log_list(find(max([vs_log_list.datenum]))).name;
                            v_date=v_log_filename(strfind(v_log_filename,v_mode_name)+length(v_mode_name):end-4);
                            v_sav_dir=[v_user_dirs.output.path '_' v_date];
                        else
                            % Nom du repertoire de sauvegarde des donnees
                            v_sav_dir=[v_user_dirs.output.path '_' datestr(now,'dd_mm_yyyy_HH_MM_SS')];
                        end
                        v_mvdir=1;
                    end
                end
            % Le repertoire est vide
            else
                v_mkdir=0;
            end
        end
        % Creation d'un repertoire ou deplacement des fichiers existants
        % dans un repertoire de sauvegarde
        if v_mkdir
            try
                if ~v_mvdir
                    if ~exist(v_user_dirs.output.path,'dir')
                        mkdir(v_user_dirs.output.path);
                    end
                else
                    v_dir_list=dir(v_user_dirs.output.path);
                    v_filter_list={'.' '..'};
                    % Si le log est actif on filtre le fichier de log 
                    % si il existe dans le repertoire de sortie
                    if F_log
                        % Recuperation du nom du fichier log
                        v_log_name=F_log('name');
                        if strcmp(F_file_parts(F_log('file'),'dir'),v_user_dirs.output.path)
                            v_filter_list={'.' '..' v_log_name};
                        end
                    end
                    % Creation du repertoire de destination
                    if ~exist(v_sav_dir,'dir')
                        try
                            mkdir(v_sav_dir)
                        catch
                            F_create_message(v_sav_dir,...
                                'Le repertoire n''a pu etre cree (problemes de droits !)',...
                                    1,1,lasterror);
                        end
                    end
                    % Deplacement des fichiers existants
                    for v_file=setdiff({v_dir_list.name},v_filter_list)
                        try
                            movefile(fullfile(v_user_dirs.output.path,v_file{1}),fullfile(v_sav_dir,v_file{1}));
                        catch
                            F_create_message(fullfile(v_user_dirs.output.path,v_file{1}),...
                                'Le fichier n''a pu etre deplace. Verifier les droits, ou son utilisation par une autre application',...
                                    1,1,lasterror);
                        end
                    end
                    % Effacement du rep si il est vide
                    if length(dir(v_sav_dir))==2
                        try
                            rmdir(v_sav_dir);
                        catch
                            F_create_message(v_sav_dir,'Le repertoire n''a pu etre efface. Verifier les droits ou son utilisation par une autre application',...
                                    1,1,lasterror);
                        end
                    end

                    % Message pour avertir de la sauvegarde des fichiers (avec
                    % une pause)
                    F_disp(sprintf('%s\n%s\n%s\n%s\n','Les fichiers du repertoire',v_user_dirs.output.path,...
                        'sont sauvegardes dans le repertoire',v_sav_dir),'pause');
                end
            catch
                F_create_message(v_user_dirs.output.path,'Impossible de creer le repertoire',1,1,lasterror);
            end
        end
    end

    function v_success=F_check_paths
        v_success=1;
        v_ws_content='(vide)';
        v_out_content='(vide)';
        % Verification des renseignements presents dans le fichier
        if ~v_user_dirs.output.isset || ~v_user_dirs.workspace.isset
            if v_user_dirs.output.isset
                v_out_content=v_user_dirs.output.path;
            end
            if v_user_dirs.workspace.isset
                v_ws_content=v_user_dirs.workspace.path;
            end
            v_success=0;
            F_disp('Attention : au moins un des chemins utilisateurs n''est pas renseigne');
            F_disp('Contenu des chemins utilisateurs definis');
            F_disp(sprintf('Workspace : %s',v_ws_content));
            F_disp(sprintf('Output : %s',v_out_content));
        end
    end
end
