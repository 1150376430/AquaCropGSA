function vs_files = F_concat_err_data(vs_errors_warnings,varargin)
% F_CONCAT_ERR_DATA  Creation de fichiers de synthese sur les donnees
% associees aux erreurs detectees
%   F_concat_err_data(vs_errors_warnings[,v_file_suffix,v_mode])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - vs_errors_warnings : structure contenant les donnees d'erreurs
%      (avec 2 champs vs_errors et vs_warnings selon le statut des erreurs)
%      Arguments oprionnels:
%      - v_file_suffix : specification optionnelle d'un suffixe a ajouter
%      au nom des fichiers crees
%      - v_mode: par defaut initialise a 'last' qui permet de prendre en
%      compte la derniere erreur pour chaque usm, autre valeur possible
%      pouvant etre fournie en argument supplementaire 'all' qui permet de
%      balayer l'ensemble des erreurs pour chaque usm
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - vs_files : structure contenant les noms des fichiers de synthese
%      (mat pour les parametre et csv pour les infos sur les erreurs) et le
%      chamin du repertoire dans lequel ils sont stockes)
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - vs_files = F_concat_err_data(vs_errors_warnings)
%      - vs_files = F_concat_err_data(vs_errors_warnings,'all')
%      - vs_files = F_concat_err_data(vs_errors_warnings,'test')
%      - vs_files = F_concat_err_data(vs_errors_warnings,'test','all')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 05-Mar-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_concat_err_data > F_add_err_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisations
vs_files=struct;
v_file_suffix='';
v_mode='last';
v_modes={'last', 'all'};
vc_errors_status={'errors','warnings'};
% Si un mode de traitement est fourni et/ou un suffix de fichier
if nargin>1
    for v_arg=1:length(varargin)
        v_str=num2str(varargin{v_arg});
        if ismember(v_str,v_modes)
            v_mode=v_str;
        else
            v_file_suffix=v_str;
        end
    end
end
if ~isempty(v_file_suffix)
    v_file_suffix=['_' v_file_suffix];
end
% Definition des noms et extensions des fichiers
% Matrice des jeux de parametres
v_params_err_file_name=['params_values' v_file_suffix];
v_params_err_file_ext='.mat';
% Liste des erreurs et fichiers modele associes
v_data_err_file_name=['errors_list' v_file_suffix] ;
v_data_err_file_ext='.csv';
% Boucle sur les types de status d'erreurs possibles
% correspondant a des champs de vs_errors_warnings.
for v_sid=1:length(vc_errors_status)
    v_data_key=vc_errors_status{v_sid};
    v_field_name=['vs_' v_data_key];
    % Traitement des erreurs
    if isfield(vs_errors_warnings,v_field_name) && isfield(vs_errors_warnings.(v_field_name),v_data_key)
        vc_err_data=vs_errors_warnings.(v_field_name).(v_data_key);
        % Extraction du premier cell non vide d'une usm (selon le type de cell)
        try
            v_first_id=find(cellfun(@(x) ~isempty(x) & ~isempty(x{1}), vc_err_data),1);
        catch
            v_first_id=find(cellfun(@(x) ~isempty(x), vc_err_data),1);
        end
        % Si une erreur au moins est referencee
        % Extraction des
        if ~isempty(v_first_id)
            v_file_key=vc_err_data{v_first_id}{1}.key(1).name;
            v_dir_err=F_file_parts(vc_err_data{v_first_id}{1}.(v_file_key),'dir');
            F_add_err_data;
        end
    end
