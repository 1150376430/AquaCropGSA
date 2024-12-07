function  varargout = F_xls2csv(v_filedir_name,varargin)
% F_XLS2CSV  Conversion de fichier(s) xl en csv
%   F_xls2csv([v_filedir_name ,v_dest_dir,vs_options])
%
%   ENTREE(S): optionnelles
%      - v_filedir_name :
%       * chemin du fichier xls ou xlsx absolu ou relatif
%       * cell de noms ou chemins de fichiers
%       * chemin d'un repertoire
%       * utilisation de wildcards autorisee, pour l'instant seult '*' est
%       pris en compte
%      - v_dest_dir
%      - vs_options = structure specifiant les options
%
%        champs :
%           .recurse (true/false(default)):
%             si v_filedir_name est un repertoire, execution en recursif
%             dans les sous-repertoires
%           .columns :les plages a selectionner
%            pour l'instant selection uniquement de colonnes par leur
%            nom 'A:Z' par ex, pour une plage
%
%
%
%   SORTIE(S):
%      - vs_default_options : si pas d'argument en entree
%      - fichier ou lot de fichiers au format csv
%
%   CONTENU:
%
%   APPEL(S):
%      - F_get_abspath
%
%   EXEMPLE(S):
%      - F_xls2csv : tous les fichiers xl du repertoire courant
%      - F_xls2csv('t*.xls') : tous les fichiers xl du repertoire courant
%      dont le nom commence par t
%      - F_xls2csv('fichier.xls')
%      - F_xls2csv({'fichier.xls' 'fichier2.xls'})
%      - F_xls2csv('d:\travail')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 14-Sep-2010
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-25 15:11:49 +0200 (mar., 25 juin 2013) $
%    $Author: sbuis $
%    $Revision: 950 $
%
%
% See also ispc, actxserver, F_get_abspath, F_rdir, F_disp, F_file_parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Environnement windows ?
if ~ispc
    F_disp('Impossible de transformer le fichier excel en csv (seulement sous Windows)')
    return
end

% Generation des options par defaut
vs_default_options.select=false;
vs_default_options.columns='';
vs_default_options.recurse=false;

% Traitement du type de filename: file, dir (et contenu)
if ~nargin
    if nargout
        varargout{1}=vs_default_options;
    else
        F_disp('Nom de fichier Excel ou de repertoire contenant des fichiers requis!');
    end
    return
end

if nargin > 1
    for iarg=1:length(varargin)
        if ischar(varargin{iarg})
            v_dest_dir=varargin{iarg};
        elseif isstruct(varargin{iarg})
            vs_options=varargin{iarg};
        else
            F_disp('Erreur sur les arguments supplementaires !')
            return
        end
    end
end

if exist('v_dest_dir','var') && strcmp('.',v_dest_dir)
    v_dest_dir=pwd;
end

if ~exist('vs_options','var')
    vs_options=vs_default_options;
end

if ~isfield(vs_options,'recurse')
   vs_options.recurse=false; 
end

v_dir=[];
if ischar(v_filedir_name)
    if strcmp('.',v_filedir_name)
        v_filedir_name=pwd;
    end
    % c'est un fichier xl
    if exist(v_filedir_name,'file')==2
        vc_filepaths={F_get_abspath(v_filedir_name)};
        vs_fparts=F_file_parts(vc_filepaths{1});
        v_dir=vs_fparts.dir;        
    else % c'est un repertoire ou chaine avec wildcards
        v_wildcards=strfind(v_filedir_name,'*');
        if v_wildcards
            vs_fparts=F_file_parts(v_filedir_name);
            v_dir=F_get_abspath(vs_fparts.dir);
            v_search_str=fullfile(v_dir,[vs_fparts.name vs_fparts.ext]);
        elseif isdir(v_filedir_name)
            v_dir=F_get_abspath(v_filedir_name);
            v_search_str=fullfile(v_dir,'*.xls*');
        end
        
        % Si recurse == true
        % extraction de la liste des repertoires
        switch vs_options.recurse
            case true
                % extraction des noms des fichiers en recursif dans les
                % sous-repertoires
                vs_files_inf=F_rdir(v_search_str);
            case false
                % extraction des noms des fichiers dans le repertoire
                vs_files_inf=dir(v_search_str);
        end
        % Constitution de la liste des chemins e traiter
        if ~isempty(vs_files_inf)
            if isfield(vs_files_inf,'dir')
                vc_filepaths=arrayfun(@(x) {fullfile(x.dir,x.name)},vs_files_inf);
            else
                vc_filepaths=arrayfun(@(x) {fullfile(v_dir,x.name)},vs_files_inf);
            end
        else
            F_disp(['Le repertoire ' v_filedir_name ' ne contient pas de fichier XL']);
            return
        end      
    end
