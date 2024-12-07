classdef csvDocument < fileDocument
    % CSVDOCUMENT csv file manipulation/transformation class
    % - Matlab structure generation for delimited text files
    %
    %  MODIFICATIONS (last commit)
    %    $Date: 2013-11-13 18:07:56 +0100 (mer., 13 nov. 2013) $
    %    $Author: plecharpent $
    %    $Revision: 1007 $
    %
    % See also: fileDocument
    
    properties
        % fileDocument parent class attributes:
        % Name % file name
        % Dir % directory path
        % Fid  % file identifier
        % Open % file status
        %
        Content=struct; % structure generated from the csv file when loaded
        Delimiter='' % file delimiter for reading
        HeaderContent=''; % file header containing columns names (for struct fieldnames)
        HeaderColNumber=NaN;
        DataFormat=''; % format string for reading data lines
        FormatColNumber=NaN;
        LinesCount=NaN; % number of lines to be read
        DataFirstLine=1;
        StructType; % type of structure produced or loaded in Content: 'struct' or 'array'
    end
    
    properties(GetAccess=private,Constant=true)
        % Delimiters and structure types list
        DelimitersList={';',',',' ','\t'};
        StructTypes={'array','struct'};
        DataStringTypes={'data','header','format'};
    end
    
    methods
        function obj = csvDocument(v_path_or_struct,v_struct_type)
            % csvDocument Constructor
            %
            %  input: optionnal
            %    v_path_or_struct : name or path of a csv file or
            %    existing structure to import (struct, array)
            %    vs_struct_type: type of structure to build ('struct',
            %    'array')
            %
            %
            %  output: obj csvDocument object
            %
            in_path='';
            
            if nargin
                if ischar(v_path_or_struct)
                    in_path=v_path_or_struct;
                elseif isstruct(v_path_or_struct)
                    vs_struct=v_path_or_struct;
                end
            end
            
            
            obj = obj@fileDocument(in_path);
            
            if nargin>1
                if ischar(v_struct_type) && ismember(v_struct_type,csvDocument.StructTypes)
                    obj=obj.setStructType(v_type);
                else
                    disp('Unknown argument : type of structure')
                end
            end
            
            if exist('vs_struct','var')
                obj=obj.importStruct(vs_struct);
            end
        end
        
        function obj = setDelimiter(obj,v_delimiter)
            % setting Delimiter property value
            %
            % default value is set to ';'
            if nargin<1 || isempty(v_delimiter)
                obj.Delimiter=';';
                return
            end

            if ismember(v_delimiter,csvDocument.DelimitersList)
                obj.Delimiter=v_delimiter;
            else
                error([v_delimiter ' : is not a valid delimiter !'])
            end
        end
        
        function issetdelim=isSetDelimiter(obj)
            issetdelim=false;
            if ~isempty(obj.Delimiter)
                issetdelim=true;
            end
        end
        
        function [v_str,v_nb_cols] = readData(obj,v_position,v_kind)
            % csvDocument.readData: reading lines of 'format','header','data'
            % from the file for getting data format and number of columns to read
            %
            % input:
            %     v_position: line number
            %     v_kind: type of data ('format','header','data')
            %
            % output:
            %     v_str: data, header or formatting string
            %
            %     v_nb_cols: number of data columns detected in v_str
            %
            % See also: csvDocument.checkData
            %
            
            if nargin<2
                disp('Missing : position and kind of searched data !')
                return
            end
            if nargin<3
                disp('Missing argument : type of searched data !')
                return
            end
            % Format is inside the file
            obj = obj.open();
            for i=1:v_position
                v_line_content=obj.getl();
            end
            obj = obj.close();
            [v_str,v_nb_cols]=checkData(obj,v_line_content,v_kind);
        end
        
        function [v_out_str,v_cols_nb]=checkData(obj,v_in_data,v_kind)
            % csvDocument.checkData: get data string and columns number
            % for format,header,data kind
            %
            % input:
            %    v_in_data: data line string
            %    v_kind: type of data (formatting,header,data line)
            %
            % output:
            %    v_out_str: validated string (from v_in_data)
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.checkData
            %
            
            if ~ismember(v_kind,csvDocument.DataStringTypes)
                disp('Missing argument : type of searched data !')
                return
            end
            v_out_str='';
            v_blank=false;
             
            if obj.exist && ~obj.isSetDelimiter
               error('Delimiter must be specified!') 
            end
            
            % if delimiter==blank space, suppression of tab spaces
            if strcmp(' ',obj.Delimiter) || strcmp('\t',obj.Delimiter)
                v_in_data=strrep(v_in_data,sprintf('\t'),' ');
                v_blank=true;
            end

            switch v_kind
                case 'format'
                    v_data_nb=length(strfind(v_in_data,'%'));
                    if ~v_data_nb
                        error('Read or given format is not a valid formating string !');
                    end
                    if v_blank
                        vc_tmp = textscan(v_in_data,'%q','delimiter',obj.Delimiter,'MultipleDelimsAsOne', 1);
                        vc_tmp=vc_tmp{1};
                        v_cols_nb=length(vc_tmp);
                        v_out_str=sprintf('%s',vc_tmp{:});
                        if v_cols_nb==1 % if no delimiter between format strings !
                            vc_tmp=textscan(v_in_data,'%q','delimiter','%');
                            v_cols_nb=length(vc_tmp{1})-1;
                            v_out_str=v_in_data;
                        end
                    else % if delimiter is ; or ,
                        str_occur=strfind(v_in_data,obj.Delimiter);
                        if ~isempty(str_occur) % if delimiter
                            v_cols_nb=length(str_occur)+1;
                        else
                            v_cols_nb=v_data_nb;
                        end
                        v_out_str=v_in_data;
                    end
                    if v_cols_nb~=v_data_nb % missing a formatting string, or additionnal separator
                        error('Defined %s (in file or set manually) isn''t a formatting string! %s\n',...
                            v_kind,'Verify column separator (if not set, '';'' is being used)')
                    end
                    
                case {'header','data'}
                    v_delim_nb=strfind(v_in_data,obj.Delimiter);
                    if isempty(v_delim_nb)
                        error('The delimiter must be set or default one not found in file ('';'')')
                    end
                    
                    if isnumeric(v_in_data)
                        
                    elseif iscell(v_in_data)
                    elseif ischar(v_in_data)
                        v_data_nb=length(strfind(v_in_data,'%'));
                        if v_data_nb
                            error('Header content read or given is a formating string !');
                        end
                        % different treatments according to delimiters kind
                        % ';' ','
                        if strcmp(';',obj.Delimiter) || strcmp(',',obj.Delimiter)
                            vc_tmp = textscan(v_in_data,'%q','delimiter',obj.Delimiter);
                        else % ' ' '\t'
                            vc_tmp = textscan(v_in_data,'%q','delimiter',obj.Delimiter,'MultipleDelimsAsOne', 1);
                        end
                        v_cols_nb=length(vc_tmp{1});
                    end
                    v_out_str=v_in_data;
            end
        end
        
        function vc_data=stringToCell(obj,v_in_data,v_delimiter)
            if nargin<3
                % see case if delimiter is not set
                v_delimiter=obj.Delimiter;
            end
            
            if strcmp(';',v_delimiter) || strcmp(',',v_delimiter)
                vc_tmp = textscan(v_in_data,'%q','delimiter',v_delimiter);
            else % ' ' '\t'
                vc_tmp = textscan(v_in_data,'%q','MultipleDelimsAsOne', 1);
            end
            vc_data=vc_tmp{1}';
        end
        
        function [v_out_str,v_cols_nb]=checkDataFormat(obj,v_in_data)
            % csvDocument.checkDataFormat: check and get formatting string
            % and columns number
            %
            % input:
            %    v_in_data: format string
            %
            % output:
            %    v_out_str: validated formatting string
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.checkData
            %
            [v_out_str,v_cols_nb]=checkData(obj,v_in_data,'format');
        end
        
        function [v_out_str,v_cols_nb]=checkDataHeader(obj,v_in_data)
            % csvDocument.checkDataHeader: check and get header string
            % and columns number
            %
            % input:
            %    v_in_data: header string
            %
            % output:
            %    v_out_str: validated header string
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.checkData
            %
            [v_out_str,v_cols_nb]=checkData(obj,v_in_data,'header');
        end
        
        function [v_out_str,v_cols_nb]=checkDataContent(obj,v_in_data)
            % csvDocument.checkDataContent: check and get data string
            % and columns number
            %
            % input:
            %    v_in_data: data string
            %
            % output:
            %    v_out_str: validated data string
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.checkData
            %
            [v_out_str,v_cols_nb]=checkData(obj,v_in_data,'header');
        end
        
        function [v_header,v_nb_cols] = readDataHeader(obj,v_position)
            % csvDocument.readDataHeader: reading header string
            % and columns number
            %
            % input:
            %    v_position: line number to read
            %
            % output:
            %    v_header: header string
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.readData
            %
            [v_header,v_nb_cols] = readData(obj,v_position,'header');
        end
        
        
        function [v_format,v_nb_cols] = readDataFormat(obj,v_position)
            % csvDocument.readDataFormat: reading formatting string
            % and columns number
            %
            % input:
            %    v_position: line number to read
            %
            % output:
            %    v_format: formatting string
            %    v_nb_cols: number of data columns
            %
            %
            % See also: csvDocument.readData
            %
            [v_format,v_nb_cols] = readData(obj,v_position,'format');
        end
        
        
        function data_format = calcDataFormat(obj)
            % from an imported structure only ????
            % csvDocument.calcDataFormat: evaluating formatting string
            %
            % output:
            %    v_data_format: formatting string
            %
            % See also:
            %
            data_format='';
            if obj.isLoaded
                fnames=fieldnames(obj.Content);
                v_struct_type=obj.getStructType;
                for i=1:length(fnames)
                    if strcmp(v_struct_type,'array')
                        v_data=obj.Content(1).(fnames{i});
                    elseif strcmp(v_struct_type,'struct')
                        v_tmp=obj.Content.(fnames{i});
                        if iscell(v_tmp)
                            v_data=v_tmp{1};
                        else
                            v_data=v_tmp;
                        end
                    end
                    if isnumeric(v_data)
                        if strcmp(class(v_data),'double')
                            data_format=[data_format '%f'];
                        elseif ~isempty(strfind(class(v_data),'int'))
                            data_format=[data_format '%d'];
                        end
                    elseif ischar(v_data)
                        data_format=[data_format '%s'];
                    end
                end
            end
        end
        
        
        function data_header = calcDataHeader(obj)
            % from an imported structure
            % to keep or not ?????
            % useless to write a file !!!!
            data_header='';
            if obj.isLoaded
                fnames=fieldnames(obj.Content);
                data_header=sprintf([obj.Delimiter '%s'],fnames{:});
                data_header=data_header(2:end);
            end
            % see if intead of previous code if generation
            % of header columns string in setDataHeader can be moved here !
        end
        
        % ANALOGIE AVEC FORMAT / SIMPLIFIER GENERALISER METHODE
        % SETDATAHEADER
        function obj = setDataHeader(obj,v_header_or_position)
            % csvDocument.setDataHeader: setting header string
            % HeaderContent property
            %
            % input:
            %    v_header_or_position: line number to read
            %
            % See also:
            %
           
            if nargin<2 || isempty(v_header_or_position)
                if ~obj.exist && obj.isLoaded
                    % calcul du header a partir de la structure
                    v_header_or_position=obj.calcDataHeader();
                else
                    % calcul du header du fichier
                    [v_content,v_nb_delim]=obj.readDataHeader(obj.DataFirstLine);
                    v_header_or_position=arrayfun(@(x) {['COL' num2str(x) obj.Delimiter]},1:v_nb_delim);
                    v_header_or_position=[v_header_or_position{:}];
                    v_header_or_position=v_header_or_position(1:end-1);
                    % disp('Producing header (not specified) or missing line number in file!!')
                end
            end
            if isnumeric(v_header_or_position)
                [obj.HeaderContent,obj.HeaderColNumber] = obj.readDataHeader(v_header_or_position);
                % updating first data line to be read in the file
                obj.DataFirstLine=max(obj.DataFirstLine,v_header_or_position+1);
            elseif ischar(v_header_or_position)
                [obj.HeaderContent,obj.HeaderColNumber] = checkDataHeader(obj,v_header_or_position);
            end
            if obj.isSetDataFormat
                if obj.HeaderColNumber~=obj.FormatColNumber
                    error('Header content and format are not consistent (number of columns)!' )
                end
            end
        end
        
        
        function obj = setDataFormat(obj,v_format_or_position)
            % csvDocument.setDataFormat: setting formatting string
            % DataFormat property
            %
            % input:
            %    v_format_or_position: line number to read
            %
            % See also:
            %
            if nargin<2  || isempty(v_format_or_position)
                if ~obj.exist && obj.isLoaded
                    % calcul du format a partir de la structure
                    v_format_or_position=obj.calcDataFormat();
                else
