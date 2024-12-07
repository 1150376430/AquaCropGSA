function varargout = F_log(varargin)
%F_LOG  Enregistrement d'informations Entrees/sorties clavier/ecrans
%       interface et infos forcees par l'utilisateur
%   F_log(...,...,...)
%
%   ENTREE(S): descriptif des arguments d'entree
%      - mots cles determinant une action, ou mot cle et valeur
%      - chaines de caractere, noms de variables, valeurs numeriques...
%      - valeur logique pour activer l'affichage de messages a ajouter en
%      dernier argument F_log(...,...,true)
%
%   SORTIE(S):
%      - argument de sortie: optionnel
%         v_log_file : produit si en argument d'entree on specifie 'file',
%         = chemin du fichier de log declare
%
%      - Fichier : fichier de log au format texte nomme
%      NomPrefixe_jj_mm_aaaa_HH_MM_SS.log
%                jj = numero du jour dans le mois
%                mm = numero du mois
%                aaaa = numero de l'annee
%                HH : heures, MM : minutes, SS : secondes
%
%   CONTENU: descriptif de la fonction
%   La fonction utilise le fonction diary qui active la consignation d'infos
%   affichees a l'ecran, la saisie clavier, les actions dans l'interface
%   matlab dans un fichier dont le nom est accessible en permanence sans
%   utiliser de variable globale, ni de stockage. Ce meme fichier contient
%   des infos volontairement ecrites par l'utilisateur dans les
%   fonctions/scripts par un simple appel F_log('Mon information',
%   'NomVariable',...). L'ecriture automatique des infos ecran/clavier est desactivable
%   et activable a la demande F_log('stop'), F_log('start'), autant de fois que l'on veut
%   (dans ce cas une ligne est ajoutee dans le fichier pour notifier l'arret ou le demarrage
%   de l'ecriture). On peut aussi suspendre et reprendre l'ecriture dans le
%   fichier comme pour 'stop' et 'start' mais sans notification avec
%   'suspend' et 'resume'
%
%   L'arret/cloture du fichier log est effective par F_log('finish').
%
%   APPEL(S): liste des fonctions appelees
%      - diary
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - Activation de la fonction de log : F_log('set','NomPrefixe')
%      - Activation/deactivation enregistrement entrees/sorties
%           - avec notification: F_log('start'), F_log('stop')
%           - sans notification: F_log('resume'), F_log('suspend')
%      - Arret de l'enregistrement des logs (cloture du fichier): F_log('finish')
%      - Vidage d'un fichier de log : F_log('clean')
%      - Enregistrement d'une information : F_log('Texte
%      infos',variable1)
%      - affichage du chemin du fichier de log, si defini: F_log('set')
%      - reinitialisation du processus de log : F_log('reset')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 11-Apr-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-11-27 11:10:42 +0100 (mer., 27 nov. 2013) $
%    $Author: plecharpent $
%    $Revision: 1021 $
%  
%
% See also F_test_mfile_rev,diary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
F_test_mfile_rev('F_log','$Revision: 1021 $')

% On fixe le controle des erreurs et affichages : infos,erreurs
global v_display;
F_set_display;

% for inactivating writing tracing informations 
global v_trace;

% Definitions des actions possibles
v_actions={'start','stop','clean','reset','finish','set','suspend','resume','file','status','move','name',...
    'path','hline'};
% Recuperation systematique du status du Diary : definit si le fichier de log est actif ou
% non
v_log_status=F_get_status;
%

% Reduction des arguments d'entree si presence de true pour affichage des
% messages
v_disp=0;
if isempty(v_trace)
    v_trace=true;
end

vc_args_val={varargin{:}};
vc_args_name=arrayfun(@inputname,1:length(varargin),'UniformOutput',false);
if ~isempty(vc_args_val)
    v_arg_sel=cellfun(@isempty, vc_args_name) & cellfun(@(x) islogical(x)==true, vc_args_val);
    % Si true est present en derniere position des arguments
    if find(v_arg_sel,1)
        v_disp=1;
        vc_args_name=vc_args_name(~v_arg_sel);
        vc_args_val=vc_args_val(~v_arg_sel);
    end
    v_arg_sel=cellfun(@(x) ischar(x)==true & strcmp('notrace',x), vc_args_val);
    if any(v_arg_sel)
        v_trace=false;
        vc_args_name=vc_args_name(~v_arg_sel);
        vc_args_val=vc_args_val(~v_arg_sel);
    end
end
v_nargs=length(vc_args_name);

switch v_nargs
    % Par defaut sans argument : affichage du statut du tracage sorties,
    % entrees...
    % Si le nom du fichier log n'a pas ete defini : le tracage n'est pas
    % possible, un message est affiche
    case 0
        % On retourne par defaut le status
        varargout{1}=v_log_status;
        % Le nom du fichier n'a pas ete defini (F_log('set', 'NomPrefixe')
        % non execute)
        if F_isset_file
            if ~nargout
                F_get_file(v_disp);
            end
        else
            if v_disp
                %disp(F_notif_str('setinf'))
                F_disp(F_notif_str('setinf'));
            end
        end

    case 1 % soit action, soit chaine ou contenu d'une variable a ecrire
        v_str_to_write='';
        if isnumeric(vc_args_val{1}) || isstruct(vc_args_val{1}) || iscell(vc_args_val{1})
            % si array, ou autre type de variable : transformation en
            % chaine de caracteres
            v_str_to_write=F_cell_str(vc_args_name,vc_args_val);
        elseif ischar(vc_args_val{1})
            if ismember(vc_args_val{1},v_actions)
                switch find(strcmp(v_actions,vc_args_val{1}))
                    case 1 % start
                        if ~F_isset_file(v_disp)
                            return
                        end
                        if ~v_log_status
                            F_log_write(F_notif_str('on'));
                            diary on;
                        end

                    case 2 % stop
                        if v_log_status && F_isset_file
                            diary off;
                            F_log_write(F_notif_str('off'));
                        end

                    case 3 % clean
                        if F_isset_file
                            F_log('stop');
                            fclose all;
                            delete(F_get_file);
                            F_log_write({F_notif_str('begin'),...
                                F_notif_str('file'),F_notif_str('hline')});
                            F_set_file(F_get_file);
                            F_log('start');
                        end

                    case 4 % reset
                        F_reset_file;

                    case 5 % finish
                        if F_isset_file
                            if v_log_status
                                F_log('stop');
                            end
                            F_log_write({F_notif_str('hline'),F_notif_str('end')});
                            v_file_path=F_log('file');
                            % Reecriture du fichier sans html
                            F_html2txt(v_file_path);
                            F_reset_file;
                           
                        end

                    case 6 % set
                        if F_isset_file
                            F_get_file(v_disp);
                        end
                    case 7 %suspend
                        if v_log_status && F_isset_file
                            diary off;
                        end

                    case 8 %resume
                        if ~v_log_status && F_isset_file
                            diary on;
                        end
                    case 9 % file
                        varargout{1}='';
                        if F_isset_file
                            varargout{1}=F_get_file;
                        end

                    case 10 % status
                        v_inf_status='offinf';
                        if v_log_status
                            v_inf_status='oninf';
                        end
                        if v_disp
                            %disp(F_notif_str(v_inf_status))
                            F_disp(F_notif_str(v_inf_status));
                        end

                    case 11 % move
                        if v_log_status
                            v_user=F_load_envpaths('user');
                            F_move_file(v_user.output.path);
                        end
                    case 12 % name
                        varargout{1}='';
                        if F_isset_file
                            varargout{1}=F_get_file('name');
                        end
                        
                    case 13 % path
                        varargout{1}='';
                        if F_isset_file
                            varargout{1}=F_get_file();
                        end
                        
                    case 14 % hline 
                        F_log_write(F_notif_str('hline'));
                end
            else
                % Renseignement variable a ecrire dans le fichier
                v_str_to_write=vc_args_val{1};
            end
        end
        % si le fichier n'a pas ete initialise, on ne fait rien
        if ~F_isset_file(v_disp)
            return
            % si la chaine de caracteres n'est pas vide on ecrit dans le
            % fichier
        else
            if ~isempty(v_str_to_write)
                F_log_write(v_str_to_write);
            end
        end

    otherwise
        %
        % On a plus d'un argument:
        %
        % Initialisation du nom du fichier log et activation du log
        if v_nargs==2 && iscellstr(vc_args_val) && strcmp('set',vc_args_val{1})
            % extraction infos parties chemin fichier
            vs_fparts=F_file_parts(vc_args_val{2});
            % le 2eme argument est un chemin absolu: repertoire+nom fichier
            if ~isempty(vs_fparts.dir) && isdir(vs_fparts.dir)
                v_log_dir=vs_fparts.dir;
                v_log_name=vs_fparts.name;
            else
                % recuperation du chemin du repertoire out positionne
                v_user=F_load_envpaths('user');
                % repertoire par defaut du fichier log et nom du fichier
                v_log_dir=v_user.output.path;
                v_log_name=vc_args_val{2};
            end
            v_log_file=fullfile(v_log_dir,[v_log_name '_' datestr(now,'dd_mm_yyyy_HH_MM_SS') '.log']);
            % v_log_file=fullfile(v_user.output.path,[vc_args_val{2} '_' datestr(now,'dd_mm_yyyy_HH_MM_SS') '.log']);
            F_set_file(v_log_file);
            % F_log('start',v_trace);
            F_log('start');
        % le 3eme argument est sense contenir le nom du repertoire : si il
        % n'existe pas on essaie de le creer, si echec le repertoire
        % courant est considere , et activation du log
        elseif v_nargs==3  && strcmp('set',vc_args_val{1})
            v_dir=pwd; % par defaut repertoire courant
            if isdir(vc_args_val{3}) % si l'argument fourni est le chemin d'un repertoire
                v_dir=vc_args_val{3};
            else
                try 
                    mkdir(vc_args_val{3});
                    v_dir=vc_args_val{3};
                catch
                end
            end
            v_log_file=fullfile(v_dir,[vc_args_val{2} '_' datestr(now,'dd_mm_yyyy_HH_MM_SS') '.log']);
            F_set_file(v_log_file);
             F_log('start');
            %F_log('start',v_trace);
        % deplacement du fichier vers vc_args_val{1}
        elseif v_nargs==2 && strcmp('move',vc_args_val{1}) 
            F_move_file(vc_args_val{2});   
        else
            % Fichier non initialise : on ne fait rien
            if ~F_isset_file(v_disp)
                return
            end
            % sinon on ecrit les chaines speficiees en arguments
            v_strs_to_write=F_cell_str(vc_args_name,vc_args_val);
            % Ecriture des infos dans le fichier
            F_log_write(v_strs_to_write);
        end
