function varargout=F_set_static_classpath(vc_java_path)
% F_SET_STATIC_CLASSPATH Ajout de chemins vers des classes java dans
% javaclasspath static
%   varargout=F_set_static_classpath(vc_java_path)
%  
%   ENTREE(S): descriptif des arguments d'entrée
%      - vc_java_path : char ou cellstr de chemins
%      vers des repertoires ou fichiers archives jar
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - varargout{1} : true si besoin de redémarrage matlab pour charger
%          les nouveaux javapath, false sinon
%  
%   CONTENU: ajout de chemins au fichier classpath.txt 
%   après copie si nécessaire dans le repertoire de
%   l'utilisateur
% 
%  
%   APPEL(S): 
%      - getenv
%  
%   EXEMPLE(S): 
%      - F_set_static_classpath('c:\temp\classes');
%      - F_set_static_classpath('c:\temp\classes\archive.jar');
%      - F_set_static_classpath({'c:\temp\classes' 'c:\temp\classes\archive.jar'});
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 21-Mar-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also getenv,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sans argument
if ~nargin
    return
end
% Si un seul path en char
if ischar(vc_java_path)
   vc_java_path={vc_java_path}; 
end
% Une liste.
if ~iscellstr(vc_java_path)
   return 
end


% Vérification si le fichier classpath.txt existe dans le rep. user
% sinon copie
v_class_path_file=which('classpath.txt');

% Repertoire actuel du classpath.txt
v_dir=fileparts(v_class_path_file);

% Si le v_dir n'est pas ue userdir on copie le file
% attention voir pour UNIX/linux
if ispc
    v_home_dir=userpath;
    v_delim=';';
elseif any([isunix ismac])
    v_home_dir=userpath;
    v_delim=':';
end
% Si le userpath est empty on le reset
if isempty(v_home_dir) || isempty(strrep(v_home_dir,v_delim,''))
	userpath('reset')
	v_home_dir=userpath;
end
% suppression du ; final

v_home_dir=strrep(v_home_dir,v_delim,'');

% classpath.txt dans le home dir
v_new_class_path_file=fullfile(v_home_dir,'classpath.txt');

% Prise en charge de la suppression du fichier classpath.txt 
if isempty(vc_java_path)
    if exist(v_new_class_path_file,'file')
        delete(v_new_class_path_file);
        F_disp('-------------------------------------------------------------------------');
        F_disp('ATTENTION !');
        F_disp('Pour que la mise a jour/suppression de certains programmes java soit effective, ');
        F_disp('redemarrage de Matlab necessaire.');
        F_disp('-------------------------------------------------------------------------');
    end
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   A partir de la code inutile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Si le fichier n'est pas dans le home dir
if ~strcmp(v_dir,v_home_dir) && ~exist(v_new_class_path_file,'file')
    copyfile(v_class_path_file,v_home_dir); 
    % Attribution des droits en ecriture
    fileattrib(v_new_class_path_file,'+w','u')
end

    
% Verification des args entree: existence chemins dans systeme fichiers
v_filter=logical(cellfun(@(x) exist(x,'file'),vc_java_path));

% Affichage de ceux qui n'existent pas
if any(~v_filter)
    vc_unknown=vc_java_path(~v_filter);
    F_disp('Chemin(s) inexistant(s) non pris en compte dans javaclasspath:')
    F_disp(sprintf('%s\n',vc_unknown{:}));
end

% Selection des chemins à inscrire dans le fichier
vc_java_path=vc_java_path(v_filter);

% Réécriture avec / au lieu de filesep
vc_java_path=cellfun(@(x) {strrep(x,filesep,'/')},vc_java_path);

% Si la liste est vide on sort
if isempty(vc_java_path)
    return
end

% Lecture des chemins dans le fichier
v_fid=fopen(v_class_path_file,'r');
vc_lines=textscan(v_fid,'%s','delimiter','\n');
fclose(v_fid);
vc_lines=vc_lines{1};
v_lines_nb=length(vc_lines);

% Rechercher si les chemins existent
for i=1:length(vc_java_path)
    vs_fparts=F_file_parts(vc_java_path{i});
    v_type=exist(vc_java_path{i},'file');
    if v_type==7  % repertoire
        vv_existing_paths=cellfun(@(x) ~isempty(x),((cellfun(@(x) strfind(x,vc_java_path{i}) & ~strcmp(x,vc_java_path{i}),...
            vc_lines,'UniformOutput',false))));
    elseif v_type==2 % fichier
        vv_existing_paths=cellfun(@(x) ~isempty(x),(cellfun(@(x) strfind(x,['/' vs_fparts.name vs_fparts.ext]) ...
            ,vc_lines,'UniformOutput',false)));
    else
       continue 
    end
    % chemins exacts existants dejà
    vv_path2add_exists=cellfun(@(x) strcmp(x,vc_java_path{i}),vc_lines);
    vv_existing_paths=vv_existing_paths &  ~vv_path2add_exists;
    vc_existing_lines=vc_lines(vv_existing_paths);
    % suppression des chemins inexacts
    if ~isempty(vc_existing_lines)
        vc_lines=vc_lines(~vv_existing_paths);
    end
end

% Filtre des chemins existants  
vc_java_path=setdiff(vc_java_path,vc_lines);
% end
if isempty(vc_java_path) % pas de nouveau chemin a inscrire, on sort
    varargout{1}=false;
    if length(vc_lines)~=v_lines_nb
        % Ré-écriture du fichier au cas ou (si suppression de lignes)
        v_fid=fopen(v_new_class_path_file,'w');
        fprintf(v_fid,'%s\n',vc_lines{:});
        fclose(v_fid);
    end
    return 
end
% Ajout des nouveaux chemins
vc_lines={vc_lines{:} vc_java_path{:}};
v_fid=fopen(v_new_class_path_file,'w');
fprintf(v_fid,'%s\n',vc_lines{:});
fclose(v_fid);
%
% Redémarrage nécessaire
F_disp('-------------------------------------------------------------------------');
F_disp('ATTENTION !');
F_disp('Pour que les nouveaux programmes java soient pris en compte: ');
F_disp('Redemarrage de Matlab necessaire.');
F_disp('-------------------------------------------------------------------------');
varargout{1}=true;
return

