classdef configDocument < xmlDocument
    % CONFIGDOCUMENT xml configuration file class
    % - load an data manipulation of a MultiSimLib xml configuration file
    % - write data to a modified xml file.
    %
    %  MODIFICATIONS (last commit)
    %    $Date: 2013-06-26 08:09:40 +0200 (mer., 26 juin 2013) $
    %    $Author: plecharpent $
    %    $Revision: 951 $
    %
    
    properties
        % Parent class attributes (xmlDocument < fileDocument)
        %
        % Name % file name, or xml flux
        % Dir % directory path or url of xml file
        % Fid  % file identifier
        % Open % file status
        % XslResource % absolute or relative path or url of xsl file
        % XslType %  kind of url : file or java archive url
        % Content=''; % structure generated from the xml file when loaded (see
        % loadContent() method)
        % ContentType=''; % type of structure generated from xml file ('basic','full')
        % Root='';  % structure of root document: with fields 'name and
        % 'attributes' (structure with fields: name,value)
        %
        % configDocument class attributes
        UseCase
        SubUseCase
        FieldsDict=struct; % loaded from file : config_fields_dict.csv
    end
    
    methods
        function obj = configDocument(v_path_or_struct,use_case_name,sub_use_case)
            % xlmDocument constructor call
            obj = obj@xmlDocument(v_path_or_struct);
            if nargin<3
               sub_use_case=''; 
            end
            if nargin < 2
                use_case_name='';
            end
            % loading dict data
            obj=obj.setUseCase(use_case_name,sub_use_case);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % A VOIR pour manip structure conf utilisee dans les programmes
            % Non traite ici : avec une structure en entree qui peut
            % etre complete ou simple(== vs_conf multisimlib)
            % conversion des structures de basic a full et inversement
            
            % manipulation sur la structure basic: ici que sur full
            % se baser sur le contentType pour separer les traitements
            % aiguillage sur 2 methods specifiques.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % loading file content
            obj=obj.loadContent('full'); % voir full ou tree_struct ou tree_obj !!!!
            % A VOIR PAR RAPPORT FACILITE DE CHANGEMENT CONTENU !!!
            % si full : chemin facilement accessible, tree_obj :
            % possibilite de recherche avec chemin, tree_struct fonct
            % recherche a ajouter !!!!
            
        end
        
        function obj=setDataIn(obj,filename)
            obj=obj.setContent('NameMatIn',filename);
        end
        
        function obj=setModel(obj,name)
            obj=obj.setContent('ModelName',name);
        end
        
        function obj=setVersion(obj,version)
            obj=obj.setContent('ModelVersion',version);
        end
        
        function obj=setMode(obj,mode)
            obj=obj.setContent('Mode',mode);
        end
        
        function obj=setManageOutput(obj,manage)
            obj=obj.setContent('ManageOutput',manage);
        end
        
        function obj = setInputFileDir(obj,v_dir_type,v_dir)
            % Setting input files types directories
            %
            % Default directories
            % conf = conf.setInputFileDir
            %
            % One directory for all types (keyword 'all')
            % conf = conf.setInputFileDir('all','data')
            %
            % A directory for one or several types
            % conf = conf.setInputFileDir('Tec','data/tec')
            % conf = conf.setInputFileDir({'Tec' 'Plt'},'data')
            %
            % A directory for each type
            % conf = conf.setInputFileDir({'Tec' 'Plt'},{'data/tec' 'data/plt'})
            %
            vc_ref_keys={'Plt' 'Tec' 'Obs' 'Climat' 'Sol' 'Par' 'Ini' 'all'};
            vc_default_dirs={'data\plt' 'data\tec' 'data\obs' 'data\climat'...
                'data\sol' 'data\par' 'data\ini'};
            v_verify_keys=true;
            if isunix
                vc_default_dirs=cellfun(@(x) {strrep(x,'\','/')},vc_default_dirs);
            end
            
            if nargin<2
                vc_dirs=vc_default_dirs;
            else
                if ischar(v_dir_type)
                    vc_keys={v_dir_type};
                end
                
                if iscell(v_dir_type)
                    vc_keys=v_dir_type;
                end
                if length(vc_keys)==1 && strcmp('all',vc_keys{1})
                    vc_keys=vc_ref_keys(~strcmp('all',vc_ref_keys));
                end
                if ischar(v_dir)
                    vc_dirs={v_dir};
                end
                if iscell(v_dir)
                    vc_dirs=v_dir;
                end
            end
            if ~exist('vc_keys','var')
                vc_keys=vc_ref_keys(1:end-1);
                v_verify_keys=false;
            end
            
            for k=1:length(vc_keys)
                if v_verify_keys && ~ismember(vc_keys{k},vc_ref_keys)
                    error('%s : this key word is not referenced.\nPossible keys are: \n%s',...
                        vc_keys{k},sprintf('%s ',vc_ref_keys{:}));
                end
                if length(vc_dirs)==1
                    v_dir_to_set=vc_dirs{1};
                else
                    v_dir_to_set=vc_dirs{k};
                end
                obj = obj.setContent(vc_keys{k},v_dir_to_set);
            end
        end
        
        function obj=setInputFilesDirs(obj,vc_dir_type,vc_dir)
            if nargin<2
                obj=obj.setInputFileDir;
                return
            end
            if length(vc_dir_type)~=length(vc_dir)
               error('Dimensions are not consistent !') 
            end
            for i=1:length(vc_dir_type)
               obj=obj.setInputFileDir(vc_dir_type{i},vc_dir{i}); 
            end
        end
        
        function obj=setOutputDir(obj,directory)
            obj=obj.setContent('Output',directory);
        end
        
        % dates : given as a string (full xml structure, only char)
        function obj=setVarDates(obj,varname,dates_str)
            obj=obj.setContent('Var',dates_str,'Dates','Label',varname);
        end
        
		function obj=addVar(obj,varname)
            switch obj.UseCase
                % A REVOIR ET addContent !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                case {'evaluation' 'optimisation'}
                    fieldpath=obj.getFieldValue('Var','fieldpath');
                    %fieldpath=obj.getFieldValue('itemUsmList','fieldpath');

                    obj=obj.addContent(fieldpath,'UsmList','');
                    fieldpath=obj.getFieldValue('itemUsmList','fieldpath');
                    obj=obj.addContent(fieldpath,'Labels','');
                    %,'Include',0
                    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                case 'standard'
                    obj=obj.addVarDates(varname);
            end
		end
		
        function obj=addVarDates(obj,varname,dates_str)
            % dates_str : optionnal           
            fieldpath=obj.getFieldValue('Var','fieldpath');
            if ~exist('dates_str','var') % extract default value
                dates_str=num2str(obj.getFieldValue('Dates','value'));
            end
            obj=obj.addContent(fieldpath,'Dates',dates_str,'Label',varname);
        end
        
        function model = getModel(obj)
            model = obj.getContent('Model');
        end
        
        function model = getManage(obj)
            model = obj.getContent('ManageOutput');
        end
        
        function file_dir = getInputFileDir(obj,v_dir_type)
           file_dir = obj.getContent(v_dir_type);
        end
        
        function save(obj)
            obj.writeToFile(obj.getPath);
        end
        
        function saveAs(obj,v_file_name)
            if ~exist('v_file_name','var')
                v_file_name='';
            end
            obj.writeToFile(v_file_name);
        end
        % A VOIR AVEC F_MSLIB_MODES
        function obj=setUseCase(obj,use_case_name,sub_use_case)
            obj=obj.loadFieldsDict(use_case_name,sub_use_case);
            obj.UseCase=use_case_name;
            obj.SubUseCase=sub_use_case;
        end
        
        
        
        function listModifiablesKeys(obj)
            disp(' ')
            vc_keys=obj.getDictKeys;
            if isempty(vc_keys)
                return
            end
            disp(sprintf('%s\t\t%s\t\t%s','key to use','modifiable fieldpath','Definition/Comment'));
            disp('-----------------------------------------------------------------------')
            for i=1:length(vc_keys)
                disp(sprintf('%s\t\t%s\t\t\t\t\t%s',vc_keys{i},obj.getFieldValue(vc_keys{i},'fieldpath'),obj.FieldsDict.dict.comment{i}))
            end
            disp(' ')
        end
        
%         function writeToFile(obj,v_file_name)
%             if nargin<2
%                v_file_name=obj.Name; 
%             end
%             % write to an xml file with types attributes for matlab, and
%             % item tags for cell fields
%             writeToFile@xmlDocument(obj,v_file_name,'matlab');
%         end
       
        
        function obj=add(obj,fieldpath,name,value,type,key) % voir basic or full
            obj=obj.addContent(fieldpath,name,value,type,key); % FullContent, BasicContent
        end
        
        function vs_content = toStruct(obj,v_type)
            if ~exist('v_type','var')
                v_type='basic';
            end
            % overloading parent class for adding array structure type
            if strcmp('array',v_type)
                vs_content = toStruct@xmlDocument(obj,'full');
                vs_content= configDocument.convertStructToArray(vs_content);
            else
                vs_content = toStruct@xmlDocument(obj,v_type);
                vs_content = configDocument.removeItemFromStruct(vs_content,'item');
            end
            
        end
       
%         function  xml_string = toString(obj)
%             
%         end
        
        function obj=importStruct(obj,vs_struct)
            obj=importStruct@xmlDocument(obj,configDocument.removeItemFromStruct(vs_struct,'item'));
            obj.ContentType=xmlDocument.getStructType(obj.Content);
            %obj=importStruct@xmlDocument(obj,vs_struct);
        end
    end
    
    %methods(Access=private)
    methods
        function obj=loadContent(obj,v_type)
            % for a new document, not created from an xml file
            if ~obj.exist && ~isempty(obj.UseCase)
                vs_struct=configDocument.genConfStruct(obj.UseCase,obj.SubUseCase);
                %
                obj=obj.importStruct(vs_struct);
                % set use case mode
                [v_exist,v_mode_data]=F_mslib_modes(obj.UseCase);
                obj=obj.setMode(v_mode_data.Num);
            else
                obj=loadContent@xmlDocument(obj,v_type);
            end
        end
        
        function obj=modifyContent(obj,action,key_or_fieldpath,value,searchfield,searchname)
            % prise en charge de set et add Content: action == switch sur
            % modifications
            % refactoring a faire!!!!
        end
        
        function obj=setContent(obj, key,value,fieldname,searchfield,searchname)
            % if key correponds to a fieldpath containing a cell:
            % searchfield,searchname are needed
            % GET ATTENTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 1- only 'full' structure is treated for the moment !
            %
            % 2- We are considering here that there is only one cell
            % hierachical level in the structure !
            % field containing cell of structures with cells inside is
            % actually not treated
            %
            %
            %

            sep='''';
            if strcmp(obj.ContentType,'full')
                if isnumeric(value)
                    if max(size(value))>1
                        disp('value must be a char array for ''full'' structure!')
                        return
                    end
                    sep='';
                end
            end
            fieldpath=obj.getFieldValue(key,'fieldpath');
            if isempty(fieldpath)
                return
            end
            % cf tableau csv des cas d'utilisation : le type non correct
            %
            type=obj.getFieldValue(key,'type');
            
            % switch on field type: simple or cell !
            % voir basic or full!!!!!!!!!!!!!
            switch type
                case 'cell'
                    if ~exist('searchfield','var') || ~exist('searchname','var')
                        error('Missing search field or search name, for setting %s value !',fieldname)
                    end
                    % if item field is detected containing a cell data
                    if eval(['~iscell(obj.Content' fieldpath ')']) && ...
                            eval(['isfield(obj.Content' fieldpath ',''item'')'])
                        fieldpath=[fieldpath '.item'];
                    end
                    % content extract
                    eval(['cell_content=obj.Content' fieldpath ';']);
                    % finding var index
                    cell_elt_idx=find(cellfun(@(x) strcmp(x.(searchfield).CONTENT,searchname),cell_content));
                    if size(cell_elt_idx,2)>1
                       error(['Multiple elements with same value for '  searchfield ': ' searchname]);
                    end
                    if isempty(cell_elt_idx)
                       error('Cell element with %s == %s value was not found ! \n%s ',searchfield, ...
                           searchname,'Use addContent instead of setContent')
                    end
                    % setting
                    eval(['obj.Content' fieldpath '{' num2str(cell_elt_idx) '}.(''' fieldname ''').CONTENT=''' value ''';'])
                    vs_cell_data=obj.getDictData(obj.getDictData(fieldpath).childs_idx);                   
                    vs_fieldname_data=obj.getDictData(vs_cell_data.fieldpath,fieldname);
                    if ~eval(['isfield(obj.Content' fieldpath  '{' num2str(cell_elt_idx) '}.' fieldname ',''ATTRIBUTE'')']) ...
                            || ~strcmp(eval(['obj.Content' fieldpath '{' num2str(cell_elt_idx) '}.' fieldname '.ATTRIBUTE.type']),...
                            vs_fieldname_data.type)
                        eval(['obj.Content' fieldpath '{' num2str(cell_elt_idx) '}.' fieldname '.ATTRIBUTE.type=''' vs_fieldname_data.type ''';'])
                    end
                otherwise % 
                    if ~strcmp(type,class(value))
                        error('Value specified for %s has a wrong type (%s instead of %s): %s',key,class(value),type,value);
                    end
                    if ~isempty(fieldpath)
                        eval(['obj.Content' fieldpath '.CONTENT=' sep num2str(value) sep ';']);
                        eval(['obj.Content' fieldpath '.ATTRIBUTE.type=''' type ''';']);
                    end
            end
        end
        
        
        function value = getContent(obj,key) %  full
            % TO ADD : occurrence if parent field is a cell
            value='';
            fieldpath=obj.getFieldValue(key,'fieldpath');
            if ~isempty(fieldpath)
                eval(['value=obj.Content' fieldpath '.CONTENT;']);
            end
        end
        
        function obj=addContent(obj,fieldpath,fieldname,value,searchfield_or_type,searchname_or_key)
            % Ou alors addContentToExistingCellField
            % et
            % obj=addContentNewField(obj,fieldpath,fieldname,value,type,key)
            %: pour des choses qui n'existent pas a referencer dans le dico !!!!
            %
            % voir basic or full
            % We are considering here that there is only one cell
            % hierachical level in the structure !
            % field containing cell of structures with cells inside is
            % not possible
            %
            
            % verify if dictionnary of paths is loaded for a usecase
            if ~obj.dictLoaded
                error('A use case name must be provided as an argument to be able to add content.\n%s',...
                    'Use constructor argument or set it with object.loadFieldsDict(use_case_name) before.')
            end
            
%             if strcmp(obj.ContentType,'full')
%                 if ~ischar(value)
%                     disp('value must be a char array for ''full'' structure!')
%                     return
%                 end
%             end
            % default type : char
            % other possible types: numeric,double,cell
            % pairs : value,name, if fieldpath type is cell
            v_search=all([exist('searchfield_or_type','var') exist('searchname_or_key','var')]);
            
            if ~obj.existFieldPath(fieldpath)
                return
            end
            
            vs_ref_field_data=obj.getDictData(fieldpath);
            
            if strcmp(vs_ref_field_data.type,'cell')  && ...
                    strcmp(obj.getDictData(vs_ref_field_data.childs_idx).keys,'item')
                vs_ref_field_data=obj.getDictData(vs_ref_field_data.childs_idx);
                % fieldpath=[fieldpath '.' vs_ref_field_data.nodename];
            end
            % detecting types
            for i=1:length(vs_ref_field_data.childs_idx)
                fieldname_type='char';
                searchfield_type='char';
                vs_child_data=obj.getDictData(vs_ref_field_data.childs_idx(i));
                if strcmp(fieldname,vs_child_data.nodename)
                    fieldname_type=vs_child_data.type;
                elseif exist('searchfield_or_type','var') && ...
                        strcmp(searchfield_or_type,vs_child_data.nodename)
                    searchfield_type=vs_child_data.type;
                end
            end
            
            % removing leading '.'
            if strcmp('.',fieldpath(1))
                fieldpath=fieldpath(2:end);
            end
            
            % If field exists: contains a cell of structures
            % try to find if an element of the cell contains a
            % field (searchfield_or_type) which contains search
            v_fieldpath_exist=true;
            % content extract
            try
                eval(['field_content=obj.Content.' fieldpath ';']);
            catch
                v_fieldpath_exist=false;
            end
            cell_elt_idx=[];
            if v_fieldpath_exist && iscell(field_content)
                % finding index
                if v_search
                    what=searchname_or_key;
                    where=searchfield_or_type;
                    %                 else
                    %                     what=value;
                    %                     where=fieldname;
                    %                 end
                    cell_elt_idx=find(cellfun(@(x) strcmp(x.(where).CONTENT,what),field_content));
                    
                    if ~isempty(cell_elt_idx)
                        if length(cell_elt_idx) > 1
                            error('multiple elements with same value for %s',  searchfield_or_type)
                        end
                        if ~v_search
                            disp([fieldpath ': this cell already contains an element structure with ' where ' field containing ' what])
                            disp('nothing was modified (use setContent instead !')
                            return
                        else
                            eval(['field_exists=isfield(obj.Content.' fieldpath '{' num2str(cell_elt_idx) '},''' fieldname ''');']);
                            if field_exists
                                disp([fieldpath ': this cell already contains a structure with ' where ' field containing ' what])
                                disp('nothing was modified!')
                                return
                            end
                            eval(['obj.Content.' fieldpath '{' num2str(cell_elt_idx) '}.(''' fieldname ''').CONTENT=''' value ''';'])
                            % a voir en fonction du contenu !!! (cf.
                            % type=double
                            % eval(['obj.Content.' fieldpath '{' num2str(cell_elt_idx) '}.(''' fieldname ''').ATTRIBUTE=struct;'])
                            eval(['obj.Content.' fieldpath '{' num2str(cell_elt_idx) '}.(''' fieldname ''').ATTRIBUTE.type=''' fieldname_type ''';'])
                        end
                    end
                end
                    
                if isempty(cell_elt_idx)
                    idx=length(field_content)+1;
                    % test if to be set or added
%                     if eval(['isfield(obj.Content.' fieldpath '{' num2str(idx) '},''' fieldname ''')'])...
%                         && eval(['~isempty(obj.Content.' fieldpath '{' num2str(length(field_content)) '}.(''' fieldname ''').CONTENT)'])
%                        idx=idx+1;
%                     end
                        
                    % adding fieldname/value to a new cell structure elt
                    eval(['obj.Content.' fieldpath '{' num2str(idx) '}.ATTRIBUTE=struct;'])
                    eval(['obj.Content.' fieldpath '{' num2str(idx) '}.(''' fieldname ''').CONTENT=''' value ''';'])
                    if v_search
                        % adding searchfield_or_type/searchname_or_key to a new cell elt structure
                        eval(['obj.Content.' fieldpath '{' num2str(idx) '}.(''' searchfield_or_type ''').CONTENT=''' searchname_or_key ''';'])
                        % a voir en fonction du contenu !!! (cf.
                        % type=double
                        eval(['obj.Content.' fieldpath '{' num2str(idx) '}.(''' searchfield_or_type ''').ATTRIBUTE.type=''' searchfield_type ''';'])
                    end
                    % a voir en fonction du contenu !!! (cf.
                        % type=double
                    eval(['obj.Content.' fieldpath '{' num2str(idx) '}.(''' fieldname ''').ATTRIBUTE.type=''' fieldname_type ''';'])
                end
                return 
            end
            
            
            % Adding a new field to Content
            %
            type=searchfield_or_type;
            key=searchname_or_key;
            % le fiedpath n'existe pas
            if exist('type','var')
                if ~ismember(type,{'char','double','cell'})
                    disp([type ': is not a valid type!'])
                    return
                end
            end
            % test on value
            if exist('value','var')
                value_to_add=num2str(value);
            end
            % test si le path parent existe, sinon on sort
            points=strfind(fieldpath,'.');
            parentfieldpath=fieldpath(1:points(end)-1);
            try
                eval([ 'obj.Content.' parentfieldpath ';']);
            catch
                disp([parentfieldpath ' : parent field of the new field to add doesn''t exists!'])
                return
            end
            switch type
                case 'cell'
                otherwise
                    % adding : fieldpath & value_to_add to Content
                    eval([ 'obj.Content.' fieldpath '.' fieldname '.CONTENT=''' value_to_add ''';']);
                    if strcmp(type,'double')
                        eval([ 'obj.Content.' fieldpath '.ATTRIBUTE.type=''double'';']);
                    end
            end
            
            % if new key provided : added to FieldsDict
            if exist('key','var')
                if obj.existKeyValue(key)
                    disp([ key ' : this key already exists!'])
                    return
                end
                % adding to dict
                % all fields values are not set here : TO BE DONE
                % NEW method : addDictEntry ... (+setting default content)
                obj.FieldsDict.dict.keys{end+1}=key;
                obj.FieldsDict.dict.fieldpath{end+1}=['.' fieldpath '.' fieldname];
                obj.FieldsDict.dict.idx(end+1)=max([obj.FieldsDict.dict.idx])+1;
            end
        end
        
        
        
        function obj=loadFieldsDict(obj,use_case_name,sub_use_case)
            obj.FieldsDict.loaded=false;
            if ~exist('use_case_name','var') || isempty(use_case_name)
                return
            end
            
            vs_tmp_dict=configDocument(configDocument.genConfStruct(use_case_name,sub_use_case)).toStruct('array');
            vs_tmp_dict(1).nodename='root';
            
            
            % integration F_xml2conf_struct dans classe configDocument/ou
            % xmlDocument connvert struct ????
            
            % LOAD infos in obj.FieldsDict !!!!
            vc_fnames=fieldnames(vs_tmp_dict);
            for i=1:length(vc_fnames)
                obj.FieldsDict.dict.(vc_fnames{i})={vs_tmp_dict.(vc_fnames{i})};
            end
            nb_elts=size(vs_tmp_dict,2);
            obj.FieldsDict.dict.keys={};
            for ielt=1:nb_elts
                if ismember(obj.FieldsDict.dict.nodename{ielt},obj.FieldsDict.dict.keys)
                    % disp('creating key with parent name + node name')
                    obj.FieldsDict.dict.keys{ielt}=[obj.FieldsDict.dict.nodename{obj.FieldsDict.dict.parent_idx{ielt}} obj.FieldsDict.dict.nodename{ielt}];
                else
                    % disp('creating key with node name ')
                    obj.FieldsDict.dict.keys{ielt}=obj.FieldsDict.dict.nodename{ielt};
                end
                % disp(obj.FieldsDict.dict.keys{ielt})
                % disp(obj.FieldsDict.dict.path{ielt})
                % disp('---------------')
            end
            % AVANT keys==nodename A REVOIR
            obj.FieldsDict.dict.fieldpath=obj.FieldsDict.dict.path;
            obj.FieldsDict.dict.idx=cell2mat(obj.FieldsDict.dict.idx);
            
            %
            % VOIR : ajout possibilites de recherche dans la structure du
            % doc xml ??????          equivalentes a methodes associees au
            %   Dict !!!!!!!!!!!!!!!!!!!!!!!
            %
            %   A VOIR : ensuite utiliser directement l'objet xml au lieu de la
            %   structure FieldsDict
            %
            %
            % second step
            % implement file reading and structure filling
            % csv=csvDocument('D:\Home\lecharpe\projet_multisimlib\Dev\checkout\Conf\Files\config_fields_dict.csv',';',1)
            % FieldsDict.dict=csv.toStruct;
            
            
            obj.FieldsDict.loaded=true;
        end
        
        function vc_keys = getDictKeys(obj)
            vc_keys={};
            if obj.dictLoaded
                vc_keys=obj.FieldsDict.dict.keys;
            end
        end
        
        function vc_keys = findDictKeys(obj,word)
            vc_found=strfind(obj.FieldsDict.dict.keys,word);
            vc_keys=obj.FieldsDict.dict.keys(~cellfun(@isempty,vc_found));
        end
        
        function vc_path= findDictPath(obj,word)
            vc_found=strfind(obj.FieldsDict.dict.path,word);
            vc_path=obj.FieldsDict.dict.path(~cellfun(@isempty,vc_found));
        end
        
        function [fieldexists,field_logical_idx]=existFieldPath(obj,pathvalue)
            if ~strcmp(pathvalue(1),'.')
               pathvalue=['.' pathvalue]; 
            end
            [fieldexists,field_logical_idx]=obj.existDictFieldValue('fieldpath',pathvalue);
        end
        
        function [keyexists,key_logical_idx]=existKeyValue(obj,value)
            [keyexists,key_logical_idx]=obj.existDictFieldValue('keys',value);
        end
        
        function [keyexists,key_logical_idx]=existNodeIdx(obj,value)
            [keyexists,key_logical_idx]=obj.existDictFieldValue('idx',value);
        end
        
        function [v_exist,v_logical_idx]=existDictFieldValue(obj,fieldname,value)
            v_exist=false;
            v_logical_idx=false(1,length(fieldnames(obj.FieldsDict.dict)));
            % seul id est numerique dans dict
            if isnumeric(value) && ~strcmp(fieldname,'idx')
               return 
            end
            if ~obj.dictLoaded
                disp('Use case dictionnary not loaded')
                return
            end
            if ~ismember(fieldnames(obj.FieldsDict.dict),fieldname)
                disp([ fieldname ': fieldname does''nt exists!'])
                return
            end
            if ~exist('value','var')
                v_exist=true;
            else
                v_logical_idx=ismember(obj.FieldsDict.dict.(fieldname),value);
                v_exist=any(v_logical_idx);
            end
            
        end
        
        function vs_data=getDictData(obj,key_fieldpath_id,child_fieldname)
            if exist('child_fieldname','var') && obj.existFieldPath(key_fieldpath_id)
                key_fieldpath_id=[key_fieldpath_id '.' child_fieldname];
            end
            idx=[];
            vs_data=struct;
            [keyexists,key_logical_idx]=obj.existKeyValue(key_fieldpath_id);
            [fieldexists,field_logical_idx]=obj.existFieldPath(key_fieldpath_id);
            [idexists,id_logical_idx]=obj.existNodeIdx(key_fieldpath_id);
            if keyexists
                idx=find(key_logical_idx);
            elseif fieldexists
                idx=find(field_logical_idx);
            elseif idexists
                idx=find(id_logical_idx);
            else
                disp([ key_fieldpath_id ': unknown value in key or fieldpath field!']);
                return
            end
            fnames=fieldnames(obj.FieldsDict.dict);
            for i=1:length(fnames)
                if iscell(obj.FieldsDict.dict.(fnames{i}))
                    vs_data.(fnames{i})=obj.FieldsDict.dict.(fnames{i}){idx};
                else
                    vs_data.(fnames{i})=obj.FieldsDict.dict.(fnames{i})(idx);
                end
            end
        end
        
        function fieldvalue=getFieldValue(obj,key_fieldpath_value,fieldname)
            fieldvalue='';
            idx=[];
            if ~obj.dictLoaded
                return
            end
            [keyexist,key_logical_idx]=obj.existKeyValue(key_fieldpath_value);
            [fieldpathexist,fieldpath_logical_idx]=obj.existFieldPath(key_fieldpath_value);
            if keyexist
                idx=find(key_logical_idx);
            elseif fieldpathexist
                idx=find(fieldpath_logical_idx);
            end
            vc_fieldvalues=obj.FieldsDict.dict.(fieldname)(idx);
            if ~isempty(vc_fieldvalues)
                fieldvalue=vc_fieldvalues{1};
            else
                disp([key_fieldpath_value 'is a unknown / referenced key!'])
                disp(['Possible values : ' sprintf('%s ',obj.FieldsDict.dict.keys{:})])
            end
        end
        
        function loaded=dictLoaded(obj)
            loaded=obj.FieldsDict.loaded;

        end
    end
    
    
    
    methods(Static)
        
        function use_case_list=getUseCaseList
            [ex,vs_mode]=F_mslib_modes;
            use_case_list=vs_mode.Label;
            % disp('not implemented yet');
        end
        
        function vs_use_case_data = getUseCaseData(varargin)
            [ex,vs_use_case_data]=F_mslib_modes(varargin{:});
        end
        
        function vs_conf_struct = genConfStruct(use_case_name,varargin)
            % ,sub_use_case,vs_options)
            if ~nargin
               F_disp('A use case name must be provided !')
               vs_conf_struct=struct;
               return
            end
            sub_use_case='';
            for i=1:length(varargin)
               if ischar(varargin{i})
                   sub_use_case=varargin{i};
               end
               if isstruct(varargin{i})
                  vs_options=varargin{i};
               end
            end
            if ~exist('vs_options','var')
               vs_options.documented=0;
            end
            % F_gen_xml_conf
            vs_conf_struct=F_gen_xml_conf(use_case_name,sub_use_case,vs_options);
            %
            %
        end
        
        function vs_out_struct=convertStructToArray(vs_struct)
            vs_out_struct=F_xml_struct_browser(vs_struct);
        end
        
        function vs_struct = removeItemFromStruct(vs_struct,v_rm_fieldname)
            %
            % Producing a full structure
            if ~nargin
                error('missing input structure var, fieldname to remove')
            end
            if ~exist('v_rm_fieldname','var')
                return;
            end
            if iscell(vs_struct)
                for j=1:length(vs_struct)
                    vs_struct{j}=configDocument.removeItemFromStruct(vs_struct{j},v_rm_fieldname);
                end
            end
            if isstruct(vs_struct)
                vc_fields=fieldnames(vs_struct);
                if ismember(v_rm_fieldname,vc_fields)
                    v_tmp=configDocument.removeItemFromStruct(vs_struct.(v_rm_fieldname),v_rm_fieldname);
                    if ~iscell(vs_struct.(v_rm_fieldname))
                        %vs_struct={vs_struct.(v_rm_fieldname)};
                        vs_struct={v_tmp};
                    else
                        %vs_struct=vs_struct.(v_rm_fieldname);
                        vs_struct=v_tmp;
                    end
                    return
                end
                vc_fields=setdiff(vc_fields,v_rm_fieldname);
                for i=1:length(vc_fields)
                    v_field_name=vc_fields{i};
                    vs_struct.(v_field_name)=configDocument.removeItemFromStruct(vs_struct.(v_field_name),v_rm_fieldname);
                end
            end
        end
    end
end