end


%% Sous-fonctions appelees par F_log
%
% Formatage des chaines de caractere a ecrire dans le fichier
% de log
function v_strs_to_write=F_cell_str(vc_names,vc_values)
v_strs_to_write=cell(1,length(vc_names));
for i=1:length(vc_names)
    if ischar(vc_values{i})
        v_strs_to_write{i}=vc_values{i};
    elseif ~isempty(vc_names{i})
        v_strs_to_write{i}=evalc(sprintf('%s=vc_values{%d}',vc_names{i},i));
    else
        v_strs_to_write{i}=evalc(sprintf('vc_values{%d}',i));
    end
end


function v_log_status = F_get_status
% Recuperation du statut d'activite d'enregistrement
v_log_status=strcmp('on',get(0,'Diary'));


function v_isset = F_isset_file(varargin)
% Evaluation si le fichier a ete renseigne (par F_log('set','NomPrefixe'))
% avec affichage d'un message si non defini et 1 fourni en argument pour
% v_display
switch nargin
    case 0
        v_disp=0;
    case 1
        v_disp=varargin{1};
end
v_isset = 0;
v_file=F_get_file;
if ~strcmp(v_file,'diary') && ~isempty(v_file)
    v_isset = 1;
end
if ~v_isset && v_disp
    %disp(F_notif_str('setinf'))
    F_disp(F_notif_str('setinf'));
