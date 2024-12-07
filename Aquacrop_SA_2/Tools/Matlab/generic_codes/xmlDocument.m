classdef xmlDocument < fileDocument
    % XMLDOCUMENT xml file manipulation/transformation class
    % - Basic or full (with ATTRIBUTES, CONTENT fields)
    %   Matlab structure generation
    % - File generation with an xslt tranformation (xsl style sheet)
    %
    %  MODIFICATIONS (last commit)
    %    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
    %    $Author: plecharpent $
    %    $Revision: 940 $
    %
    
    properties
        % Parent class attributes (fileDocument)
        % Name % file name, or xml flux
        % Dir % directory path or url of xml file
        % Fid  % file identifier
        % Open % file status
        %
        % xmlDocument class attributes
        XslResource % absolute or relative path or url of xsl file
        XslType %  kind of url : file or java archive url
        Content=''; % structure generated from the xml file when loaded
        % or imported from the structure given as arg (see loadContent() method)
        ContentType=''; % type of structure generated from xml file ('basic','full')
        Root=struct; % structure of document root: name and attributes
    end
    
    properties(Access=protected,Constant=true)
        %Content=''; % structure generated from the xml file when loaded (see
        % loadContent() method)
        %
        % 'basic': simple structure
        % 'full' : complete structure with CONTENT,
        %  and ATTRIBUTES fields (contains all xml data)
        % 'tree_struct': structure of xml nodes: Name, Attributes, Data
        % and Children (struct array)
        % 'tree_obj': 'XMLTree object'
        %
        ContentTypes={'basic','full','tree_struct','tree_obj'};
        MatTypes={'struct','struct','struct','xmltree'};
        FieldIdent={'','ATTRIBUTE','Children',''};
        ContentDesc={'Without attributes','With attributes (ATTRIBUTES,CONTENT fields',...
            'With Name, Attributes, Data and Children (struct array of nodes) fields',...
            'XMLTree object'};
    end
    
    methods
        function obj = xmlDocument(v_path,v_xsl_url,v_xsl_type)
            % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            % TODO: new struct type
            %   'array': node,path,..., nodes links....
            %   actuellement produite par F_xml_struct_browser !!!
            %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            % Constructor
            %
            %  input:
            %    v_path : name or path of an xml file, or structure
            %             ('basic' or 'full' type)
            % Optionnal:
            %    v_xsl_url : absolute or relative path or url of xsl file
            %    (local, jar archive , distant)
            %    v_xsl_type : kind of url
            %        value :'file' or 'java' url (java.net.URL, for reading
            %        inside a jar archive, its path must be specified in
            %        the static javaclasspath, adding it in classpath.txt file)
            %        default value : 'file'
            %   (if not given, they can be set with setXslResource)
            %
            %  output: obj, xmlDocument object
            %
            if exist('v_path','var')
                if ischar(v_path)
                    obj = obj.setPath(v_path);
                elseif isstruct(v_path)
                    obj=obj.importStruct(v_path);
                else
                    disp('Unknown input data or file');
                end
            end
            if exist('v_xsl_url','var')
                if ~exist('v_xsl_type','var')
                    v_xsl_type='file';
                end
                obj = obj.setXslResource(v_xsl_url,v_xsl_type);
            end
            
            % setting default root name
            obj = obj.setRoot('root');
        end
        
        function obj = setPath(obj,v_path)
            % Set Path and Name of xmlDocument object
            %  input:
            %    v_path: name or path of an xml file
            %
            if exist('v_path','var') && ischar(v_path)
                set_path=true;
                if ~all([strfind(v_path,'.xml')  strfind(v_path,'.xsl')])
                    set_path=false;
                elseif exist(v_path,'file') % verifying content
                    xml_file=fileDocument(v_path).open;
                    if ~strfind(xml_file.getl,'<?xml')
                        set_path=false;
                    end
                    xml_file.close;
                end
                if ~set_path
                    error('%s : le fichier n''est pas un fichier de type xml!', v_path);
                end
                obj = obj.setName(v_path);
            else
                error('Chemin non fourni ou de type incorrect : %s', num2str(v_path));
            end
        end
        
        
        function obj = setXslResource(obj,v_xsl_url,v_xsl_type)
            % Set xslResource and xslType of xsl file
            %  input:
            %    v_path: name or path, url of an xsl file
            %    v_xsl_type: kind of url
            %
            if nargin<3
                v_xsl_type='file';
            end
            %
            obj.XslResource=v_xsl_url;
            obj.XslType=v_xsl_type;
        end
        
        function vs_content = toStruct(obj,v_type)
            % xml file content or struct transformation into matlab structure
            % (basic, full, tree structures or tree object)
            %
            %    v_type: kind of xml structure ('basic','full','tree_struct','tree_obj')
            %    if not given : 'basic' is set (xml attributes not loaded)
            %
            %  output:
            %    vs_content : structure produced if not already loaded
            %    (from file or imported structure, or object)
            %    else a structure conversion is performed to 'basic'
            %    structure type, or returns the Content structure !
            %
            % See also: xmltree
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % If the structure type is not given
            if ~exist('v_type','var')
                v_type='basic';
            end
            % if content already loaded
            % structure conversion between ContentType when
            % loaded and v_type if matches basic
            %if isempty(obj.Name) && obj.isLoaded
            if obj.isLoaded
                if strcmp(obj.ContentType,v_type)
                    vs_content=obj.Content;
                    return
                end
                if strcmp(obj.ContentType,'full') && ...
                        strcmp(v_type,'basic')
                    % conversion from 'full' to 'basic'
                    % disp('conversion from ''full'' to ''basic''')
                    vs_content = xmlDocument.convertStructTo(obj.Content);
                    return
                end
            end
            
            vs_content = '';
            if isempty(obj) % Path is not set, empty file source
                disp('File name or path not specified');
                disp('Use setPath method to proceed')
                return
            end
            % xml comments are not supported
            tmp_file='temp.xml';
            % removing all commented lines '<!-- -->' from file
            % (if not xml_parseany will fail)
            try
                xslt(obj.getPath,'nodes_copy.xsl',tmp_file);
            catch xsltError
                disp(xsltError.message)
                return
            end
            % adding exception catch
            try
                switch v_type
                    case 'basic'
                        vs_content=convert(xmltree(tmp_file));
                    case 'full'
                        vs_content=xmltree2full(xmltree(tmp_file));
                    case 'tree_struct'
                        vs_content=parseXML(tmp_file);
                    case 'tree_obj'
                        vs_content = xmltree(tmp_file);
                    otherwise
                        disp('Unknown structure type !')
                        disp(sprintf('Available types : %s',sprintf('%s ',obj.ContentTypes{:})));
                        disp(sprintf('Generated structure content : %s',sprintf('%s ',obj.ContentDesc{:})));
                end
            catch xmlDocumentError
                disp(xmlDocumentError.message)
                disp('Loading xml file failed (see error message)')
                return
            end
            delete(tmp_file);
        end
        
        function obj=importStruct(obj,vs_struct)
            obj.Content=vs_struct;
            % set Type
            
            obj=obj.setRoot;
            obj=obj.setContentType;
        end
        
        
        
        function obj=setContentType(obj)
            if obj.isLoaded
                obj.ContentType=xmlDocument.getStructType(obj.Content);
            end
        end
        
        function toFile(obj,v_file_name)
            % xslt xml file transformation with
            % xsl style sheet stored in XslResource attribute.
            %
            %  input:
            %    v_file_name: name or path of an output file
            %
            % See also: xslt,
            %
            v_del_file=false;
            if nargin<2
                error('Missing output file name argument!');
            end
            if ~obj.exist
                obj.writeToFile(obj.getPath);
                v_del_file=true;
            end
            if isempty(obj.XslType)
                error('%s : xsl resource is not set !',obj.getPath);
            end
            switch obj.XslType
                case 'file'
                    xslt(obj.getPath,obj.XslResource,v_file_name);
                case 'java'
                    res = java.lang.ClassLoader.getSystemResource(obj.XslResource);
                    xslt(obj.getPath,res.getContent,v_file_name);
            end
            if v_del_file
               obj.delete;
            end
        end
        
        function obj = reloadContent(obj,v_type)
            args=cell(1,2);
            args{2}=true;
            if nargin > 1
                args{1}=v_type;
            end
            obj = obj.loadContent(args{:});
        end
        
        function obj = loadContent(obj,v_type,v_force)
            % Store a structure generated from the xml file
            % in obj Content attribute
            %
            %  input: optionnal
            %    v_type :
            %        'basic': simple structure (default value if not given)
            %        'full' : complete structure with CONTENT,
            %        and ATTRIBUTES fields (contains all xml data)
            %        'tree_struct'
            %        'tree_obj'
            %    v_force: force reloading if already loaded (1 to force, 0
            %    instead [default])
            %
            %
            % See also toStruct, reloadContent
            %
            
            if nargin<3
                v_force=false;
            end
            
            if nargin<2
                v_type='basic';
            end
            
            if obj.isLoaded && ~v_force
                % message indicating possible conversions !!!!
                return
            end
            
            obj.Content = obj.toStruct(v_type);
            obj=obj.setContentType();
            % if loading failed
            if ~isempty(obj.Content)
                obj=obj.setRoot;
            else
                disp('the file could not be loaded (verify if exists!)')
                return
            end
        end
        
        function structloaded=isLoaded(obj)
            structloaded=false;
            if ~isempty(obj.Content)
                structloaded=true;
            end
        end
        
        function obj = setRoot(obj,root_name)
            if exist('root_name','var') && ischar(root_name)
                obj.Root.name=root_name;
            elseif obj.exist
                obj=obj.open();
                v_line=fgetl(obj.Fid);
                while ~isempty([strfind(v_line,'<?') strfind(v_line,'<!')])
                    v_line=fgetl(obj.Fid);
                end
                obj=obj.close();
                v_line=strrep(strrep(v_line,'<',''),'>','');
                v_blanks=strfind(v_line,' ');
                if ~isempty(v_blanks)
                    obj.Root.name=v_line(1:v_blanks(1)-1);
                else
                    obj.Root.name=v_line;
                end
            else
                obj.Root.name='root';
            end
            % Traiter les attributs : non fait
        end
        
        function xml_string = toString(obj,header_line,xsl_stylesheet_line)
            % Generates a string from Content structure in standard format
            % identical to the original file
            %
            %    input : optionnal
            %       header_line : logical, 1 for adding a header (default), 0
            %       otherwise
            %       xsl_stylesheet_line : logical, 1 for adding a stylesheet line
            %       , 0 otherwise (default)
            %
            % Initialisation de la chaine
            xml_string='';
            xml_head='';
            if nargin<2
               header_line=1; 
            end
            if nargin<3
               xsl_stylesheet_line=0; 
            end
            if header_line
                % sprintf('%s\n','<?xml version="1.0" encoding="UTF-8"?>');
               xml_head=sprintf('%s\n','<?xml version="1.0" encoding = "ISO-8859-1"?>');
            end
            if xsl_stylesheet_line && ~isempty(obj.XslResource)
               xml_head=[xml_head sprintf('%s\n',['<?xml-stylesheet type="text/xsl" href="' obj.XslResource '"?>'])]; 
            end
            %
            content=obj.Content;
            if ~isempty(content)
                switch obj.ContentType
                    case 'basic'
                        % xml_string=xml_format(content,'off');
                        % passage par xmltree
						content=struct2xml(content);
						content=attributes(content,'add',1,'creation',date);
                        xml_string=save(content);
                    case 'full'
                        % adding an attribute avoiding xml format error !
                        content.ATTRIBUTE(1).creation=date;
                        xml_string=xml_formatany(content,obj.Root.name);
                    case 'tree_struct'
                        % convert tree_struct to full
                        content=xmltree2full(content);
                        content.ATTRIBUTE(1).creation=date;
                        xml_string=xml_formatany(content);
                    case 'tree_obj'
                        content=attributes(content,'add',1,'creation',date);
                        xml_string=save(content);
                end
            end
            vc_lines=textscan(xml_string,'%s','delimiter','\n');
            vc_lines=vc_lines{1};
            xml_string=[xml_head sprintf('%s\n',vc_lines{:})];
        end
        
        
        function writeToFile(obj,v_file_name,xsl_stylesheet)
            % Write the structure stored in obj Content attribute to an xml
            % file
            %
            %  input:
            %    v_file_name : name or path of an output xml file
            %    optional:
            %    root_name : forcing root document tag name
            %
            v_lineend='\r\n';
            if isunix
                v_lineend='\n';
            end
            v_str_format=['%s' v_lineend];
            % if v_file_name not given
            if nargin < 2
                error('Output file name is missing!')
            end
 
            if isempty(obj.Root.name)
                obj=obj.setRoot('root');
            end
            
            if nargin<3
                xsl_stylesheet=0;
            end
            if isempty(obj.XslResource)
                xsl_stylesheet=0;
            end
            
            xml_string=obj.toString(1,xsl_stylesheet);
            
            if ~isempty(xml_string)
                fid=F_file_open(v_file_name,'w');
                
                % charger en cell et ecrire chaque ligne (pb : pas cd CR)
                vc_xml=textscan(xml_string,'%s','delimiter','\n');
                vc_xml=vc_xml{1};

                if isunix
                    fprintf(fid,v_str_format,vc_xml{:});
                elseif ispc
                    fprintf(fid,v_str_format,vc_xml{:});
                end
                fclose(fid);
            end
        end
        
        function v_bool = isempty(obj)
            % Evaluate if the object content is set
            % Overloading isempty built-in funtion for matlab classes
            %
            % See also : isempty
            v_bool = true;
            if ~isempty(obj.getPath)
                v_bool = false;
            end
        end
    end
    
    methods(Static)
        function struct_type=getStructType(vs_struct)
            %
            mtype=class(vs_struct);
            idx=ismember(xmlDocument.MatTypes,mtype);
            if ~any(idx)
                disp('Structure or class unknown !')
                return
            end
            switch mtype
                case 'xmltree'
                    struct_type=xmlDocument.ContentTypes{idx};
                case 'struct'
                    struct_type='basic';
                    for i=1:length(idx)
                        sident=xmlDocument.FieldIdent{i};
                        if idx(i) && ~isempty(sident)
                            if isfield(vs_struct,sident)
                                struct_type=xmlDocument.ContentTypes{i};
                                break
                            end
                        end
                    end
            end
        end
        

        
        function vs_struct = convertStructTo(vs_struct)
            % Transformation of a full structure (with 'ATTRIBUTE','CONTENT'
            % fields) into a basic structure
            %
            %    input:
            %      vs_struct: full xml structure
            %
            %    output:
            %      vs_struct: basic structure
            %
            vc_fieldnames=fieldnames(vs_struct);
            for i=1:length(vc_fieldnames)
                v_field=vc_fieldnames{i};
                if strcmp(v_field,'ATTRIBUTE')
                    vs_struct=rmfield(vs_struct,'ATTRIBUTE');
                    continue
                end
                if isstruct(vs_struct.(v_field))
                    if isfield(vs_struct.(v_field),'CONTENT')
                        if isfield(vs_struct.(v_field),'ATTRIBUTE')
                            if isfield(vs_struct.(v_field).ATTRIBUTE,'type') && strcmp(vs_struct.(v_field).ATTRIBUTE.type,'double')
                                % to numerical
                                vs_struct.(v_field)=str2double(vs_struct.(v_field).CONTENT);
                            else
                                vs_struct.(v_field)=vs_struct.(v_field).CONTENT;
                            end
                        else
                            vs_struct.(v_field)='';
                        end
                    else
                        % recursive call if ATTRIBUTE fields exist
                        vs_struct.(v_field)=xmlDocument.convertStructTo(vs_struct.(v_field));
                    end
                end
                if iscell(vs_struct.(v_field))
                    for icell=1:length(vs_struct.(v_field))
                        vs_struct.(v_field){icell}=xmlDocument.convertStructTo(vs_struct.(v_field){icell});
                    end
                end
            end
        end
    end
end