elseif iscellstr(v_filedir_name)
    vc_filepaths=v_filedir_name;
end

%

% Message attente
F_disp('Debut de la conversion des fichiers, attendre le message de fin.');

% Ouverture objet com appli xl
exl = actxserver('Excel.Application');
set(exl,'DisplayAlerts',0);

% Traitement de la liste des chemins des fichiers
for v_ifname=1:length(vc_filepaths)
    v_filedir_name=vc_filepaths{v_ifname};
    % existence du fichier
    if ~exist(v_filedir_name,'file')
        F_disp(['* Pas de conversion de ' v_filedir_name ]);
        F_disp('  -> Le fichier n''existe pas. ')
        continue
    end
    % Extraction des parties du fichier
    vs_fparts=F_file_parts(v_filedir_name);
    % Chemin du fichier e produire csv
    if exist('v_dest_dir','var')
        % PRENDRE EN CHARGE RECALCUL SOUS ARBO REP INITIAL VERS REP DEST
        % POUR L'INSTANT : TOUS LES FICHIERS CSV DANS LE MM REPERTOIRE
        % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        v_out_filename=fullfile(v_dest_dir,[vs_fparts.name '.csv']);
    else
        v_out_filename=fullfile(vs_fparts.dir,[vs_fparts.name '.csv']);
    end
    % Test pour la conversion si le fichier csv est plus ancien que le xl
    src=dir(v_filedir_name);
    dest=dir(v_out_filename);
    if ~isempty(dest) && (src.datenum <= dest.datenum)
        F_disp(['* Pas de conversion de ' v_filedir_name ' vers ' v_out_filename]);
        F_disp('  -> le fichier est a jour!');
        continue
    end
    % Si le fichier csv n'existe pas ou est plus ancien que le fichier xl
    try
        % Ouverture du fichier
        exlFile=exl.Workbooks.Open(v_filedir_name);
        
        % Affichage avancement conversion
        F_disp(['* Conversion de ' v_filedir_name ' vers ' v_out_filename]);
       
        % Si selection a faire
        if isfield(vs_options,'select') && vs_options.select ...
                && ~isempty(vs_options.columns)
            exlFile.Sheets.Add;
            % selection de la feuille originale
            exlFile.Sheets.Item(2).Select;
            % Voir si select est necessaire !!!
            exlFile.ActiveSheet.Columns.Item(vs_options.columns).Select;
            exlFile.ActiveSheet.Columns.Item(vs_options.columns).Copy;
            exlFile.Sheets.Item(1).Activate;
            exlFile.ActiveSheet.Paste;
        end        
        % Enregistrement en format csv
        exlFile.SaveAs(v_out_filename,6);      
    catch
        F_disp(['Erreur lors de la conversion de ' v_filedir_name ' vers ' v_out_filename]);
    end
    % Fermeture du fichier sans enregistrement
    exlFile.Close(false);
end
% Suppression objet xl
exl.Quit;
exl.delete;

% Affichage fin conversion
F_disp('Conversion des fichiers terminee!');
end