end


function F_reset_file
% Annulation du log et restauration du nom par defaut
if ~strcmp(F_get_file,'diary')
    diary('diary');
    diary off;
    delete('diary');
end


function F_move_file(v_new_location)
v_current_path=F_get_abspath(F_log('file'));
vs_fparts=F_file_parts(v_current_path);
v_new_location=F_get_abspath(v_new_location);
if strcmp(vs_fparts.ext,'.log') && ~strcmp(vs_fparts.dir,v_new_location)
    v_new_path=fullfile(v_new_location,[ vs_fparts.name,vs_fparts.ext]);
    F_log('suspend');
    if exist(v_current_path,'file')==2
        movefile(v_current_path,v_new_path);
    end
    F_set_file(v_new_path,'append');
    F_update_file_str('file');
    F_log('resume');
end


function F_set_file(varargin)
% Definition du nom du fichier par defaut
v_log_file='diary';
% Definition si nouveau ou suite
v_type='new'; % par defaut c'est un nouveau, ecriture en-tete
% Definition du nom du fichier et activation du log
switch nargin
%     case 0
%         v_log_file='diary';
    case {1,2}
        for i=1:length(varargin)
            if strcmp(varargin{i},'append')
                v_type='append';
            else
                v_log_file=varargin{i};
            end
        end
