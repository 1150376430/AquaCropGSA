function varargout=F_gen_xml_conf(v_csv_file_or_case_name,varargin)
%F_GEN_XML_CONF  Production fichier xml de config a partir infos fichier(s)
% csv
%   [vs_xml_struct]=F_gen_xml_conf(v_csv_file_or_case_name[,v_sub_case_name,
%                   v_xml_file_name,vs_options])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      
%      - v_csv_file_or_case_name: nom d'un fichier csv contenant la
%      description d'une structure xml, ou nom d'un cas d'utilisation
%      correspondant a un ou la combinaison de plusieurs fichiers csv.
%
%      par ex.: optimisation_simplex
%       Si on ne fourni que optimisation comme nom du cas, cela fonctionne
%       on demande juste de preciser interactivement un choix sur la methode 
%       dans le programme. Sinon on peut fournir simplex en tant
%       qu'argument supplementaire.
%
%    Optionnels:
%      - v_sub_case_name : cas specifique d'utilisation associe a une
%      methode par ex. (simplex, pour l'optimisation)
%
%      - v_xml_file_name: nom du fichier xml e produire
%        si non fourni : [NomCasUtilisation]_conf.xml
%
%      - vs_options: structure avec les champs
%              .out : 'mslib' (fichier utilisable par les fonctions
%              MulsiSimLib, defaut), 'doc' (fichier avec tous les attributs de
%              documentation sur les champs)
%
%              .type: 'file' pour produire un fichier complet (defaut),
%              'bloc' pour produire un fichier avec un bloc xml
%
%              .xsl_style : true insertion d'un lien specif. vers le
%              fichier xsl dans le fichier xml, sinon false (defaut)indique
%              qu'une transformation du fichier xml doit etre operee avec
%              le fichier xsl specifie.
%
%              .documented : avec 3 niveaux (valeurs) possibles
%               0 : aucun commentaire d'aide insere
%               1 : commentaire pour signification de chaque champ/balise
%               2 (defaut) : en + commentaire d'aide sur les valeurs possibles
%                  ou la consigne de remplissage et la valeur par defaut
%                  si elle a ete definie
%    
%              .open: true [defaut] ou false, pour lancer l'ouverture
%              ou non du fichier dans l'editeur matlab
%  
%   SORTIE(S):
%      
%      - optionnelles :
%      # cas 1: pas de specification d'argument en entree
%        * si pas d'argument de sortie : affichage de la liste des noms des
%        cas d'utilisation
%        * si argument(s) de sortie demande(s) : 
%          arg 1 : contient la structure complete
%        contenant les informations associees aux cas d'utilisation)
%          arg 2 : contient la structure d'options par defaut
%
%      # cas 2 : specification d'argument(s) en entree
%      * production du fichier xml, avec transfo eventuelle via un fichier xsl si il
%      existe ('conf_mslib.xsl') ou insertion d'un lien pour mise en forme 
%      dans navigateur internet en tant que doc (utilisation 'conf_doc.xsl') 
%      * arguments de sortie si demandes : 
%          - arg 1 : structure complete xml (avec les champs ATTRIBUTE, CONTENT)
%          - arg 2 : structure semblable a la structure de configuration classique
%          - Le fichier xml n'est pas produit
%  
%   CONTENU:
%  
%   APPEL(S): liste des fonctions appelees
%      - sous-fonction F_get_use_cases, F_xml2conf_struct
%      - F_gen_xml_struct, F_gen_xml_file
%  
%   EXEMPLE(S):
%      - F_gen_xml_conf('fichier.csv','fichier.xml')
%      - F_gen_xml_conf('standard','fichier.xml')
%      - vs_xml_struct=F_gen_xml_conf('standard')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 26-Jul-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-17 14:34:16 +0200 (ven., 17 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 893 $
%  
%  
% See also F_gen_xml_struct, F_gen_xml_file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisations
vs_xml_struct=struct;
% Options par defaut
%   champ out : contient un mot cle pour le type de fichier xml a produire
%   valeurs: 'mslib' (par defaut) pour produire le fichier au format utilisable par
%   mslib,'doc' pour produire le fichier avec tous les attributs de doc.
%
vs_default_options.out='mslib'; % format utilisable par l'application
vs_default_options.documented=2; % niveau de commentaires maximum dans le fichier xml
vs_default_options.open=true; % ouverture du fichier produit dans l'editeur
%
% champ xsl_style : activation par insertion d'un lien dans le fichier xml (true)ou pas 
% (false) vers une feuille de style xsl
% par defaut
vs_default_options.xsl_style=false;
% Activation ou non de la transformation du fichier xml en xml ou html,
% via le xsl
vs_default_options.xsl_trans=false;
% Activation de la transformation ou non du fichier xml en html
vs_default_options.html=false;
%
%  type : format du fichier complet ou partiel 
% 'file' : fichier complet
% 'bloc' : production d'une partie du fichier de config
vs_default_options.type='file';
v_begin_index=1;
%
% rootname :  nom racine document
vs_default_options.rootname=('ConfigFile');


% Recuperation d'informations sur les cas d'utilisation disponibles
if ~nargin
    vs_use_cases=F_get_use_cases;
    if nargout
        varargout{1}=vs_use_cases;
        if nargout>1
            varargout{2}=vs_default_options;
        end
    else
        F_disp('Arguments insuffisants')
        F_disp('Nom nom du cas d''utilisation ou du fichier csv attendu !')
        F_disp(' ')
        vc_use_case_names=fieldnames(vs_use_cases);
        F_disp('Liste des mots cles correspondant aux cas d''utilisation disponibles:')
        vc_out_names=cellfun(@(x) F_str_split(x,'_'),vc_use_case_names,'UniformOutput',false);
        vc_out_names=unique(cellfun(@(x) x{1},vc_out_names,'UniformOutput',false));
        F_disp(sprintf('%s\n',vc_out_names{:}));
    end
    return
end

% Gestion des args optionnels en entree
if nargin>1
    for narg=1:length(varargin)
        if isstruct(varargin{narg})
            vs_options=varargin{narg};
        elseif ischar(varargin{narg})
            v_ext=F_file_parts(varargin{narg},'ext');
            if strcmp(v_ext,'.xml')
                v_xml_file_name=varargin{narg};
            elseif isempty(v_ext)
                v_sub_case_name=varargin{narg};
            else
                disp('Erreur sur l''extension du nom du fichier xml');
                return
            end
        end
    end
else
    % poser question pour choix case ????
    % Pour l'instant ne peut pas fonctionner.
    % Si oui : il faut invalider le section plus haut dans le if ~nargin et
    % ~nargout
    if ~exist('v_csv_file_or_case','var')
        
    end
end


% Gestion des arguments d'entree / production des options
if ~exist('vs_options','var')
    vs_options=vs_default_options;
else
    % Gestion de l'argument de gestion du contenu du fichier avec ou sans doc
    % (mslib)
    vc_fnames=fieldnames(vs_default_options);
    for i=1:length(vc_fnames)
        if ~isfield(vs_options,vc_fnames{i})
            vs_options.(vc_fnames{i})=vs_default_options.(vc_fnames{i});
        end
    end
end


% Gestion cas specifique utilisation
% si le cas est different de custom = utilisation d'un fichier
% Precision en argument supple v_sub_case_name
if exist('v_sub_case_name','var')
    %v_csv_file_or_case_name=[v_csv_file_or_case_name '_' v_sub_case_name];
    [vs_use_cases,v_case]=F_get_use_cases(v_csv_file_or_case_name,v_sub_case_name);    
else
    [vs_use_cases,v_case]=F_get_use_cases(v_csv_file_or_case_name);
end

% Gestion du cas unknown
if strcmp('unknown',v_case)
    F_disp(['Cas d''utilisation inconnu : ' v_csv_file_or_case_name])
    F_disp('Liste des mots cles correspondant aux cas d''utilisation disponibles:')
    vc_use_case_names=setdiff(fieldnames(vs_use_cases),'unknown'); 
    vc_out_names=cellfun(@(x) F_str_split(x,'_'),vc_use_case_names,'UniformOutput',false);
    vc_out_names=unique(cellfun(@(x) x{1},vc_out_names,'UniformOutput',false));
    F_disp(sprintf('%s\n',vc_out_names{:}));
    return
end


% Verification et renseignement interactif, si besoin pour certains modes
if strcmp('partial',v_case)
    if ~nargout
        vc_sub_names=vs_use_cases.partial.matching_sub_cases;
        % poser la question :
        v_sub_case_name=F_user_input(['Precisez votre choix pour ''' v_csv_file_or_case_name ''' ?'],vc_sub_names,vc_sub_names);
        %v_case={1};
        v_csv_file_or_case_name=vs_use_cases.partial.case;
        % update des infos
        [vs_use_cases,v_case]=F_get_use_cases(v_csv_file_or_case_name,v_sub_case_name);
    else
        v_message=['Preciser la methode dans les arguments parmi : ' sprintf('%s ',vs_use_cases.partial.matching_sub_cases{:}) ];
        F_create_message('Erreur sur le cas d''utilisation',v_message,1,1)
    end
end


% Recup infos sur le use case choisi
if ischar(v_case)
    v_case={v_case};
end
eval(['vs_cur_use_case=vs_use_cases' sprintf('.%s',v_case{:}) ';']);


if ~nargout
    % Gestion du nom de fichier de sortie
    if ~exist('v_xml_file_name','var')
        if ~exist('v_sub_case_name','var')
            v_suffix='';
        else
            v_suffix=['_' v_sub_case_name];
        end
        vs_fparts=F_file_parts(v_csv_file_or_case_name);
        v_xml_file_name=fullfile(vs_fparts.dir,[vs_fparts.name v_suffix '_conf.xml']);
    end

    % Traitement de la coherence des options
    % Si le format 'mslib' est demande, xsl_style == false
    if strcmp(vs_options.out,'mslib')
        vs_options.xsl_style=false;
        vs_options.xsl_trans=true;
    end
    if strcmp(vs_options.out,'doc')
        vs_options.xsl_style=true;
        if vs_options.html
            vs_options.xsl_trans=true;
        else
            vs_options.xsl_trans=false;
        end
    end

    % Si on produit une partie seulement specifique du use case
    if ~strcmp(vs_options.type,'file')
        v_begin_index=2;
    end
end


%
% Boucle sur la liste des fichiers de la structure
% et insertion si besoin de champs de structures plus specifiques
v_added_specif_struct=-1;
v_nb_files=length(vs_cur_use_case.file);
for i=v_begin_index:v_nb_files
    v_added_specif_struct=v_added_specif_struct+1;
    vs_tmp_struct=F_gen_xml_struct(vs_cur_use_case.file{i}.name);
    if i==v_begin_index
        vs_xml_struct=vs_tmp_struct;
    end
    % Ajouts et suppressions a faire dans la structure vs_xml_struct 
    % Avec verification des champs attendus
    vs_tmp_struct_paths=F_xml_struct_browser(vs_tmp_struct,'',1);
    
    % Au prealable: sur les champs non actifs
    % Verification des liens hierarchiques : si des champs declares non
    % actifs ont des descendants, alors les descendants sont
    % positionnes a non actifs
    % on demarre a 2 car 1er elt = racine
    for p=2:length(vs_tmp_struct_paths)
        vv_current_childs_idx=vs_tmp_struct_paths(p).childs_idx;
        if  ~isempty(vv_current_childs_idx) && ~vs_tmp_struct_paths(p).active
            for c=vv_current_childs_idx
               if vs_tmp_struct_paths(c).active
                    eval(['vs_tmp_struct' vs_tmp_struct_paths(c).path '.ATTRIBUTE.Active=''0'';']);
               end
            end
        end
    end
        
    % Recuperation des elements actifs...
    vv_active_paths=logical([vs_tmp_struct_paths.active]);
    % calcul des chemins a controler (pour ajout/supression)
    vc_new_paths={vs_tmp_struct_paths.path};
    
    % Si on recupere la structure en arg de sortie 
    % on garde tout, meme les champs non actifs (pour validations)
    if ~nargout % sinon, on les supprime pour la prod. du fichier xml
        % Dans ce cas on veut produire le fichier avec lec champs actifs
        % seulement
        % Suppression des chemins inutiles (champs non actifs)
        vc_del_paths=vc_new_paths(~vv_active_paths);
        if ~isempty(vc_del_paths)
            for j=1:length(vc_del_paths)
                try
                    vc_fnames=F_str_split(vc_del_paths{j},'.');
                    eval(['vs_xml_struct' sprintf('.%s',vc_fnames{1:end-1}) '=rmfield(vs_xml_struct'...
                        sprintf('.%s',vc_fnames{1:end-1}) ',''' vc_fnames{end} ''');']);
                catch
                end
            end
        end
    end
    % Ajout d'une nouvelle structure a la structure existante
    if v_added_specif_struct>0
        vc_paths_filter_list={};
        % Parcours des chemins
        for j=1:length(vc_new_paths)
            v_cur_field_link=vc_new_paths{j};
            % xtraction des noms de champs et test existence dernier
            vc_fnames=F_str_split(v_cur_field_link,'.');
            if ismember(v_cur_field_link,vc_paths_filter_list) || isempty(v_cur_field_link)  ...
                    || length(vc_fnames)==1
                if length(vc_fnames)==1 && eval(['~isfield(vs_xml_struct,''' vc_fnames{end} ''');'])
                    eval(['vs_xml_struct' v_cur_field_link '=vs_tmp_struct' v_cur_field_link ';']);
                end
                continue
            end
            if eval(['isfield(vs_xml_struct' sprintf('.%s',vc_fnames{1:end-1}) ',''' vc_fnames{end} ''');'])
                % Le champ existe dans vs_xml_struct : on elimine CONTENT si il existe,
                % on conserve les autres champs preexistants. Elimination
                % du champ CONTENT si remplissage avec sous-champs venant 
                % de vs_tmp_struct en plus de CONTENT et ATTRIBUTE.
                %
                % Liste des sous-champs
                vc_tmp_fnames=fieldnames(eval([ 'vs_tmp_struct' v_cur_field_link ]));
                v_add_fields=~isempty(setdiff(vc_tmp_fnames,{'CONTENT' 'ATTRIBUTE'}));
                % Suppression CONTENT si des sous-champs doivent etre
                % ajoutes
                if eval(['isfield(vs_xml_struct' v_cur_field_link ',''CONTENT'');']) && v_add_fields
                    eval(['vs_xml_struct' v_cur_field_link '=rmfield(vs_xml_struct' v_cur_field_link ',''CONTENT'');']);
                end
                for k=1:length(vc_tmp_fnames)
                    if  strcmp(vc_tmp_fnames{k},'ATTRIBUTE')
                        vc_attr_fnames=fieldnames(eval([ 'vs_tmp_struct' v_cur_field_link '.ATTRIBUTE']));
                        for l=1:length(vc_attr_fnames)
                            if eval(['~isempty(vs_tmp_struct' v_cur_field_link '.ATTRIBUTE.' vc_attr_fnames{l} ')'])
                                % Ajout d'un filtre sur les noms des attributs vc_attr_fnames{l}:
                                % si les noms des attributs sont dans la
                                % liste: {'Active' 'Required' 'Insert'}
                                % on affecte la nouvelle valeur que si
                                % =='1'
                                v_replace=true;
                                v_new_value=eval(['vs_tmp_struct' v_cur_field_link '.ATTRIBUTE.' vc_attr_fnames{l} ';']);
                                if ismember(vc_attr_fnames{l},{'Active' 'Required' 'Insert'}) && ~strcmp(v_new_value,'1')
                                    v_replace=false;
                                end
                                if v_replace
                                    eval(['vs_xml_struct' v_cur_field_link '.ATTRIBUTE.' vc_attr_fnames{l} '=v_new_value;']);
                                end
                            end
                        end
%                     else
%                         if eval(['~isempty(vs_tmp_struct' v_cur_field_link '.'  vc_tmp_fnames{k} ')'])
%                             eval(['vs_xml_struct' v_cur_field_link '.' vc_tmp_fnames{k} '= vs_tmp_struct' ...
%                                 v_cur_field_link '.' vc_tmp_fnames{k} ';']);
%                         end
                    end
                end
            else % le champ n'existe pas, on l'ajoute a la structure
                eval(['vs_xml_struct' v_cur_field_link '=vs_tmp_struct' v_cur_field_link ';']);
                % Si ce champ comporte des sous-champs, on les ajoute
                % a la liste filtre: vc_paths_filter_list
                eval(['vs_childs=F_xml_struct_browser(vs_tmp_struct' v_cur_field_link ','''',1);'])
                if length(vs_childs)>1
                    vc_childs_paths=cellfun(@(x) {[v_cur_field_link x]},{vs_childs(2:end).path});
                    vc_paths_filter_list={vc_paths_filter_list{:} vc_childs_paths{:}};
                end
            end
        end
    end
end

% Ajout d'un attribut pour conserver le nom du use case dans
    % le fichier xml (pour information)
    vs_xml_struct.ATTRIBUTE.use_case=sprintf('%s ',v_case{:});
    % Ajout attribut Insert aussi pour l'element racine
    vs_xml_struct.ATTRIBUTE.Insert=1;
    % On fixe le niveau de commentaires dans le fichier xml
    vs_xml_struct.ATTRIBUTE.documented=vs_options.documented;

if ~nargout % Pas d'arg. de sortie, on produit le fichier (xml, ou html)
    % On parcours la structure pour remplacer la valeur par defaut
    % renseigner avec EMPTY par une chaine vide
    %
    % Generation du fichier xml (avec transfo eventuelle)
    if exist('v_xml_file_name','var')
        xmlFile=F_gen_xml_file(vs_xml_struct,v_xml_file_name,['conf_' vs_options.out '.xsl'],...
            vs_options.type,vs_options.rootname,...
            vs_options.xsl_style,vs_options.xsl_trans,vs_options.html);
    end
    if all([xmlFile.exist vs_options.open ~vs_options.html])
        % Ouverture du fichier dans l'editeur
        open(xmlFile.getPath);
    end
else % 1 ou 2 args. de sortie on produit la structure xml complete, la structure xml de configuration
    % Affectation des arguments optionnels de sortie
    % sans produire le fichier xml
    if nargout >  0
        % varargout{1}=configDocument(vs_xml_struct).toStruct('full');
        varargout{1}=vs_xml_struct;
    end
    if nargout >  1
        varargout{2}=configDocument(vs_xml_struct).toStruct('basic');
    end
end


function [vs_use_cases,vc_out_case_name]=F_get_use_cases(v_csv_or_case,v_sub_case)
% 
% Extraction des informations sur les fichiers csv descriptifs des cas
% d'utilisation et leurs dependances.
%
% Arguments:
%    Entree:
%      v_csv_or_case : nom d'un fichier csv ou nom d'un cas d'utilisation parmi
%      vc_use_case_names
%      v_sub_case : nom du cas specifique pour un cas d'utilisation
%
%    Sortie:
%      vs_use_cases : Structure desriptive d'un ou de tous les cas d'utilisation
%      vc_out_case_name : nom du cas choisi ou 'all' pour tous, ou 'custom'
%      quand un nom de fichier est fourni en entree
% 
% Liste des cas d'utilisation
% Chargement de la description des informations de l'ensemble des use cases
%
try
    vs_use_cases=configDocument('configuration_use_cases_description.xml').toStruct('basic');
catch
    F_create_message('Certains fichiers necessaires ne sont pas accesssibles!',...
        'Executer a nouveau F_startup, F_set_path',1,1);
end

% Liste des mots cle des cas d'utilisation
vc_use_case_names=fieldnames(vs_use_cases);

% Sans argument on recupere tous les cas
if ~nargin
    v_csv_or_case='all';
end
if nargin<2
   v_sub_case='';
end

switch v_csv_or_case
    % invalide pour l'instant pas interet
    case 'all' % pour structure avec tous les cas
        vc_out_case_name='all';
        %vc_out_names=vc_use_case_names;
    case vc_use_case_names % pour structure avec le cas specifie
        if isfield(vs_use_cases.(v_csv_or_case),'file')
            vc_out_case_name=v_csv_or_case;
            %vc_out_names={v_csv_or_case};
        else
            vc_sub_cases=fieldnames(vs_use_cases.(v_csv_or_case));
            if ismember(v_sub_case,vc_sub_cases)
                vc_out_case_name={v_csv_or_case v_sub_case};
            else
                vc_out_case_name='partial';
                vs_use_cases.(vc_out_case_name).matching_sub_cases=fieldnames(vs_use_cases.(v_csv_or_case));
                vs_use_cases.(vc_out_case_name).case=v_csv_or_case;
            end
        end
    otherwise % pour structure pour le fichier specifie
        v_ext=F_file_parts(v_csv_or_case,'ext');
        if ~isempty(v_ext) && strcmp('.csv',v_ext)
            vc_out_case_name='custom';
            vs_use_cases.(vc_out_case_name).file{1}.name=v_csv_or_case;
        else
            vc_out_case_name='unknown';
            vs_use_cases.(vc_out_case_name).file{1}.name='';
        end
        vs_use_cases.(vc_out_case_name).file{1}.link='';    
        return
end
