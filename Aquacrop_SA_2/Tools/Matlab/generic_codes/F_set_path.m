function F_set_path(varargin)
%F_SET_PATH  Ajout de chemins d'acces a des fonctions dans le path matlab
%   F_set_path([v_path_key,v_dist_path])   
%  
%   ENTREE(S):
%      - Arguments optionnels
%      - v_path_key: 
%           mots cle 'reset': pour annuler le choix fait sur la
%                    distribution, si plusieurs sont presentes, et faire un
%                    choix de nouveau si v_dist_path n'est pas fourni.
%
%      - v_dist_path: chemin du repertoire racine de la distribution
%
%  
%   SORTIE(S): 
%      - ajout de chemin dans le path matlab pour avoir acces aux fonctions
%      des librairies
%  
%   CONTENU: 
%      - lecture d'un fichier envpaths.mat cree par F_startup execute avant
%      la premiere utilisation de multisimlib, chargement d'une variable 
%      (structure) contenant les infos sur les chemins a ajouter a path, 
%      ajout des path permettant l'acces aux fonctions des librairies.
%      - si plusieurs distributions ont ete enregistrees (suite execution
%      de la fonction F_startup), specifier le chemin de la distribution e
%      utliser
%  
%   APPEL(S): liste des fonctions appelees
%      - F_load_envpaths
%      - F_startup
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_set_path
%      - F_set_path('reset')
%      - F_set_path('d:\multisimlib_root_path')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 04-Sep-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2014-03-18 17:16:46 +0100 (mar., 18 mars 2014) $
%    $Author: (local) $
%    $Revision: 940M $
%  
%  
% See also F_load_envpaths, F_startup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

% Si on est en environnement compile, sortie 
if isdeployed
    return
end

% On fixe le contrele des erreurs et affichages : infos,erreurs
global v_display;

% Si les paths ne sont pas fixes
if exist('F_set_display','file')
    F_set_display;
else
    v_display=true;
end


% Test de coherence du Numero de revision de la distribution
% par rapport a celui de F_startup
%
% Renseignement sur le numero de head-revision
% La valeur est remplacee chaque fois d'une distribution sera produite
% avec F_create_distribution.
% Elle est en coherence avec la variable dans F_startup
v_head_revision='1036';
v_lib_root=F_load_envpaths('root');
v_startdir=pwd;
cd(fullfile(v_lib_root,'Conf'));
v_startup_rev=F_startup;
if str2double(v_head_revision)~=v_startup_rev
   F_disp('Erreur: la version de F_set_path n''est apparemment pas correcte')
   F_disp('Re executer F_startup avant F_set_path');
   cd(v_startdir)
   return
end

cd(v_startdir)

% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
F_test_mfile_rev('F_set_path','$Revision: 940M $',true)


% Definition du nom du fichier marqueur selon l'OS.
if ispc
    v_tag_filename='multisimlib*.set';
elseif isunix
    v_tag_filename='.multisimlib*.set';
end

% Liste pour consigner les chemins qui n'existent pas
vc_unknown_paths={};
v_up_num=1;
vc_path_keys={'common' 'opti'};
v_reset=false;
if nargin
    for n=1:length(varargin)
        if strcmpi('reset',varargin{n})
            v_reset=true;
        elseif ischar(varargin{n})
            v_dist_path=varargin{n};
            if ~isdir(varargin{n})
                F_create_message(v_dist_path,'le repertoire n''existe pas ou n''est pas un repertoire!',1,1);
            end
        end
    end
end

% Recuperation des infos sur les distrib. referencees
% 
[v_lib_tmp_path, vs_referenced_paths,v_user_temp_path] = F_get_tmp_path;

if v_reset
    % Restauration droit modif.
    fileattrib([v_user_temp_path filesep v_tag_filename],'+w');
    delete(fullfile([v_user_temp_path filesep v_tag_filename]));
end

%  Verification si une distrib a ete choisie
vs_mslib_set_file=dir([v_user_temp_path filesep v_tag_filename]);

