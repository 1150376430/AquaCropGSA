function vs_out_struct = F_xml_struct_browser(vs_in_struct,v_str_fields,...
    v_check_required_field_list,vs_out_struct)
%F_XML_STRUCT_BROWSER Creation d'un tableau de structures avec tous les chemins des champs
% d'une structure xml complete (type : full, avec ATTRIBUTE,CONTENT)
%   vs_out_struct =
%   F_xml_struct_browser(vs_in_struct,v_str_fields,vs_out_struct)
%
%   ENTREE(S): descriptif des arguments d'entree
%      - vs_in_struct: structure de type v_conf ou xml avec ATTRIBUTE,
%      CONTENT
%      optionnels :
%      - v_str_fields : chemin du champ a traiter dans la structure
%      - v_check_required_field_list (logical): 1 to verify if 
%       fields list set in vc_required_ATTRIBUTE_fields_list variable exists
%       in each ATTRIBUTE field of the full structure, 0 otherwise (default
%       value)
%      - vs_out_struct : voir descriptif dans argument de sortie
%        (fournie dans les appels en recursif)
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vs_out_struct : structure avec les champs
%       path : chemin complet de chaque champ de la structure
%       required : logical
%       default : valeur affectee au champ
%       ancestors_idx : index des ascendants du champ dans la structure
%       vs_out_struct
%       active : logical
%
%   CONTENU: descriptif de la fonction
%
%   APPEL(S): liste des fonctions appelees
%      -
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - vs_out_struct = F_xml_struct_browser(vs_in_struct)
%      - vs_out_struct = F_xml_struct_browser(vs_in_struct,
%      '.Options.ModeData')
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 02-Nov-2010
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-22 15:14:54 +0200 (mer., 22 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 897 $
%
%
% See also isstruct, fieldnames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ~nargin || (~isstruct(vs_in_struct) && ~iscell(vs_in_struct))
    disp('argument manquant ou n''est pas une structure...')
    vs_out_struct=struct;
    return
end

if nargin<2
    v_str_fields='';
end
%
% Activation of required fields in ATTRIBUTE structure
% 
if nargin<3
    v_check_required_field_list=false;
end

% First function call: set the root element
if nargin<4
    vs_out_struct(1).path='';
    vs_out_struct(1).nodename='root';
    vs_out_struct(1).idx=1;
    vs_out_struct(1).ancestors_idx=[];
    vs_out_struct(1).parent_idx=[];
    vs_out_struct(1).childs_idx=[];
    vs_out_struct(1).required=true;
    vs_out_struct(1).active=0;
    vs_out_struct(1).occurrence=1;
    vs_out_struct(1).comment='';
    vs_out_struct(1).default=NaN;
end

% Calcul de l'index de l'element parent
v_parent_idx=strcmp(v_str_fields,{vs_out_struct.path});
% Init. liste descendants du parent
vs_out_struct(v_parent_idx).childs_idx=[];

vc_required_ATTRIBUTE_fields_list={'Required' 'Occurrence' 'Active' 'Comment' 'DefaultValue'};
vc_output_fields_list={'required' 'occurence' 'active' 'comment' 'value'};
vc_output_fields_types={'logical' 'double' 'logical' 'char' 'char'};
v_isrequired_fields_valid=true;


switch class(vs_in_struct)
    case 'struct'
        % Liste des champs de la structure
        vc_fnames=fieldnames(vs_in_struct);
        for v_fnum=1:length(vc_fnames)
            % On scrute le contenu du champ vc_names{v_fnum} si c'est un champ
            % autre que ATTRIBUTE ou CONTENT
            if ~any([ strcmp('ATTRIBUTE',vc_fnames{v_fnum}) strcmp('CONTENT',vc_fnames{v_fnum})])
                % Calcul de l'index de l'element du tableau de structure a creer
                v_index=length(vs_out_struct)+1;
                vs_out_struct(v_index).path=[ v_str_fields '.' vc_fnames{v_fnum}];
                % Ajout du nom du noeud courant (ced en fin du path)
                vv_point_idx=strfind(vs_out_struct(v_index).path,'.');
                vs_out_struct(v_index).nodename=vs_out_struct(v_index).path((vv_point_idx(end)+1):end);
                % nouvel idx
                vs_out_struct(v_index).idx=max([vs_out_struct.idx])+1;
                vs_out_struct(v_index).parent_idx=find(v_parent_idx);
                % Stockage des index de la filiation
                vs_out_struct(v_index).ancestors_idx= [ vs_out_struct(v_parent_idx).ancestors_idx find(v_parent_idx) ] ;
                vs_out_struct(v_parent_idx).childs_idx=[vs_out_struct(v_parent_idx).childs_idx v_index];
                
                if isfield(vs_in_struct.(vc_fnames{v_fnum}),'ATTRIBUTE') && isstruct(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE)
                    % test sur les champs attendus dans ATTRIBUTE
                    if v_check_required_field_list
                        if ~isempty(setdiff(vc_required_ATTRIBUTE_fields_list,fieldnames(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE)))
                            v_isrequired_fields_valid=false;
                            break
                        end
                    end
                    % on fixe les valeurs par defaut au cas ou valeurs vides
                    % dans les champs
                    vs_out_struct(v_index).required=false;
                    vs_out_struct(v_index).occurrence=1;
                    vs_out_struct(v_index).active=false;
                    vs_out_struct(v_index).comment='';
                    
                    
                    if isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'Required') && ~isempty(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Required)
                        % Stockage du status obligatoire
                        vs_out_struct(v_index).required=logical(str2double(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Required));
                    end
                    if isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'Occurrence') && ~isempty(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Occurrence)
                        % Stockage du code d'occurrence
                        vs_out_struct(v_index).occurrence=str2double(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Occurrence);
                    end
                    if isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'Active') && ~isempty(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Active)
                        % Stockage du status d'actif ou non
                        vs_out_struct(v_index).active=logical(str2double(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Active));
                    end
                    if isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'Comment') && ~isempty(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Comment)
                        % Stockage du commentaire
                        vs_out_struct(v_index).comment=vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Comment;
                    end
                end
                %
                % Affectation d'une valeur par defaut au champ
                if isfield(vs_in_struct.(vc_fnames{v_fnum}),'CONTENT')
                    % affectation du type de donnee par defaut
                    vs_out_struct(v_index).type='char';
                    % L'affectation des valeurs ne se fait que pour les champs ayant un sous-champ CONTENT
                    % (lequel est theoriquement vide), ced pour des champs sans descendance (feuille)
                    % mais comme vs_out_struct est un tableau de structure, les
                    % autres champs (qui ont une descendance) auront aussi un champ
                    % value initialise automatiquement avec une valeur vide
                    if isfield(vs_in_struct.(vc_fnames{v_fnum}),'ATTRIBUTE') && isstruct(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE)
                        if isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'DefaultValue') && ...
                                isfield(vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE,'Type')
                            vs_out_struct(v_index).value=vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.DefaultValue;
                            if strcmp('double',vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Type)
                                vs_out_struct(v_index).value=str2num(vs_out_struct(v_index).value);
                                if isnan(vs_out_struct(v_index).value)
                                    vs_out_struct(v_index).value=[];
                                end
                                vs_out_struct(v_index).type='double';
                            end
                            if strcmp('cell',vs_in_struct.(vc_fnames{v_fnum}).ATTRIBUTE.Type)
                                if ~isempty(vs_out_struct(v_index).value)
                                    vs_out_struct(v_index).value={vs_out_struct(v_index).value};
                                else
                                    vs_out_struct(v_index).value={};
                                end
                                vs_out_struct(v_index).type='cell';
                            end
                        else
                            vs_out_struct(v_index).type=class(vs_in_struct.(vc_fnames{v_fnum}).CONTENT);
                            vs_out_struct(v_index).value=vs_in_struct.(vc_fnames{v_fnum}).CONTENT;
                        end
                    else
                        vs_out_struct(v_index).type=class(vs_in_struct.(vc_fnames{v_fnum}).CONTENT);
                        vs_out_struct(v_index).value=vs_in_struct.(vc_fnames{v_fnum}).CONTENT;
                    end
                else
                    % On considere par defaut que c'est une structure
                    vs_out_struct(v_index).type='struct';
                    % Sauf si vs_in_struct est une structure simple sans 'CONTENT', ni 'ATTRIBUTE'
                    if ~isfield(vs_in_struct.(vc_fnames{v_fnum}),'ATTRIBUTE')
                        vs_out_struct(v_index).type=class(vs_in_struct.(vc_fnames{v_fnum}));
                    end
                end
                %
                % Prise en compte des elements decrivant un cell
                % definition de la valeur par defaut
                %
                if isfield(vs_in_struct.(vc_fnames{v_fnum}),'item')
                    vs_out_struct(v_index).value={};
                    % on fixe le type a cell
                    vs_out_struct(v_index).type='cell';
                end
                %
                % Si le contenu du champ est une structure qui contient
                % d'autres champs que ATTRIBUTE et CONTENT, ou un cell on
                % la parcourt
                %
                if isstruct(vs_in_struct.(vc_fnames{v_fnum}))|| iscell(vs_in_struct.(vc_fnames{v_fnum}))
                    vs_out_struct=F_xml_struct_browser(vs_in_struct.(vc_fnames{v_fnum}),[ v_str_fields '.' vc_fnames{v_fnum}],...
                        v_check_required_field_list,vs_out_struct);
                end
                
                
            end
            
        end
        % erreur dans les champs attendus dans ATTRIBUTE, si verification
        % des champs attendus est active
        if v_check_required_field_list && ~v_isrequired_fields_valid
            F_disp('Conversion to a struct array is not possible (ATTRIBUTE fields are missing)!')
            F_disp('Required fields:');
            F_disp(sprintf('%s ',vc_required_ATTRIBUTE_fields_list{:}));
            vs_out_struct=struct;
            return
        end
        
    case 'cell'
        for i=1:length(vs_in_struct)
            % Calcul de l'index de l'element du tableau de structure a creer
            v_index=length(vs_out_struct)+1;
            vs_out_struct(v_index).path=[ v_str_fields '{' num2str(i) '}'];
            % le nom de champ est fictif : item
            vs_out_struct(v_index).nodename='item';
            % nouvel idx
            vs_out_struct(v_index).idx=max([vs_out_struct.idx])+1;
            vs_out_struct(v_index).parent_idx=find(v_parent_idx);
            % Stockage des index de la filiation
            vs_out_struct(v_index).ancestors_idx= [ vs_out_struct(v_parent_idx).ancestors_idx find(v_parent_idx) ] ;
            vs_out_struct(v_parent_idx).childs_idx=[vs_out_struct(v_parent_idx).childs_idx v_index];
            % Si le contenu du champ est une structure ou un cell
            % on la parcourt
            if isstruct(vs_in_struct{i}) || iscell(vs_in_struct{i})
                % ajout des index des descendants
                vs_out_struct=F_xml_struct_browser(vs_in_struct{i},[ v_str_fields '{' num2str(i) '}'],v_check_required_field_list,vs_out_struct);
            end
        end
end

% Ajout de la scrutation pour ajout des index des enfants de chaque noeud
% for i=1:length(vs_out_struct)
%     vs_out_struct(i).childs_idx=find(cell2mat(arrayfun(@(x) any(i==x.parent_idx),vs_out_struct,'UniformOutput',false)));
% end
disp('')