%                     disp('Missing format or line number in file!')
%                     return
                    v_format_or_position=obj.evalDataFormat();
                end
            end
            if isnumeric(v_format_or_position)
                [obj.DataFormat,obj.FormatColNumber] = obj.readDataFormat(v_format_or_position);
                % updating first data line to be read in the file
                obj.DataFirstLine=max(obj.DataFirstLine,v_format_or_position+1);
            elseif ischar(v_format_or_position)
                [obj.DataFormat,obj.FormatColNumber] = checkDataFormat(obj,v_format_or_position);
            end
            if obj.isSetDataHeader
                if obj.HeaderColNumber~=obj.FormatColNumber
                    error('Header content and format are not consistent (number of columns)!' )
                end
            end
            % delimiters suppression and white spaces
            obj.DataFormat=strrep(strrep(obj.DataFormat,obj.Delimiter,''),' ','');
        end
        
        function issetformat=isSetDataFormat(obj)
            % csvDocument.isSetDataFormat: DataFormat property
            %
            % output:
            %    issetformat: logical, true if set, false instead
            %
            % See also:
            %
            issetformat=~isempty(obj.DataFormat);
        end
        
        function issetheader=isSetDataHeader(obj)
            % csvDocument.isSetDataHeader: HeaderContent property
            %
            % output:
            %    issetformat: logical, true if set, false instead
            %
            % See also:
            %
            issetheader=~isempty(obj.HeaderContent);
        end
        
        function vc_data = readFileData(obj)
            % csvDocument.readFileData: reading file content
            %
            % output:
            %    issetformat: logical, true if set, false instead
            %
            % See also: csvDocument.evalDataFormat
            %
            
            % csv
            vc_data={};
            if ~obj.exist
                error('File not found %s!',obj.getPath);
                return
            end
            % header is not present
            if isempty(obj.HeaderContent)
                disp('Header is missing: string or line number in file!');
                return
            end
            if isempty(obj.DataFormat)
                %disp('Format detection based on the first line of data in the file !');
                v_format_str = obj.evalDataFormat;
            else
                v_format_str=obj.DataFormat;
            end
            
            
            obj = obj.open();
            v_header_lines_nb=obj.DataFirstLine-1;
            % Reading file data by using v_format_str formatting string
            if strcmp(';',obj.Delimiter) || strcmp(',',obj.Delimiter) % lecture specifique avec separateur ; ,
                % ou autre separateur, et avec/sans header
                if v_header_lines_nb
                    vc_data = obj.scan(v_format_str,'Delimiter',obj.Delimiter,'HeaderLines',v_header_lines_nb);
                else
                    vc_data = obj.scan(v_format_str,'Delimiter',obj.Delimiter);
                end
            else
                if v_header_lines_nb
                    vc_data = obj.scan(v_format_str,'Delimiter',obj.Delimiter,...
                        'MultipleDelimsAsOne', 1,'HeaderLines',v_header_lines_nb);
                else
                    vc_data = obj.scan(v_format_str,'Delimiter',obj.Delimiter,'MultipleDelimsAsOne', 1);
                end
            end
            obj=obj.close();
            % control of cells size
            if size(unique(cellfun(@(x) length(x),vc_data)),2)>1
                error('Reading format is non consistent with file data (different kinds detected in a column) !');
            end
        end
        
        function v_format_str = evalDataFormat(obj)
            % csvDocument.evalDataFormat: formatting string evaluation from
            % a file data line
            %
            % output:
            %    v_format_str: evaluated formatting string from a file line
            %
            % See also: csvDocument.calcDataFormat
            %
            %
            
            obj = obj.open();
            v_header_lines_nb=obj.DataFirstLine-1;
            for i=1:v_header_lines_nb+1
                v_first_line_str= obj.getl();
            end
            % detection of a line of format
            percent_nb=strfind(v_first_line_str,'%');
            if ~isempty(percent_nb)
               ST = dbstack;
               error('Line %s of the file contains formatting strings.\n %s \nSet correctly input arguments of csvDocument calling function: %s to take it into account !',...
                   num2str(obj.DataFirstLine),v_first_line_str, ST(end).name)
            end
            obj = obj.close();
            
            if ~obj.isSetDelimiter
               error('Delimiter must be specified!') 
            end
            
            if strcmp(';',obj.Delimiter)  || strcmp(',',obj.Delimiter)
                vc_data = textscan(v_first_line_str,'%s',obj.HeaderColNumber,'delimiter',obj.Delimiter);
            else % espace ou tabulation
                vc_data = textscan(v_first_line_str,'%s',obj.HeaderColNumber,'MultipleDelimsAsOne', 1);
            end
            v_format_str='';
            for i=1:length(vc_data{1})
                if ~isnan(str2double(vc_data{1}{i}))
                    col_format = '%f';
                else
                    col_format = '%q';
                end
                v_format_str = [v_format_str col_format];
            end
            % if last column is empty!
            if length(vc_data{1})< obj.HeaderColNumber
                v_format_str = [v_format_str '%q'];
            end
        end
        
        function vs_content = toStruct(obj,v_type,vc_data,v_action_tag)
            % csvDocument.toStruct: structure generation from file or
            % alredady loaded struture in Content property
            %
            % input:
            %    v_type: type of structure (struct, array)
            %    vc_data: for data not provided in a file
            %    v_action_tag: for generation or conversion of a structure
            %
            % output:
            %    vs_content: structure generated
            %
            % See also: csvDocument.loadContent
            %
            %
            
            vc_actions_tags={'generate' 'convert'};
            if ~exist('v_type','var') || isempty(v_type)
                v_type='struct';
            end
            
            if ~exist('v_action_tag','var')
                v_action_tag='generate';
            end
            % if Content already loaded
            if obj.isLoaded && obj.isSetStructType && strcmp('convert',v_action_tag)
                vs_content=obj.convertContent(v_type);
                return
            end
            
            % else, read file
            vs_content=struct;
            if ~exist('vc_data','var')
                vc_data = obj.readFileData;
            end
            if isempty(obj.HeaderContent)
                return
            end
            if strcmp(';',obj.Delimiter) || strcmp(',',obj.Delimiter)
                vc_header_cell = textscan(obj.HeaderContent,'%q','delimiter',obj.Delimiter);
            else
                vc_header_cell = textscan(obj.HeaderContent,'%q','delimiter',obj.Delimiter,'MultipleDelimsAsOne', 1);
            end
            vc_header_cell = obj.strPurge(vc_header_cell{1});
            
            if length(vc_header_cell)~=length(vc_data)
                error('The number of identified columns is not consistent with the number\n%s\n%s',...
                    'of column names in the header string, verify the reading format or the header string content,',...
                    'or set manually the formatting string using the setDataFormat method');
            end
            % checking if header strings are unique
            if length(vc_header_cell)~=length(unique(vc_header_cell))
                error('Multiple names declaration in the header string !');
            end
            switch v_type
                case 'struct'
                    for i=1:length(vc_data)
                        if iscell(vc_data{i}) || isnumeric(vc_data{i})
                            vs_content.(genvarname(vc_header_cell{i}))=vc_data{i};
                        else
                            vs_content.(genvarname(vc_header_cell{i}))={vc_data{i}};
                        end
                    end
                case 'array'
                    if iscell(vc_data{1}) || isnumeric(vc_data{1})
                        imax=length(vc_data{1});
                    else
                        imax=1;
                    end
                    for i=1:imax
                        for j=1:length(vc_header_cell)
                            if isnumeric(vc_data{j})
                                vs_content(i).(genvarname(vc_header_cell{j}))=vc_data{j}(i);
                            elseif iscell(vc_data{j})
                                vs_content(i).(genvarname(vc_header_cell{j}))=vc_data{j}{i};
                            else
                                vs_content(i).(genvarname(vc_header_cell{j}))=vc_data{j};
                            end
                        end
                    end
            end
        end
        
        function obj = setStructType(obj,v_type)
            % csvDocument.setStructType: setting StructType property value
            %
            % input:
            %    v_type: type of structure (struct, array)
            %
            % See also:
            %
            
            
            if obj.isSetStructType && strcmp(obj.StructType,'v_type')
                return
            end
            if nargin<2 || isempty(v_type)
                v_type='struct';
            end
            if ~ismember(v_type,{'array','struct'})
                error([ v_type ': this type isn''t a structure type !'])
            end
            obj.StructType=v_type;
        end
        
        function issettype = isSetStructType(obj)
            % csvDocument.isSetStructType: evaluating if StructType
            % property value is set
            %
            % output:
            %    issettype: logical
            %
            % See also:
            %
            
            issettype=false;
            if ~isempty(obj.StructType)
                issettype=true;
            end
        end
        
        function v_type = getStructType(obj,vs_in_struct)
            % csvDocument.getStructType: getting StructType
            % property value
            %
            % output:
            %    v_type: type of structure (struct, array)
            %
            % See also:
            %
            % probably it can be moved to a static method !
            
            if nargin<2
                if ~obj.isLoaded
                    disp('Structure type can''t be identified, not loaded!' )
                    v_type='';
                    return
                else
                    vs_struct=obj.Content;
                end
            else
               vs_struct=vs_in_struct;
            end
            v_type='struct';
            if max(size(vs_struct))>1
                v_type='array';
            end
        end
        
        function v_lines_nb = size(obj)
            % csvDocument.size: getting number of data in structure fields
            %
            % output:
            %    v_lines_nb: number of data
            %
            % See also:
            %
            
            v_lines_nb=NaN;
            if obj.isLoaded
                switch obj.StructType
                    case 'array'
                        v_lines_nb=size(obj.Content,2);
                    case 'struct'
                        f=fieldnames(obj.Content);
                        v_lines_nb=size(obj.Content.(f{1}),1);
                end
            end
        end
        
        function obj = loadContent(obj,v_type)
            % csvDocument.loadContent: loading data structure in Content
            %
            % input:
            %    v_type: type of structure (array, struct)
            %
            % See also:
            %
            
            if ~exist('v_type','var')
                if obj.isSetStructType
                    v_type=obj.StructType;
                else
                    v_type='struct';
                end
            else
                if ~ischar(v_type)
                   return 
                end
            end
            obj.Content=obj.toStruct(v_type);
            obj=obj.setStructType(v_type);
            obj.LinesCount=obj.size;
        end
        
        function isstructloaded=isLoaded(obj)
            % csvDocument.isLoaded: evaluating if data structure loaded in Content
            %
            % output:
            %    isstrucloaded: logical
            %
            % See also:
            %
            
            isstructloaded=false;
            if ~isempty(fieldnames(obj.Content))
                isstructloaded=true;
            end
        end
        
        function obj = convertContent(obj,dest_struct_type)
            % csvDocument.convertContent: converting structure loaded in Content
            %
            % input:
            %    dest_struct_type: structure type
            %
            % See also:
            %
            
            if strcmp(dest_struct_type,obj.StructType)
                disp(['Content is already a ' dest_struct_type 'type!'])
                vs_content=obj.Content;
            end
            switch dest_struct_type
                case 'struct'
                    vs_content=obj.convertArrayToStruct(obj.Content);
                case 'array'
                    vs_content=obj.convertStructToArray(obj.Content);  
            end
            obj.Content=vs_content;
            obj=obj.setStructType(dest_struct_type);
        end
        
        function obj=importStruct(obj,vs_struct)
            % csvDocument.importStruct: importing existing structure in obj
            %
            % input:
            %    vs_struct: data structure
            %
            % See also:
            %
            
            obj.Content=vs_struct;
            % set Type
            obj=obj.setStructType(obj.getStructType);
            % set lines number
            obj.LinesCount=obj.size;
            %