end
% Sous-fonction
    function F_add_err_data
        % Extraction et ajout de donnees dans les fichiers
        % de synthese des errors/warnings : creation ou chargement du fichier csv
        % et verification de la presence des donnees inscrites pour chaque erreur.
        % Fonctionnement en sequentiel ??????????
        % La liste des fichiers modeles references et sauvegardes sont traites
        % independamment du modele (les structures d'erreurs contiennent des mots
        % cles qui correspondent a des champs contenant les chemins des fichiers
        % sauves).
        if ~exist('v_dir_err','var')
            F_disp(['Le repertoire n''existe pas :' v_dir_err]);
            F_disp('Les donnees associees aux erreurs ne pourront pas etre sauvees');
            return
        end
        % Construction des noms et chemins des fichiers
        v_params_err_file=[v_data_key '_' v_params_err_file_name v_params_err_file_ext];
        v_params_err_file_path=fullfile(v_dir_err,v_params_err_file);
        v_data_err_file=[v_data_key '_' v_data_err_file_name v_data_err_file_ext];
        v_data_err_file_path=fullfile(v_dir_err,v_data_err_file);
        % Si le fichier existe, chargement des valeurs de parametres
        if exist(v_params_err_file_path,'file')
            load(v_params_err_file_path);
        else
            v_params_err=[];
        end
        % Extraction de la liste de mots cles des fichiers modele sauves
        vc_key={vc_err_data{v_first_id}{1}.key.name};
        % Si le fichier existe, extraction des donnees presentes dans le
        % fichier
        if exist(v_data_err_file_path,'file')
            v_fid=fopen(v_data_err_file_path,'r');
            vc_lines=textscan(v_fid,'%s','Delimiter','\n');
            vc_lines=vc_lines{1};
            fclose(v_fid);
            v_err_line_num=length(vc_lines)-2;
        else % Sinon remplissage des lignes d'en-tete, liste des noms de parametres,en-tetes colonnes
            vc_lines={};
            ntab1=1;
            % si les parametres sont consignes dans vc_err_data
            if isfield(vc_err_data{v_first_id}{1},'parnames')
                ntab1=3;
                vc_lines{1}=['Liste des parametres;' sprintf('%s;',vc_err_data{v_first_id}{1}.parnames{:})];
                vc_lines{2}='';
            end
            vc_lines{ntab1}=['Num. Erreur;Identifiant de l''echantillon;USM;Type d''erreur;Message d''erreur;Solution / Source;' sprintf('Fichier modele :%s;',vc_key{:})];
            v_err_line_num=1;
        end
        % Boucle sur les elements du cell des usm contenant potentiellement
        % des erreurs
        for i=1:length(vc_err_data)
            if isempty(vc_err_data{i})
                continue
            end
            v_usm=vs_errors_warnings.vc_usm_out{i};
            v_next_usm=false;
            switch v_mode
                case 'last'
                    % On prend les donnees de la derniere execution
                    v_loop=length(vc_err_data{i});
                case 'all'
                    % On prend toutes les erreurs
                    v_loop=1:length(vc_err_data{i});
            end
            % Boucle sur les erreurs pour l'usm courante
            for j=v_loop
                % Si aucune structure d'erreur n'est stockee on passe a l'usm
                % suivante
                if isempty(vc_err_data{i}{j})
                    continue
                end
                v_next_error=false;
                % Construction des infos a inscrire dans les colonnes du fichier
                % numero d'erreur, identifiant echantillon, type
                % d'erreur,message d'erreur, noms des differents fichiers modele sauvegardes
                %
                % Traitement du message d'erreur initial pour eliminer les retours a la ligne
                % possibles
                vc_message_lines=textscan(vc_err_data{i}{j}.message,'%s','delimiter','\n');
                vc_err_data{i}{j}.message=sprintf('%s. ',vc_message_lines{1}{:});
                %
                vc_line_data={num2str(v_err_line_num),num2str(vc_err_data{i}{j}.sampleId),v_usm,vc_err_data{i}{j}.type,vc_err_data{i}{j}.message...
                    vc_err_data{i}{j}.solution};
                % Ajout des noms des fichiers modele conserves
                for k=1:length(vc_key)
                    vs_fparts=F_file_parts(vc_err_data{i}{j}.(vc_key{k}));
                    % Si le fichier est deje reference
                    v_file=[vs_fparts.name vs_fparts.ext];
                    if length(vc_lines)>3 && ~isempty(cell2mat(cellfun(@(x) strfind(x,v_file),vc_lines(4:end),'UniformOutput',false)))
                        switch v_mode
                            case 'last' % on specifie le passage a l'usm suivante
                                v_next_usm=true;
                                break
                            case 'all' % on passe specifie le passage a l'erreur suivante
                                v_next_error=true;
                                break
                        end
                    end
                    % Ajout du nom du fichier courant aux donnees de la
                    % ligne a ecrire dans le fichier
                    vc_line_data{end+1}=v_file;
                end
                % Si les infos de l'erreur en cours de traitement existent
                % on passe a l'erreur suivante pour l'usm courante
                if v_next_error
                    %disp('case all : Erreur deje referencee pour l''usm')
                    continue
                end
                % Si les infos de l'erreur deje consignees on passe a l'usm
                % suivante
                if v_next_usm
                    %disp('case last : Erreur deje referencee pour l''usm')
                    break
                end
                % Ajout des valeurs des parametres a la matrice.
                % et des donnees associees a l'erreur dans le cell vc_lines
                if isfield(vc_err_data{i}{j},'parvals')
                    v_params_err=[v_params_err;vc_err_data{i}{j}.parvals'];
                end
                vc_lines{end+1}=sprintf('%s;',vc_line_data{:});
                % Increment du numero d'erreur
                v_err_line_num=v_err_line_num+1;
            end
        end
        % Sauvegarde du fichier csv
        v_fid=fopen(v_data_err_file_path,'w');
        fprintf(v_fid,'%s\n',vc_lines{:});
        fclose(v_fid);
        % Si les params sont presents, production fichier mat
        if isfield(vc_err_data{v_first_id}{1},'parnames')
            % Sauvegarde du fichier mat
            save(v_params_err_file_path,'v_params_err');
        end

        % Infos sur les fichiers produits
        vs_files.(v_data_key).name{1}=v_data_err_file;
        vs_files.(v_data_key).name{2}=v_params_err_file;
        vs_files.(v_data_key).dir=v_dir_err;
    end
end