end
v_dir=F_file_parts(v_log_file,'dir');
if isempty(v_dir)
    v_dir=pwd;
end
if ~exist(v_dir,'dir')
    mkdir(v_dir);
end
% Changement du nom du fichier si il est nouveau et positionnnement de
% diary a off
if ~strcmp(F_get_file,v_log_file)
    diary(v_log_file);
    diary off;
    if strcmp('new',v_type)
        % Ecriture en-tete si le fichier n'existe pas encore
        F_log_write({F_notif_str('begin'),...
            F_notif_str('file'),F_notif_str('hline')});
    end
end


function varargout = F_get_file(varargin)
% Recuperation du nom du fichier log
v_current_log_file = get(0,'DiaryFile');
vs_fparts=F_file_parts(v_current_log_file);
% Verification si c'est bien un fichier
if isdir(v_current_log_file)
   varargout{1}='';
   return
end
% Affichage du chemin du fichier de log
% si varargin{1}~=0
if nargin
    if isnumeric(varargin{1}) && varargin{1}
        %disp(F_notif_str('fileinf'));
        F_disp(F_notif_str('fileinf'));
    elseif ischar(varargin{1}) && strcmp(varargin{1},'name')
        varargout{1}=[vs_fparts.name vs_fparts.ext];
    end
else
    % Retourne le chemin du fichier de log
    % si F_get_file sans argument
    varargout{1}=v_current_log_file;
end


function F_log_write(v_strs)
% Ecriture forcee dans le fichier log
% Si diary est actif on le suspend
v_init_on=F_get_status;
if v_init_on
    diary off;
end
% Verifications sur le fichier
% Si le nom est vide on sort
v_file_name=F_get_file;
if isempty(v_file_name)
   return 
end
if ~exist(v_file_name,'file')
   F_log('reset');
   return
end
% Ouverture du fichier
v_fid=fopen(v_file_name,'a');

% Elimination des formatages html
v_strs=F_str_html2txt(v_strs);

% Transformation d'une chaine de caracteres en un cell
if ischar(v_strs)
    v_strs={v_strs};
end
% Boucle sur les chaines de caractere a ecrire
for i=1:length(v_strs)
    fprintf(v_fid,'\n%s\n',v_strs{i});
end
% Fermeture du fichier
fclose(v_fid);
% Restauration de l'etat initial, si besoin
if v_init_on
    diary on;
end


function v_str = F_notif_str(v_key_word)
% Pour les inscriptions dans le fichier de log ou infos
% a afficher a l'ecran
global v_trace
v_key_words_list={'begin','end','on','off','file','hline','setinf','fileinf',...
    'oninf','offinf'};