%             obj=obj.setDataHeader;
            obj=obj.setDataFormat;
        end
        
        
        function [vs_struct,obj_sel] = selectContentData(obj,v_lines_or_values,v_fieldname)
            % csvDocument.selectContentData: selecting elements in structure
            %   Content
            %
            % input:
            %    v_lines_or_values: list of lines
            %    or 
            %    values to search, fieldname must be specified in v_fieldname
            % output:
            %    vs_struct: structure of selected data
            %    obj_sel: csvDocument object for selected data
            %
            % See also: csvDocument.getContentData
            %
            
            if nargin<3
                values_idx= findFieldValue(obj,v_lines_or_values);
            else
                values_idx= findFieldValue(obj,v_lines_or_values,v_fieldname);
            end
            
            vs_struct=struct;
            switch obj.StructType
                case 'struct'
                    for i=fieldnames(obj.Content)'
                        if iscell(obj.Content.(i{1})(values_idx)) || isnumeric(obj.Content.(i{1})(values_idx))
                            vs_struct.(i{1})=obj.Content.(i{1})(values_idx);
                        else
                            vs_struct.(i{1})={obj.Content.(i{1})(values_idx)};
                        end
                    end
                case 'array'
                    % isnumeric , iscell !!!!
                    disp('not implemented yet')
                    return
            end
            % returns a new csvDocument object for the selected elements
            if nargout>1
                obj_sel=csvDocument(vs_struct);
            end
            
        end
        
        function vs_struct=getContentData(obj,v_lines_or_values,varargin)
            % csvDocument.getContentData: getting elements from structure
            %   Content
            %
            % input:
            %    v_lines_or_values: list of lines
            %    or 
            %    values to search, fieldname must be specified as varargin
            % output:
            %    vs_struct: structure of selected data
            %
            % See also: csvDocument.selectContentData
            %
            
            vs_struct = selectContentData(obj,v_lines_or_values,varargin{:});
        end
        
        function v_out_value=getContentValue(obj,selectfieldname,v_lines_or_values,wantedfield)
            % csvDocument.getContentValue: getting values of a field from structure
            %   Content, or of another field
            %
            % input:
            %    selectfieldname: field into extract value for a line or to
            %    search a value (v_lines_or_values)
            %    v_lines_or_values: line or value of a field
            %    wantedfield: field from which values are extracted
            %  
            % output:
            %    v_out_value: values extracted
            %
            % See also: csvDocument.selectContentData
            %
            
            if strcmp(obj.StructType,'struct')
                if nargin<3
                    v_out_value=obj.Content.(selectfieldname);
                else
                    vs_struct = selectContentData(obj,v_lines_or_values,selectfieldname);
                    if nargin <4
                        v_out_value=vs_struct.(selectfieldname);
                    else
                        v_out_value=vs_struct.(wantedfield);
                    end
                end
            else
                disp('Not implemented yet for struct array!')
            end
        end
        
        function obj=plus(obj,v_other)
            % overloading addition
            %
            % v_other: csvDocument,structure
            % identical fieldnames, data type
            switch class(v_other)
                case 'csvDocument'
                    obj=addContentData(obj,v_other);
                case 'struct'
                    disp('adding structure to csvDocument not implemented yet');
                    
            end
        end
        
        function vs_out_struct=addStruct(obj,vs_struct_one,vs_struct_two)
            % Structure addition 
            
            vs_out_struct=struct;
            if ~nargin
                error('No enough argument !')
            end
            if nargin>1
                vs_struct1=vs_struct_one;
                isstruct1=isstruct(vs_struct_one);
            end
            if nargin>2
                vs_struct2=vs_struct_two;
                isstruct2=isstruct(vs_struct_two);
            end
            if (exist('vs_struct1','var') && ~isstruct1) || ...
                    (exist('vs_struct2','var') && ~isstruct2)
                error('At least one of the arguments is not a structure !');
            end
            
            if ~exist('vs_struct2','var')
                vs_struct1=obj.Content;
                vs_struct2=vs_struct_one;
            end
            if ~strcmp(obj.getStructType(vs_struct1),obj.getStructType(vs_struct2))
               error('structure are not of the same type !') 
            end
            if ~isempty(setdiff(fieldnames((vs_struct1)),fieldnames(vs_struct2)))
                error('List of field names is not the same for the two structures !')
            end
            
            vc_fnames=fieldnames(vs_struct1);
            for ifield=1:length(vc_fnames)
                fname=vc_fnames{ifield};
                
                switch obj.StructType
                    case 'struct'
                        if isnumeric(vs_struct2.(fname))
                            vs_struct1.(fname)=[vs_struct1.(fname) ; vs_struct2.(fname)];
                        elseif ischar(vs_struct2.(fname))
                            if iscell(vs_struct1.(fname))
                                vs_struct1.(fname)={vs_struct1.(fname){:} ; vs_struct2.(fname)};
                            else
                                vs_struct1.(fname)={vs_struct1.(fname) ; vs_struct2.(fname)};
                            end
                        else
                            vs_struct1.(fname)={vs_struct1.(fname){:}  vs_struct2.(fname){:}}';
                        end
                    case 'array'
                        vs_struct1(obj.LinesCount).(fname)=vs_struct2.(fname);
                end
            end
            vs_out_struct=vs_struct1;
        end
        
        function obj=addContentData(obj,varargin)
            % csvDocument.addContentData: adding elements to structure
            %   Content
            %
            % input: varargin
            %     string containing data to add (with delimiter,consistent
            %     values according to formatting string set in DataFormat)
            %     cell of values 
            %     argument list (comma separated)
            %     object !!!
            %   
            % See also: 
            %
            
            if ~obj.isSetDataHeader || ~obj.isSetDataFormat || ~obj.isSetStructType
                error('Headers are not set for providing struct field names %s\n',...
                    'or data format is not set or structure type is not defined !')
            end
            
            % cell or arg list
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ATTENTION : actually only a dataset for one record in treated
            % !
            % potentially could be done for one or several data set
            % so args could be
            %     cell of data: {[1 2 3] {'name1 name2 name3'} {surname1
            %     surname2 surname3}}
            %     cell of char : {'1;name1;surname1' '2;name2;surname2'
            %                     '3;name3;surname3'}
            %
            % POTENTIALLY : structure, see addition overloading returning 
            %               structure or object !!!
            % 
            %     etc....
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            switch nargin
                case 1
                    error('No data given as argument !')
                case 2
                    % a data argument
                    if iscell(varargin{1})
                        nb_elt=max(size(varargin{1}));
                        vc_data=varargin{1};
                        input_type='cell';
                    elseif ischar(varargin{1})
                        [data_str,nb_elt]=obj.checkDataContent(varargin{1});
                        vc_data=textscan(data_str,obj.DataFormat,'Delimiter',obj.Delimiter);
                        input_type='char';
                    elseif isa(varargin{1},'csvDocument')
                        if ~strcmp(obj.HeaderContent,varargin{1}.HeaderContent)
                           error('HeaderContent of csvDocument object given as argument is different, adding data aborted !')
                        end
                        if ~strcmp(obj.DataFormat,varargin{1}.DataFormat)
                           error('DataFormat of csvDocument object given as argument is different, adding data aborted !')
                        end
                        vs_content=varargin{1}.Content;
                        nb_elt=varargin{1}.FormatColNumber;
                    end
                otherwise
                    nb_elt=nargin-1;
                    vc_data=varargin;
                    input_type='arguments list';
            end
            
            
            if nb_elt~=obj.FormatColNumber
                error('Elements provided in %s are not enough numerous:\n %d values are expected !',...
                    input_type,obj.FormatColNumber)
            end
            
            if isempty(fieldnames(obj.Content)) || isnan(obj.LinesCount) % only one condition is normally usefull
                obj.LinesCount=0;
            end
            if ~exist('vs_content','var') % vc_data calculated
                vs_content=obj.toStruct(obj.StructType,vc_data);
                obj.LinesCount=obj.LinesCount+size(vc_data,1);
            else % vs_content got from csvDocument object
                obj.LinesCount=obj.LinesCount+varargin{1}.LinesCount;
            end
            
            if obj.LinesCount==1
                obj.Content=vs_content;
            else
                obj.Content=obj.addStruct(vs_content);
            end
        end
        
        function obj=modifyContentData(obj)
            disp('not implemented yet')
        end
        
        function [valueexists,vc_value_logical_idx]= existFieldValue(obj,vc_values,v_field_name)
            % csvDocument.existFieldValue: evaluating if values exist for a field in structure
            %   Content
            %
            % input: 
            %    vc_values: values of fieldname if v_field_name is
            %    provided, indexes instead
            %    v_field_name: field name into values are to be search
            %
            % output:
            %    valueexists: logical array
            %    vc_value_logical_idx: cel of logical array
            %   
            % See also: csvDocument.findFieldValue
            %
            
            vc_value_logical_idx = {};
            valueexists=false;
            if nargin<2
                disp('Specify  values to search or index at least!')
                return
            end
            
            if ~obj.isLoaded
                disp('File content is not loaded!')
                return
            end
            
            if nargin<3
                if ~isnumeric(vc_values)
                    disp('If the fieldname is not given, vc_values must be integers (indexes)!')
                    return
                end
                
                switch obj.StructType
                    case 'array'
                        nb_elt=size(obj.Content,2);
                        
                    case 'struct'
                        fnames=fieldnames(obj.Content);
                        nb_elt=max(size(obj.Content.(fnames{1})));
                end
                
                vc_value_logical_idx=arrayfun(@(x) {x==1:nb_elt},vc_values);
                valueexists=cellfun(@(x) any(x),vc_value_logical_idx);
                if length(vc_value_logical_idx)==1
                    vc_value_logical_idx=vc_value_logical_idx{1};
                    valueexists=valueexists(1);
                else
                    % vc_value_logical_idx
                end
                return
            end
            
            if ~isfield(obj.Content,v_field_name)
                disp([ v_field_name ' : field is missing'])
                return
            end
            if ischar(vc_values);
                vc_values={vc_values};
            end
            switch obj.StructType
                case 'array'
                    if isnumeric(obj.Content(1).(v_field_name))
                        v_field_content=[obj.Content.(v_field_name)]';
                    elseif ischar(obj.Content(1).(v_field_name))
                        v_field_content={obj.Content.(v_field_name)}';
                    else
                        
                    end
                case 'struct'
                    v_field_content=obj.Content.(v_field_name);
            end
            v_type='char';
            if isnumeric(vc_values) && isnumeric(v_field_content)
                v_type='numeric';
            elseif any(iscell(vc_values) && isnumeric(v_field_content)) ||...
                    any(isnumeric(vc_values) && iscell(v_field_content))
                disp('Searched values type is not consistent with the structure field one!')
                return
            end
            vc_value_logical_idx=cell(length(vc_values),1);
            valueexists=false(length(vc_values),1);
            for i=1:length(vc_values)
                switch v_type
                    case 'char'
                        tmp=ismember(v_field_content,vc_values{i});
                    case 'numeric'
                        tmp=vc_values(i)==v_field_content;
                end
                vc_value_logical_idx{i}=tmp;
                valueexists(i)=any(tmp);
            end
            if length(vc_value_logical_idx)==1
                vc_value_logical_idx=vc_value_logical_idx{1};
                valueexists=valueexists(1);
            end
        end
        
        function vc_idx = findFieldValue(obj,vc_values,v_field_name)
            % csvDocument.findFieldValue: find indexex of values in a field in structure
            %   Content
            %
            % input: 
            %    vc_values: values of fieldname if v_field_name is
            %    provided, indexes instead
            %    v_field_name: field name into values are to be search
            %
            % output:
            %    vc_idx: cell of index of values 
            %   
            % See also: csvDocument.existFieldValue
            
            %
            if nargin<3
                [valueexists,vc_value_logical_idx]= obj.existFieldValue(vc_values);
            else
                [valueexists,vc_value_logical_idx]= obj.existFieldValue(vc_values,v_field_name);
            end
            if iscell(vc_value_logical_idx)
                vc_idx=cell2mat(cellfun(@(x) {find(x)},vc_value_logical_idx));
            else
                vc_idx=find(vc_value_logical_idx);
            end
        end
        
        function writeToFile(obj,varargin)
            % csvDocument.writeToFile: write Content to a file 
            %
            % input: 
            %   v_file_path: file name or path
            %   v_format_string_or_logical: formatting string or logical==1
            %   for including format in file header
            %
            %  See also : csvDocument.toCsvFile
            
            if obj.isLoaded
                
                if ~isempty(varargin)
                    for i=1:length(varargin)
                        if ischar(varargin{i}) && ~isempty(strfind(varargin{i},'%'))
                            v_format_sl=varargin{i};
                        elseif ischar(varargin{i}) && length(varargin{i})==1
                            if ismember(varargin{i},csvDocument.DelimitersList)
                               v_delimiter=varargin{i}; 
                            end
                        elseif isnumeric(varargin{i}) || islogical(varargin{i})
                            v_format_sl=logical(varargin{i});
                        else
                            v_path=varargin{i};
                        end
                    end
                end
                if ~exist('v_path','var')
                    v_path=obj.getPath;
                end
                if exist('v_format_sl','var')
                    if islogical(v_format_sl)
                        v_format_sl=obj.DataFormat;
                    end
                else
                    v_format_sl='';
                end
                if exist('v_delimiter','var')
                    if obj.isSetDelimiter
                       v_delimiter=obj.Delimiter; 
                    end
                else
                    error('Delimiter must be specified (as argument) or set in csvDocument object!')
                end
                
                obj.toCsvFile(obj.Content,v_path,v_delimiter,v_format_sl);
            else
                disp('Content : structure is empty');
                if obj.exist
                    disp(['Failed to generate file: structure was not loaded from file !' obj.getPath]);
                else
                    disp('Failed to generate file: structure was not imported/or generated !');
                end
            end
        end
        
        function [v_out_mat,vc_col_names]  = toMat(obj)
           [v_out_mat,vc_col_names]  =  obj.convertStructToMat(obj.Content);
        end
        
        function vc_out_cell = toCell(obj)
           vc_out_cell =  obj.convertStructToCell(obj.Content);
        end
    end
    
    
    methods(Static)
        function vc_str_list = strPurge(vc_str_list)
            if ischar(vc_str_list)
                vc_str_list={vc_str_list};
            end
            for i=1:length(vc_str_list)
                v_str = vc_str_list{i};
                v_str = strrep(v_str,'"','');
                v_str = strrep(v_str,'''','');
                v_str = strrep(v_str,',','_');
                v_str = strrep(v_str,';','_');
                v_str = strrep(v_str,':','_');
                v_str = strrep(v_str,'.','_');
                v_str = strrep(v_str,' ','_');
                v_str = strrep(v_str,' ','_');
                v_str = strrep(v_str,'#','_no_');
                v_str = strrep(v_str,'�','c');
                v_str = strrep(v_str,'�','a');
                v_str = strrep(v_str,'�','a');
                v_str = strrep(v_str,'�','a');
                v_str = strrep(v_str,'�','e');
                v_str = strrep(v_str,'�','e');
                v_str = strrep(v_str,'�','e');
                v_str = strrep(v_str,'�','e');
                v_str = strrep(v_str,'�','o');
                v_str = strrep(v_str,'�','o');
                v_str = strrep(v_str,'�','u');
                v_str = strrep(v_str,'�','u');
                v_str = strrep(v_str,'�','u');
                v_str = strrep(v_str,'(','_');
                v_str = strrep(v_str,')','_');
                v_str = strrep(v_str,'=','_');
                v_str = strrep(v_str,'+','_');
                v_str = strrep(v_str,'-','_');
                v_str = strrep(v_str,'*','_');
                v_str = strrep(v_str,'/','_');
                v_str = strrep(v_str,'\','_');
                v_str = strrep(v_str,'{','_');
                v_str = strrep(v_str,'}','_');
                v_str = strrep(v_str,'|','_');
                v_str = strrep(v_str,'[','_');
                v_str = strrep(v_str,']','_');
                v_str = strrep(v_str,'!','_');
                v_str = strrep(v_str,'?','_');
                v_str = strrep(v_str,'!','_');
                v_str = strrep(v_str,'>','_');
                v_str = strrep(v_str,'<','_');
                v_str = strrep(v_str,'%','_');
                % Elimination des _ en debut et en fin de chaine
                v_str = F_dehead(v_str);
                v_str = F_detrail(v_str);
                vc_str_list{i}=v_str;
            end
        end
        
        function vs_out_struct = convertStructToArray(vs_struct)
            % csvDocument.convertArrayToStruct: converting a structure 
            % to a structure array 
            %
            % input: 
            %   vs_struct: data structure
            %
            % See also: csvDocument.convertArrayToStruct
            %
            
            vs_out_struct=struct;
            vc_fnames=fieldnames(vs_struct);
            for i=1:length(vs_struct.(vc_fnames{1}))
                for j=1:length(vc_fnames)
                    fname=vc_fnames{j};
                    if i==1
                        v_str_left=['vs_out_struct.(''' fname ''')='];
                    else
                        v_str_left=['vs_out_struct(' num2str(i) ').(''' fname ''')='];
                    end
                    if iscell(vs_struct.(fname))
                        v_str2eval=[v_str_left 'vs_struct.(''' fname '''){' num2str(i) '};'];
                    elseif isnumeric(vs_struct.(fname))
                        v_str2eval=[v_str_left 'vs_struct.(''' fname ''')(' num2str(i) ');'];
                    end
                    eval(v_str2eval);
                end
            end
        end
        
        function vs_out_struct = convertArrayToStruct(vs_struct)
            % csvDocument.convertArrayToStruct: converting a structure array
            % to a structure
            %
            % input: 
            %   vs_struct: data structure
            %
            % See also: csvDocument.convertStructToArray
            %
            
            if size(vs_struct,2)==1
                vs_out_struct=vs_struct;
                return
            end
            vs_out_struct=struct;
            vc_fieldnames=fieldnames(vs_struct);
            for i=1:length(vc_fieldnames)
                switch class(vs_struct(1).(vc_fieldnames{i}))
                    case 'char'
                        vs_out_struct.(vc_fieldnames{i})={vs_struct.(vc_fieldnames{i})};
                    otherwise
                        vs_out_struct.(vc_fieldnames{i})=[vs_struct.(vc_fieldnames{i})];
                end
            end
        end
        
        function [v_out_mat,vc_col_names] = convertStructToMat(vs_struct)
            if ~all(structfun(@isnumeric,vs_struct))
                error('All columns of csv files content must be of numerical type!')
            end
            
            vc_col_names=fieldnames(vs_struct)';
            
            ncols=length(vc_col_names);
            nlines=length(vs_struct.(vc_col_names{1}));
            v_out_mat=NaN(nlines,ncols);
            
            for col=1:ncols
                for line=2:nlines
                    v_out_mat(:,col)=vs_struct.(vc_col_names{col});
                end
            end
            
        end
        
        function vc_out_cell = convertStructToCell(vs_struct)
            vc_tmp=struct2cell(vs_struct);
            ncols=size(vc_tmp,1);
            nlines=size(vc_tmp{1},1)+1;
             vc_out_cell=cell(nlines,ncols);
            
             vc_out_cell(1,:)=fieldnames(vs_struct)';
            for col=1:ncols
                for line=2:nlines
                    if iscell(vc_tmp{col}(line-1))
                         vc_out_cell{line,col}=vc_tmp{col}{line-1};
                    else
                         vc_out_cell{line,col}=vc_tmp{col}(line-1);
                    end
                end
            end
            
        end
        
        
        function toCsvFile(vs_struct,v_file_path,v_delimiter,v_format)
            % csvDocument.writeToFile: write a structure to a file
            %
            % input: 
            %   vs_struct: data structure
            %   v_file_path: file name or path
            %   v_delimiter: column delimiter
            %   v_format_string: formatting string for the file reading
            %
            %  See also : csvDocument.writeToFile
            %
            
            if nargin<3
               error('Not enough input arguments, 3 are required')
            end
            
            if nargin<4
                v_format='';
            end
            
            if size(vs_struct,2)>1
                vs_struct=csvDocument.convertArrayToStruct(vs_struct);
            end
            % Actually not included as a class method
            F_struct2csv(v_file_path,vs_struct,v_delimiter,v_format);
        end
    end
end