% 
% Si on a plus d'une distrib.
if isempty(vs_mslib_set_file) % le choix n'a pas ete fait : fichier multisimlib?.set n'existe pas
    % Si plisieurs repertoires de distrib existent
    if length(vs_referenced_paths)>1
        v_err=false;
        % Liste des chemins disponibles
        vc_lib_root_pathslist={vs_referenced_paths.lib_root};
        if ~exist('v_dist_path','var')
            v_err_message='Le chemin de la librairie est necessaire (plusieurs sont disponibles).';
            v_err=true;
        elseif ~any(ismember(vc_lib_root_pathslist,v_dist_path))
            v_err_message='Le chemin specifie est inexistant!';
            v_err=true;
        end
        % Dialogue pour faire le choix
        if v_err
            F_disp(' ');
            F_disp(v_err_message);
            v_dist_path = F_user_input('Chemin de la distribution a utiliser ?',vc_lib_root_pathslist,vc_lib_root_pathslist);
            F_disp('');
            F_disp('Pour supprimer une ou des distributions, utiliser la fonction F_rm_path :');
            F_disp(sprintf('%s\n\t\t%s','- Une distribution :','F_rm_path(''chemin_du_repertoire_racine'',''delete'')'));
            F_disp(sprintf('%s\n\t\t%s','- Les autres distributions que celle choisie :',...
                'F_rm_path(''chemin_du_repertoire_racine_distribution_a_conserver'',''purge'',''delete'')'));
            F_disp(' ');
            F_disp('>> Pour plus d''infos : help F_rm_path');
            F_disp(' ');
            F_disp(' ');
        end
    else
        v_dist_path=vs_referenced_paths.lib_root;
    end

    % Le chemin de la distribution a ete specifie
    [v_lib_root,v_lib_paths,v_lib_dirs,v_lib_tmp_path]=F_load_envpaths('root',...
        'paths','dirs','temp',v_dist_path);
else
    [v_lib_root,v_lib_paths,v_lib_dirs]=F_load_envpaths('root','paths','dirs');
end

% Creation du fichier marqueur a l'issue du choix de la distrib.

vs_files=dir([v_user_temp_path filesep v_tag_filename]);

if ~isempty(vs_files)
    % Restauration droit modif.
    fileattrib([v_user_temp_path filesep v_tag_filename],'+w')
    delete(fullfile(v_user_temp_path,vs_files.name));
end

% generation du fichier marqueur du choix de la distrib.
fclose(fopen([v_lib_tmp_path '.set'],'w'));
% Droit lecture seule pour preservation
fileattrib([v_lib_tmp_path '.set'],'-w')
% Sur les fichiers .m
fileattrib([v_lib_tmp_path filesep '*.m'],'-w');

% Ajout du chemin du rep. temporaire en tete de liste
addpath(v_lib_tmp_path);

% Ajout des chemins dans le path
for k=1:length(vc_path_keys)
    v_key=vc_path_keys{k};
    for i=1:length(v_lib_paths.(v_key))
        v_path2add=fullfile(v_lib_root,v_lib_paths.(v_key){i});
        if exist(v_path2add,'dir')
            addpath(v_path2add);
        else
            vc_unknown_paths{v_up_num}=v_path2add;
            v_up_num=v_up_num+1;
        end
    end
end


% Renvoi de la liste des repertoires inexistants et message reexecution
% F_startup ou verification existance repertoires ...
try
    if ~isempty(vc_unknown_paths)
        error('MSLIB:dirPathError','Erreur sur le(s) repertoire(s)');
    end
catch pathError
	try
		F_create_message(vc_unknown_paths,'Repertoire(s)inexistant(s)',1,1,pathError);
	catch
		F_disp([vc_unknown_paths ': Repertoire(s)inexistant(s)']);
		F_disp(pathError.message);
		return;
	end
end

% Suite a suppression version appel java
% fonction permettant la suppression du fichier classpath.txt si il exist
F_set_static_classpath({});

% On repositionne le repertoire temp en tete
addpath(v_lib_tmp_path);
