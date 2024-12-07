function [v_status, v_nb_err,vs_conf_valid] = F_validate_conf(vs_conf,v_mode_name,varargin)
%F_VALIDATE_CONF Validation du contenu d'une structure de configuration
%   [v_status, v_nb_err,vs_conf_valid] =
%   F_validate_conf(vs_conf,v_mode_name[ ,v_sub_case])
%
%   ENTREE(S): descriptif des arguments d'entree
%      - vs_conf : structure de configuration (produite par xml_load par
%        lecture d'un fichier xml de configuration)
%      - v_mode_name : nom du cas d'utilisation
%      La liste des cas d'utilisation est affichee lors d'un appel sans
%      argument a la fonction
%      Optionnel:
%      - v_sub_case : cas specifique d'utilisation associe a une
%      methode par ex. (simplex, pour l'optimisation)
%
%      Liste des mots cles correspondant aux cas d'utilisation disponibles:
%      evaluation
%      optimisation
%      incertitude
%      sensibilite
%      standard
%
%
%   SORTIE(S):
%      - v_status : validite du contenu de vs_conf par rapport a ce qui est
%        attendu pour le cas d'utilisation choisi
%        logical true (valide) ou false (non valide)
%      - v_nb_err : nombre d'erreurs detectees (elements manquants
%      necessaires dans vs_conf)
%      - vs_conf_valid : structure vs_conf valide (modifiee si besoin,
%        par ex. ajout d'elements optionnels non presents mais utile
%        dans le deroulement du programme specifique d'un cas d'utilisation
%        ou non)
%
%
%   CONTENU: descriptif de la fonction
%   Confrontation du contenu d'une structure de configuration avec ce qui est
%   attendu pour un cas d'utilisation, creation de champs et affectation de
%   valeurs par defaut si besoin.
%
%   APPEL(S): liste des fonctions appelees
%      - F_gen_xml_conf
%      - F_xml_struct_browser
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      -
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 04-Nov-2010
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-07 14:09:28 +0200 (ven., 07 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 911 $
%
%
% See also F_gen_xml_conf, F_xml_struct_browser, F_strings_rep,F_deblank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F_disp('--------------------------------------------------------------------------');
F_disp(' Debut de la verification du fichier de configuration XML ...............');
F_disp('--------------------------------------------------------------------------');
F_disp(' ')

% Chargement de la variable globale v_dev
% pour le mode developpement
global v_dev
v_loc_dev=false;
if ~isempty(v_dev)
    v_loc_dev=v_dev;
end
% Affichage des modes possibles (i.e. cas d'utilisation)
if ~nargin
    [vv_ex,vs_modes]=F_mslib_modes;
    F_disp('Liste des modes disponibles :');
    vc_activ_modes=vs_modes.Labels(find(vs_modes.Activ));
    F_disp(sprintf('\n%s',vc_activ_modes{:}));
    return
end
v_sub_case='';
if nargin>2 && ischar(varargin{1})
    v_sub_case=varargin{1};
end

% Chargement de la structure xml de reference
% pour le mode choisi
vs_xml_struct=F_gen_xml_conf(v_mode_name,F_deblank(v_sub_case));
%
% Parcours et extraction des infos pour la validation dans la structure xml
vs_ref_struct = F_xml_struct_browser(vs_xml_struct);
v_stop=false;
% Compteur du nombre d'erreurs
v_nb_err=0;
%
% Traitement de la verification des champs attendus (optionnels ou
% obligatoires) . Les champs supplementaires presents dans vs_conf
% sont ignores. Les champs non actifs sont supprimes.
%
% Liste filtre des chemins a ne pas verifier
vc_filter={};
% On commence a l'indice v_elt_idx=2 car 1
% correspond a l'element racine de la structure
for v_elt_idx=2:length(vs_ref_struct)
    % Initialisation de statut de presence
    vs_ref_struct(v_elt_idx).exist=false;
    %
    % Traitement du filtrage des chemins a ne pas traiter
    if ismember(vs_ref_struct(v_elt_idx).path,vc_filter)
        continue
    end
    % Chemin du champ a traiter
    v_fields_path=['vs_conf' vs_ref_struct(v_elt_idx).path];
    % Extraction du champ et des sous-champs tels qu'ils existent dans la
    % structure vs_conf (Reecriture des differents champs en fonction du
    % nombre d'elements dans les cell)
    vc_fields2eval=F_get_fields2eval(v_fields_path);
    for i_field=1:length(vc_fields2eval)
        try
            % Chemin du champ a traiter
            eval([vc_fields2eval{i_field} ';']);
            %
            % Pas d'erreur d'evaluation: mise a jour du statut d'existence du chemin
            vs_ref_struct(v_elt_idx).exist=true;
            %
            v_required_str='CHAMP OBLIGATOIRE';
            %
            % Traitement si c'est un champ optionnel present
            v_empty=eval(['isempty(' vc_fields2eval{i_field} ')' ]);
            
            if ~vs_ref_struct(v_elt_idx).required
                v_required_str='CHAMP OPTIONNEL PRESENT';
                % Si il n'y a rien dans le champ courant et
                % que theoriquement le contenu est un cell
                % (signifie par item dans la structure de reference) :
                % initialiser avec  {}
                % Si descendant item, il est forcement seul
                if length(vs_ref_struct(v_elt_idx).childs_idx)==1
                    % calcul si descendant est == item (cad en fin de
                    % chaine, dans ce qui est en plus dans le path enfant)
                    v_item_found=strfind(vs_ref_struct(vs_ref_struct(v_elt_idx).childs_idx).path(length(vs_ref_struct(v_elt_idx).path)+1:end),...
                        'item');
                    if ~isempty(v_item_found) && v_empty
                        vs_ref_struct(vs_ref_struct(v_elt_idx).childs_idx).exist=false;
                        eval([vc_fields2eval{i_field} '={};']);
                    else
                        vs_ref_struct(vs_ref_struct(v_elt_idx).childs_idx).exist=true;
                    end
                end
                % Coherence type et contenu
                v_class=eval(['class(' vc_fields2eval{i_field} ')' ]);
                if ~strcmp(v_class,vs_ref_struct(v_elt_idx).type)
                    % disp([ vs_ref_struct(v_elt_idx).path ': type ' v_class ',, type attendu :'  vs_ref_struct(v_elt_idx).type]);
                    switch vs_ref_struct(v_elt_idx).type
                        case 'struct'
                            eval([vc_fields2eval{i_field} '=struct;']);
                        case 'cell'
                            eval([vc_fields2eval{i_field} '={};']);
                        case 'char'
                            eval([vc_fields2eval{i_field} '='''';']);
                        otherwise
                    end
                    % Si theoriquement descendants, existance == false
                    if ~isempty(vs_ref_struct(v_elt_idx).childs_idx)
                        vs_ref_struct(vs_ref_struct(v_elt_idx).childs_idx).exist=false;
                    end
                end
            end
            if v_loc_dev
                F_disp(['WARNING - ' v_required_str ' - EVALUATION OK : ' vc_fields2eval{i_field} ]);
            end
            % Traitement si c'est un champ non actif: suppression
            if ~vs_ref_struct(v_elt_idx).active
                F_disp(['WARNING - SUPPRESSION DU CHAMP NON ACTIF : ' vc_fields2eval{i_field} ]);
                % Si on n'est pas en mode developpement : on supprime le champ
                if ~v_loc_dev
                    v_fpath=vc_fields2eval{i_field};
                    vv_fsep=strfind(v_fpath,'.');
                    
                    eval([ v_fpath(1:vv_fsep(end)-1) '=rmfield('...
                        v_fpath(1:vv_fsep(end)-1) ',''' v_fpath(vv_fsep(end)+1:end) ''');']);
                end
            end
            % Verification des valeurs contenues dans le champ si il ne
            % contient pas de sous-champ  et est actif
            if isempty(vs_ref_struct(v_elt_idx).childs_idx) && vs_ref_struct(v_elt_idx).active
                % Si le champ est vide: on affecte une valeur par defaut
                if eval(['isempty(' vc_fields2eval{i_field} ')' ])
                    % Pas de valeur par defaut pouvant etre fixee, mais valeur attendue
                    % non vide pour les champs obligatoires
                    %
                    % valeur par defaut
                    v_default_value=vs_ref_struct(v_elt_idx).value;
                    % Si la valeur par defaut est codifiee
                    % par le mot cle EMPTY, on le remplace par une
                    % chaine vide.
                    if ischar(v_default_value) && strcmp('EMPTY',v_default_value)
                        v_default_value='';
                    end
                    % Affectation de la valeur par defaut
                    if  F_is_required(vs_ref_struct,v_elt_idx)
                        if isempty(vs_ref_struct(v_elt_idx).value)
                            v_stop=true;
                            v_nb_err=v_nb_err+1;
                            F_disp([num2str(v_nb_err)   ') ERREUR - RENSEIGNER LA VALEUR (PAS DE VALEUR PAR DEFAUT DISPONIBLE) : '...
                                vs_ref_struct(v_elt_idx).nodename]);
                            %
                            % Mise en forme de la partie manquante dans le xml
                            % file
                            F_struct2xml_format(vc_fields2eval{i_field},vs_conf);
                        else
                            eval([ vc_fields2eval{i_field} '=v_default_value;']);
                        end
                    else
                        eval([ vc_fields2eval{i_field} '=v_default_value;']);
                    end
                end
            end
            % Verification de la coherence du type de la valeur presente dans le champ
            % si l'element est un champ simple ou si au moins un des enfants est requis !!!
            v_content_type=eval(['class(' vc_fields2eval{i_field} ')' ]);
            if ~strcmp(v_content_type,vs_ref_struct(v_elt_idx).type) && ...
                    ( isempty(vs_ref_struct(v_elt_idx).childs_idx)  || ...
                    any(F_is_required(vs_ref_struct,vs_ref_struct(v_elt_idx).childs_idx)))
                v_stop=true;
                v_nb_err=v_nb_err+1;
                F_disp([num2str(v_nb_err)   ') ERREUR - TYPE DU CONTENU DE : ' vs_ref_struct(v_elt_idx).nodename ]);
                %
                % Mise en forme de la partie manquante dans le xml
                % file, recuperation de l'espace de tabulation
                v_tab=F_struct2xml_format(vc_fields2eval{i_field},vs_conf);
                F_disp([ v_tab '  -> Type attendu: ' F_get_type_desc(vs_ref_struct(v_elt_idx).type)])
                F_disp([ v_tab '  -> Type fourni: ' F_get_type_desc(v_content_type) ]);
                % extraction des noms des sous-champs
                try
                    v_fields=eval(['fieldnames(' vc_fields2eval{i_field} ');']);
                catch
                    v_fields={};
                end
                if ~isempty(v_fields)
                    F_disp([v_tab '    -> contenu de ' vs_ref_struct(v_elt_idx).nodename ': ']);
                    F_disp(sprintf([v_tab '       <%s>\n'],v_fields{:}));
                end
                F_disp(' ')
            end
        catch ErrorStruct
            % Mise a jour du statut d'existence du chemin
            vs_ref_struct(v_elt_idx).exist=false;
            % Statut actif et requis
            switch vs_ref_struct(v_elt_idx).active && vs_ref_struct(v_elt_idx).required
                case true % le champ est actif et requis, a son niveau
                    % F_is_required : Recherche en remontant dans l'ascendance si tous les niveaux
                    % successifs sont requis, et ou presents. Si on atteint le 1er
                    % niveau (racine de l'arboresecence) = generation
                    % d'une erreur
                    if F_is_required(vs_ref_struct,v_elt_idx)
                        v_stop=true;
                        v_nb_err=v_nb_err+1;
                        F_disp([num2str(v_nb_err)  ') ERREUR - CHAMP OBLIGATOIRE NON PRESENT : ' vs_ref_struct(v_elt_idx).nodename])
                        % Mise en forme de la partie manquante dans le xml
                        % file
                        F_struct2xml_format(vc_fields2eval{i_field},vs_conf);
                        
                    end
                case false % le champ est actif ou requis
                    % Si l'elt a des descendants et qu'il n'est pas
                    % actif on l'ajoute au filtre de chemin ainsi que les
                    % chemins de ses descendants (forcement aussi non actifs)
                    if ~vs_ref_struct(v_elt_idx).active % on continue
                        if ~isempty(vs_ref_struct(v_elt_idx).childs_idx)
                            vc_childs_path=arrayfun(@(x) {vs_ref_struct(x).path},vs_ref_struct(v_elt_idx).childs_idx);
                            vc_filter={vc_filter{:} vs_ref_struct(v_elt_idx).path ...
                                vc_childs_path{:}};
                        end
                        continue
                    end
                    
                    % Le champ est actif et optionnel
                    %
                    if v_loc_dev
                        F_disp(['ATTENTION - CREATION CHAMP OPTIONNEL : ' vc_fields2eval{i_field} ]);
                    end
                    %
                    % Si la variable n'est pas une structure ou le champ n'existe
                    % pas !
                    if (strcmp(ErrorStruct.identifier,'MATLAB:nonExistentField')) || ...
                            (strcmp(ErrorStruct.identifier,'MATLAB:nonStrucReference'))
                        % Creation du champ optionnel simple et affectation de la valeur
                        % par defaut
                        if isempty(vs_ref_struct(v_elt_idx).childs_idx)
                            % POUR ETRE CORRECT IL FAUDRAIT VERIFIER
                            % QUE L UN DES FRERES AU MOINS EST PRESENT
                            % POUR COMPLETER ???
                            if isempty(vs_ref_struct(v_elt_idx).value) && F_is_required(vs_ref_struct,v_elt_idx)
                                F_disp(['ATTENTION - RENSEIGNER LA VALEUR (PAS DE VALEUR PAR DEFAUT DISPONIBLE) : '...
                                    vs_ref_struct(v_elt_idx).nodename ]);
                                % Mise en forme de la partie manquante dans le xml
                                % file pour affichage !
                                F_struct2xml_format(vc_fields2eval{i_field},vs_conf);
                            else
                                v_default_value=vs_ref_struct(v_elt_idx).value;
                                % Si la valeur par defaut est codifiee
                                % par le mot cle EMPTY, on le remplace par une
                                % chaine vide.
                                insert=true;
                                if ischar(v_default_value)
                                    if strcmp('EMPTY',v_default_value)
                                        v_default_value='';
                                    elseif isempty(v_default_value)
                                        insert=false;
                                    end
                                end
                                if insert
                                    eval([ vc_fields2eval{i_field} '=v_default_value;']);
                                end
                            end
                        else % champ ayant un ou des descendants ou arborescent...
                            % initialisation avec la structure de la
                            % descendance
                            vs_desc_struct=F_get_descendant_struct(vs_ref_struct,v_elt_idx);
                            eval([ vc_fields2eval{i_field} '=vs_desc_struct;']);
                        end
                        % end
                    elseif (strcmp(ErrorStruct.identifier,'MATLAB:cellRefFromNonCell')  || ...
                            strcmp(ErrorStruct.identifier,'MATLAB:badsubscript'))
                        
                        % si la variable est un cell avec un indice errone (car vide), ou n'est pas un cell
                        vv_found=strfind(vc_fields2eval{i_field},'{1}');
                        v_str2eval=vc_fields2eval{i_field};
                        % extraction de la descendance : A VOIR ????
                        % vs_desc_struct=F_get_descendant_struct(vs_ref_struct,v_elt_idx);
                        % eval([ v_str2eval(1:vv_found(end)-1) '={vs_desc_struct}']);
                        if strcmp(vs_ref_struct(v_elt_idx).nodename,'item') && isempty(eval(v_str2eval(1:vv_found(end)-1)))
                            eval([v_str2eval(1:vv_found(end)-1) '={};']);
                        end
                    else
                        % Une autre erreur que l'absence du champ ou sur un cell s'est produite
                        F_create_message(vc_fields2eval{i_field},'Erreur lors du traitement du champ',1,1,ErrorStruct);
                    end
            end
        end
    end
end

% Traitement des champs qui sont dans vs_conf et pas dans la structure de
% ref
vs_conf_struct = F_xml_struct_browser(vs_conf);
% Structure temporaire pour le calcul des indices des elements contenant
% des cell pour comparaison avec la structure de reference
vs_tmp_struct=vs_conf_struct;
% Remplacement des {..} par .item
for i=1:length(vs_tmp_struct)
    vs_tmp_struct(i).path=regexprep(vs_tmp_struct(i).path,'{([0-9]+)}','.item');
end
% Liste des champs a eliminer
vc_diff_fields_paths={vs_conf_struct(~ismember({vs_tmp_struct.path}, {vs_ref_struct.path})).path};

% Affichage des champs inutiles...
if ~isempty(vc_diff_fields_paths)
    for idiff=1:length(vc_diff_fields_paths)
        vc_fnames=F_str_split(vc_diff_fields_paths{idiff},'.');
        F_disp(['ATTENTION - CHAMP NON REFERENCE INUTILE POUR L''APPLICATION : ',vc_fnames{end}])
        %            Mise en forme de la partie manquante dans le xml
        %            file
        F_struct2xml_format(['vs_conf' vc_diff_fields_paths{idiff}],vs_conf);
    end
end
if ~v_loc_dev % en mode normal, cad pas en mode dev
    % Suppression des champs
    for i=1:length(vc_diff_fields_paths)
        vc_fields=F_str_split(vc_diff_fields_paths{i},'.');
        try
            eval(['vs_conf' sprintf('.%s',vc_fields{1:end-1}) '=rmfield(vs_conf' sprintf('.%s',vc_fields{1:end-1}) ',''' vc_fields{end} ''');'])
        catch
            % le champ n'existe pas...
        end
    end
end
% Status valide ou non
v_status=~v_stop;
vs_conf_valid=vs_conf;
F_disp(' ')
F_disp('-------------------------------------------------------------------------');
F_disp('................ Fin de la verification du fichier de configuration XML');
F_disp('-------------------------------------------------------------------------');




    function vc_fields=F_get_fields2eval(v_fields_path,vc_fields)
        % Reecriture des chemin de la structure en fonction de la presence
        % de champs item dans le chemin de reference v_fields_path
        % (correspondant dans la structure a valider a des cell)
        if nargin<2
            vc_fields={};
        end
        
        % En cas de presence d'un champ item correspondant a la declaration
        % d'un cell pour le champ parent, on teste sur le premier element du
        % cell via un remplacement de item par {1}
        v_idx_cell=strfind(v_fields_path,'.item');
        if isempty(v_idx_cell)
            vc_fields={v_fields_path};
            return;
        end
        % dimension sur le premier niveau de cell
        v_nb_occur=0;
        try
            if eval(['iscell(' v_fields_path(1:v_idx_cell(1)-1) ');'])
                v_nb_occur=eval(['length(' v_fields_path(1:v_idx_cell(1)-1) ')']);
            end
        catch
            v_nb_occur=1;
        end
        for v_idx=1:v_nb_occur
            v_str_path=F_strings_rep(v_fields_path,'.item',['{' num2str(v_idx) '}'],1);
            if ~isempty(strfind(v_str_path,'.item'))
                vc_fields=F_get_fields2eval(v_str_path,vc_fields);
            else
                vc_fields{end+1}=v_str_path;
            end
        end
    end

    function vv_required=F_is_required(vs_struct,vv_idx)
        % determination du caractere obligatoire d'un ou plusieurs champ(s)
        % si il est obligatoire et que tous ses ascendants sont
        % obligatoires ou presents !
        vv_required=repmat(true,1,length(vv_idx));
        for id=1:length(vv_idx)
            p_idx=vs_struct(vv_idx(id)).parent_idx;
            while p_idx>1 % tant qu'on n'est pas au 1er niveau des champs
                % si le champ parent est optionnel ou qu'il n'existe pas
                if ~vs_struct(p_idx).required && ~vs_struct(p_idx).exist
                    vv_required(id)=false;
                    break
                end
                p_idx=vs_struct(p_idx).parent_idx;
            end
        end
        % l'element est requis a son niveau et que les elements
        % parents sont tous requis et/ou presents
        vv_required=[vs_struct(vv_idx).required] & vv_required;
    end

    function vs_desc_struct=F_get_descendant_struct(vs_ref_struct,v_elt_idx,vs_desc_struct)
        % Generation de la structure arborescente theoriquement contenue dans
        % un champ
        %
        % indices des elts enfants
        vv_childs=vs_ref_struct(v_elt_idx).childs_idx;
        % Si champ courant == item on sort
        %if strcmp(vs_ref_struct(v_elt_idx).nodename,'item')
        if length(vv_childs)==1 && strcmp(vs_ref_struct(vv_childs).nodename,'item')
            vs_desc_struct={};
            return
        end
        % Sinon on scanne la structure
        
        if nargin<3
            %vs_desc_struct=struct;
            vs_desc_struct='';
        end
        
        for ic=1:length(vv_childs)
            v_child_idx=vv_childs(ic);
            %             if ~vs_ref_struct(v_child_idx).required
            %                 continue
            %             end
            %disp( vs_ref_struct(v_child_idx).path)
            
            v_current_field=strrep(vs_ref_struct(v_child_idx).path,vs_ref_struct(v_elt_idx).path,'');
            % si un champ arborescent: on descend
            if ~isempty(vs_ref_struct(v_child_idx).childs_idx)
                vs_desc_struct.(strrep(v_current_field,'.',''))=F_get_descendant_struct(vs_ref_struct,v_child_idx);
            else
                % valeur par defaut
                v_default_value=vs_ref_struct(v_child_idx).value;
                % Si la valeur par defaut est codifiee
                % par le mot cle EMPTY, on le remplace par une
                % chaine vide.
                if ischar(v_default_value) && strcmp('EMPTY',v_default_value)
                    v_default_value='';
                end
                %                 if isempty(vs_ref_struct(v_child_idx).value)
                %                     F_disp(['ATTENTION - RENSEIGNER LA VALEUR (PAS DE VALEUR PAR DEFAUT DISPONIBLE) : '...
                %                         vs_ref_struct(v_child_idx).nodename ]);
                %                     % Mise en forme de la partie manquante dans le xml
                %                     % file
                %                     F_struct2xml_format(vc_fields2eval{i_field},vs_conf);
                %                 else
                %                     eval([ vc_fields2eval{i_field} '=v_default_value;']);
                %end
                %if vs_ref_struct(v_child_idx).active
                %                     eval(['vs_desc_struct' v_current_field '=vs_ref_struct(v_child_idx).value'])
                eval(['vs_desc_struct' v_current_field '=v_default_value;'])
                %end
            end
        end
    end

    function varargout=F_struct2xml_format(v_struct_path,vs_struct)
        v_format='txt';
        % F_disp('Informations sur le champ concerne dans le fichier de configuration:')
        F_disp(' ')
        vv_dot_idx=strfind(v_struct_path,'.');
        v_tab='  ';
        switch v_format
            case 'txt'
                vc_fields=F_str_split(v_struct_path,'.');
                nfields=1;
                for ifield=2:length(vc_fields)
                    v_first_brace=strfind(vc_fields{ifield},'{');
                    v_last_brace=strfind(vc_fields{ifield},'}');
                    if ~isempty(v_first_brace) && ~isempty(v_last_brace)
                        F_disp(sprintf('%s%s%s%s\n%s%s%s', repmat('  ',1,nfields+1),'<',vc_fields{ifield}(1:v_first_brace(1)-1),'>',...
                            repmat('  ',1,nfields+2),'<item>     -> bloc ',  ...
                            vc_fields{ifield}(v_last_brace(1)-1)))
                        nfields=nfields+3;
                    else
                        F_disp([repmat('  ',1,nfields) '<' vc_fields{ifield} '>'])
                        nfields=nfields+1;
                    end
                end
                if nargout
                    varargout{1}=repmat('  ',1,nfields);
                end
                F_disp(' ')
            case 'xml'
                % A REVOIR SI BESOIN, NON TERMINE !!!
                v_struct_path=strrep(v_struct_path,'vs_conf','vs_tmp');
                vs_tmp=vs_struct;
                if length(vv_dot_idx)>2
                    v_str_begin=length(vv_dot_idx)-2;
                elseif isempty(vv_dot_idx)
                    v_str_begin=length(vv_dot_idx)-1;
                else
                    
                end
                v_missing=v_struct_path(vv_dot_idx(end)+1:end);
                v_g_parent_path=v_struct_path(1:vv_dot_idx(end)-1);
                v_content='MISSING VALUE';
                if ~isstruct(v_struct_path)
                    v_content='MISSING FIELD + VALUE';
                end
                % Ajout du champ
                eval([v_parent_path '.' v_missing '=''' v_content '''']);
                % Mise en forme xml
                regexprep(xml_format(eval(v_parent_path),'off'),'<(|\/)root>','')
                
        end
        
    end
    function v_desc=F_get_type_desc(v_type)
        v_desc='unknown';
        if ~exist('vs_types','var')
            vs_types.name={'cell'  'char'  'double' 'struct'};
            vs_types.desc={'champ xml <item>'  'chaine de caracteres'  'valeur numerique' 'champ xml <...>'};
        end
        if nargin
            idx=ismember(vs_types.name,v_type);
            if any(idx)
                v_desc=vs_types.desc{idx};
            end
        else
            v_desc=vs_types;
        end
    end
end