v_str='';
% if nargin<2
%     v_trace=true;
% end
if ~nargin || ~ismember(v_key_word,v_key_words_list) ...
        || (~v_trace && ismember(v_key_word, {'on' 'off' 'oninf' 'offinf'}))
    return;
end

switch v_key_word
    case 'begin'
        v_str=['log file creation : ' datestr(now,'dd/mm/yyyy - HH:MM:SS')];
    case 'end'
        v_str=['log writing end: ' datestr(now,'dd/mm/yyyy - HH:MM:SS')];
    case 'on'
        v_str='<<<<<<< BEGIN TO TRACE DISPLAY OUTPUTS / KEYBOARD INPUTS >>>>>>>';
    case 'off'
        v_str='<<<<<<< END TO TRACE DISPLAY OUTPUTS / KEYBOARD INPUTS >>>>>>>';
    case 'file'
        v_str=['Name: ' F_get_file];
    case 'hline'
        v_str=repmat('-',1,90);
    case 'setinf'
        v_str=sprintf('<a href=".">Warning : </a>The log file name is not defined or has been reinitialized, \n%s',...
            ' to set it, use F_log(''set'',''nom prefixe'')');
    case 'fileinf'
        v_str=['log file : ' F_get_file];
    case 'oninf'
        v_str=sprintf('\n%s\n%s\n%s\n%s\n','<a href=".">ACTIVE TRACING</a>',...
            'Active tracing of keyboard inputs, displays,',...
            'and also user actions in interface',...
            'To cancel tracing, use : <a href="matlab:F_log(''stop'')">F_log(''stop'')</a>');
    case 'offinf'
        v_str=sprintf('\n%s\n%s\n','<a href=".">INACTIVE TRACING</a>',...
            'To activate tracing, use : <a href="matlab:F_log(''start'')">F_log(''start'')</a>');
end

function F_update_file_str(v_key_word)

switch v_key_word
    case 'begin'
        v_tag='log file creation: ';
        v_str=F_notif_str('begin');
        
    case 'file'
        v_tag='Name: ';
        v_str=F_notif_str('file');
        
    otherwise
        v_tag='';
        v_str='';
    
end
if ~isempty(v_tag)
    v_file_path=F_get_file;
    fid=fopen(v_file_path);
    vc_lines=textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    vc_lines=vc_lines{1};
    v_index=strmatch(v_tag,vc_lines);
    if ~isempty(v_index)
        vc_lines{v_index}=v_str;
        % Ecriture du fichier
        fid=fopen(v_file_path,'w');
        fprintf(fid,'%s\n',vc_lines{:});
        fclose(fid);
    end
end



function vc_txt_str=F_str_html2txt(vc_html_str)
% Elimination des balises html si bien formees
% cad <nom>texte...</nom>
if ischar(vc_html_str)
    vc_html_str={vc_html_str};
end
% nb str
v_nb_str=length(vc_html_str);

vc_txt_str=cell(v_nb_str,1);%     
% boucle sur le cell
for i=1:v_nb_str
    vc_txt_str{i}=regexprep(vc_html_str{i},'<[a|/a][^>]+>','');
end
% renvoi chaine de caractere si une seule chaine dans le cell
if v_nb_str==1
    vc_txt_str=vc_txt_str{1};
end

function F_html2txt(v_file_path)
if ~exist(v_file_path,'file')
    return
end
try
    fid=fopen(v_file_path);
    % Buffer overflow (due to line length): returns an error ?? buggy, see texscan help.
    vc_lines=textscan(fid,'%s','Delimiter','\n','ReturnOnError',1);
    fclose(fid);
catch scanError
   vc_lines{1}{1}={scanError.message};
end
vc_txt_lines=F_str_html2txt(vc_lines{1});
% Ecriture du fichier
fid=fopen(v_file_path,'w');
fprintf(fid,'%s\n',vc_txt_lines{:});
fclose(fid);
