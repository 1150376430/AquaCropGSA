classdef fileDocument
	%FILEDOCUMENT Basic class for files manipulation
	%   Detailed explanation goes here  
    %   creation, copy, ....
	%
	%  MODIFICATIONS (last commit)
	%    $Date: 2013-11-14 14:06:42 +0100 (jeu., 14 nov. 2013) $
	%    $Author: sbuis $
	%    $Revision: 1009 $
	%
   properties
       Name='';
       Dir='';
       Ext='';
       Fid=-1;
   end
   
   methods(Static)
       
       function varargout = create(obj)
           % Creating an empty file
           %
           % 
           if isa(obj,'fileDocument')
               v_path=obj.getPath;
               v_exist=obj.exist;
           else
               v_path=obj;
               v_exist=exist(v_path,'file')>0;
           end
           %v_path=obj;
           if ~isempty(v_path) && ~v_exist
               v_cmd='';
               if isunix
                   v_cmd = ['touch ' v_path];
               elseif ispc
                   % dos('echo off');
                   if ~v_exist
                       v_cmd=['title > ' v_path];
                   else
                       v_cmd=['copy /b ' v_path '+,,'];
                   end
               end
             [v_stat,v_ret]=dos(v_cmd);
           end
           % voir si passage dans contition ?
           if nargout
              varargout{1}=fileDocument(obj); 
           end
       end
       
       function varargout = copy(obj,v_path,v_force)
           % Copying a file
           %
           % v_path: path of the destination file
           % v_force: logical value for forcing or not file copy
           %          optionnal: true , false (default)
           %
           %
           % See also: copyfile
           
           args={};
           % cp=false;
           cp=true;
           f=false;
           % Forcing file copy
           if nargin >2
               f=v_force;
           end
           if f
              args={'f'}; 
           end
           % Defining if the file can be copied
           % Pour l'instant idem comportement copyfile
           % qui ecrase les fichiers existants
%            if isdir(v_path) 
%                cp=true;
%            else
%                if ~exist(v_path,'file')
%                    cp=true;
%                else
%                    % disp('le fichier existe')
%                end
%            end
           % 
           if isa(obj,'fileDocument')
               src_path=obj.getPath;
               src_exist=obj.exist;
           elseif exist('v_path','var')
               src_path=obj;
               src_exist=exist(src_path,'file')>0;
           else
               src_path='';
               src_exist=false;
               F_create_message(src_path,...
                       sprintf('Copie de fichier impossible : \n%s','nom du fichier destination non fourni'),1,1);
   %            disp('Copie de fichier impossible ')
           end
           cp = cp | f;
           % Summary with forcing status
           if src_exist && cp
               try
                   copyfile(src_path,v_path,args{:});
               catch fileCopyError
                    F_create_message(src_path,...
                        sprintf('Copie du fichier %s vers %s impossible : \nprobleme de droits lecture/ecriture, fichier deja ouvert.',src_path,v_path),1,1,fileCopyError);
               end
              if f
                 % disp('fichier ecrase'); 
              end
           else
               F_create_message('Copie de fichier impossible',...
                       sprintf('Le fichier %s n''existe pas.',src_path),1,1);
           end     
           % on recupere l'objet fichier
           if nargout
              varargout{1}=fileDocument(v_path); 
           end
       end
       
       
       
   end

   methods
       function obj = fileDocument(v_path)
           % Constructor
           % 
           % v_path: absolute or relative file path
           %  (optionnal)
           if nargin
               if isa(v_path,'fileDocument')
                   obj = v_path;
               else
                   obj = obj.setPath(v_path);
               end
           end
       end
       
       function obj = setPath(obj,v_path)
           % Setting file path
           %
           
           if nargin>1
               obj = obj.setName(v_path);
           end
       end
       
       function obj = setName(obj,v_in_path)
           % Setting file name with extension, dir
           % 
           if ~ischar(v_in_path)
              error('File name or path is incorrect') 
           end
           [v_in_dir,v_in_name,v_in_ext]=fileparts(v_in_path);
           % if exists, not in local folder but in matlab path
           v_path=which(v_in_path);
           [v_dir,v_name,v_ext]=fileparts(v_path);
           
           if isempty(v_path)
              v_path=v_in_path; 
           end
           
           if ~strcmp([v_in_name v_in_ext],[v_name,v_ext])
                v_path=v_in_path;
           end
           
           if ~isempty(v_path)
               if strcmp('.',v_path)
                  v_path=pwd; 
               end
               [ obj.Dir ,obj.Name,v_ext ] = fileparts(v_path);
               if ~isempty(v_ext)
                  obj.Name=[obj.Name v_ext]; 
                  obj.Ext=v_ext;
               end
               if isempty(obj.Dir) 
                  obj.Dir=pwd;
               end
           end
       end

       
       
       function v_path = getPath(obj)
           v_path=fullfile(obj.Dir,obj.Name);
       end
	   
	   function v_ext = getExt(obj)
			v_ext = F_file_parts(obj.Name,'ext');
			if strcmp(v_ext(1),'.')
				v_ext=v_ext(2:end);
			end
	   end
       
       function vs_infos = getInfos(obj)
           % Retrieving file informations (size, date,...)
           %
           %        name: '..'
           %        date: '15-mai-2013 16:52:48'
           %       bytes: 0
           %       isdir: 1
           %     datenum: 7.3537e+05

           vs_infos = struct;
           if obj.exist
               vs_infos = dir(obj.getPath);
           end
       end
       
       function v_isdir = isdir(obj)
          v_isdir=obj.getInfos.isdir;
       end
       
       function v_size = size(obj)
           % Getting file size in bytes
           %
           if obj.isdir
               v_size = size(obj.getInfos,1)-2;
           else
               v_size = obj.getInfos.bytes;
           end
       end
       
       function v_date = date(obj)
           v_date = obj.getInfos.date;
       end
       
       function ismpty = isempty(obj)
           % Evaluating if the file size==0
           % or directory doesn't contain any files 
           
           if obj.exist
               ismpty = ~obj.size>0;
           end
           
       end
       

       
       % pour l'instant dans le sens set attributes
       function attrib(obj,attr_str)
           % Mofifying file attributes r/w...
           %
           
           if obj.exist
               fileattrib(obj.getPath,attr_str);
           end
       end
       
       function delete(obj,varargin)
           % File/dir deletion
           %
           
           if obj.exist
               try
                   switch obj.isdir
                       case false
                           delete(obj.getPath);
                       case true
                           rmdir(obj.getPath,varargin{:});
                   end
               catch deletionError
                   F_create_message(obj.getPath,...
                        sprintf('Suppression du fichier/repertoire %s impossible : \nprobleme de droits lecture/ecriture, fichier deja ouvert.',obj.getPath)...
                        ,1,1,deletionError);
               end
           end
       end
       
       function rdelete(obj)
          obj.delete('s'); 
       end
       
       function obj = open(obj,v_access_perm)
           % File opening
           % 
           % v_access_perm (optionnal)
           % file access permissions/type :  'a' 'w' 'r' 'a+' 'w+' 'r+' 
           % if not provided : 'r' (default)
           %
           % See also: F_file_open
           v_debug=false;
           
           v_args={};
           if nargin>1
              v_args={v_access_perm}; 
           end
           if ~obj.isOpen
               obj.Fid=F_file_open(obj.getPath,v_args{:});
               % obj.Open=true;
           end
           if v_debug
               F_disp([ obj.getPath ': ' num2str(obj.Fid) ])
               % 

           end

       end
       
       function isopen=isOpen(obj)
           isopen=any(obj.Fid==fopen('all'));
       end
       
       function obj=close(obj)
           % File closing
           %
           % See also: fclose
           
           c=0;
           if obj.isOpen
               try
                   c=fclose(obj.Fid);
               catch closingError
                  
                   F_create_message(obj.getPath,...
                       sprintf('Fermeture du fichier %s impossible ! \nprobleme de droits lecture/ecriture.',obj.getPath)...
                       ,1,1,closingError);
               end
           end
           if ~c
              % obj.Open=false; 
              obj.Fid=-1;
           end
       end
       
       function fcopy(obj,v_path)
           % Forced copy of a file
           %
           %  v_path: path of the destination file
           %
           fileDocument.copy(obj,v_path,true);
           
       end
       
   
       function copyNewer(obj,v_path)
           % Forced copy of a more recent file
           % 
           %  v_path: path of the destination file
           
           if obj.isNewer(v_path)
              obj.fcopy(v_path);
           end
       end
       
       

       
       %%
       % Voir pour move
       function obj=move(obj,v_path)
           %disp('move: not implemented');
           try
               movefile(obj.getPath,v_path);
               % 
               if isdir(v_path)
                   v_new_path=fullfile(v_path,[obj.Name obj.Ext]);
               else
                  v_new_path=v_path;
               end
               obj=obj.setPath(v_new_path);
           catch
               
           end
       end
       
       %% Voir pour rename
       % 
       function obj=rename(obj,v_path)
           %disp('rename: not implemented');
           obj=obj.move(v_path);
       end
       
       
       %%
       
       
       function resetDate(obj)
           % Resetting the last-modification file date
           %
           
           if obj.exist
              obj.create; 
           end
       end
       
       function v_datenum = dateNum(obj)
           % Retrieving a datenum-formated file date 
           %
           % v_datenum: file datenum (double) 
           
           v_datenum = NaN;
           vs_infos = obj.getInfos;
           if ~isempty(vs_infos) && isfield(vs_infos,'datenum')
               v_datenum=vs_infos.datenum;
           end
       end
       
       function v_newer = isNewer(obj,other)
           % Evaluating if the file has got a newer date than another one
           % other : fileDocument object or file path (char)
           %
           % v_newer: logical, true if newer, false otherwise
           
           v_newer = false;
           if obj.compareDatenum(other)>0
               v_newer = true;
           end
       end

       function v_older = isOlder(obj,other)
           % Evaluates if the file has a older date than another one
           % other : fileDocument object or file name/path (char)
           %
           % v_older: logical, true if older, false otherwise
           
           v_older = false;
           if obj.compareDatenum(other)<0
               v_older = true;
           end
       end

       function v_diff = compareDatenum(obj,other)
           % Files dates comparison
           % other : fileDocument object or file name/path (char)
           %
           % v_diff : dates difference, NaN otherwise,
           %          if other doesn't exist.
           %
           
           v_diff = NaN;
           if ~obj.exist
              return 
           end
           
           % other: file name/path or fileDocument object
           switch class(other)
               case 'char'
                   other_file = fileDocument(other);
               case 'fileDocument'
                   other_file = other;
               otherwise
                   return
           end
           if other_file.exist
               v_diff=obj.dateNum-other_file.dateNum;
           else
               v_diff=1;
           end
       end
       
       
       function v_exist = exist(obj)
           % Evaluating if file path exists
           %
           v_file_path=obj.getPath;
%            if isa(obj,'fileDocument')
%                v_file_path=obj.getPath;
%            else
%               v_file_path=obj; 
%            end
           v_exist = false;
           if ~isempty(v_file_path)
                v_exist = exist(v_file_path,'file')>0;
           end
       end 
       
       function print(obj,varargin)
           % Printing in file
           % no control about arguments done !
           % data to print : a string or more (as arguments)
           %
           v_args=varargin;
           try
               fprintf(obj.Fid,v_args{:});
           catch printingError
               F_create_message(obj.getPath,...
                       sprintf('Ecriture dans le fichier %s impossible ! \nprobleme de droits ecriture.',obj.getPath)...
                       ,1,1,printingError);
           end
       end
       
       function vc_output=scan(obj,v_format,varargin)
           % Scanning file content
           % v_format: format string for reading
           % and converting lines content
           if isempty(strfind(v_format,'%'))
               F_create_message(obj.getPath,...
                   sprintf('%s: le format de lecture pour le scan n''est pas correct ou n''est pas un format ! ',v_format)...
                   ,1,1);
           end
           v_args={v_format};
           if nargin>2
               v_args={v_args{:} varargin{:}};
           end
           
           if ~obj.isOpen
               obj=obj.open;
           end
           try
               vc_output=textscan(obj.Fid,v_args{:});
           catch scanError
               obj.close;
               F_create_message(obj.getPath,...
                   sprintf('Erreur de scan du fichier avec le format : %s  ',v_format)...
                   ,1,1,scanError);
           end
           obj.close;
           if length(vc_output)==1
               vc_output=vc_output{1};
           end
       end
       
       function line=getl(obj)
           % Getting one line from file
           if ~obj.isOpen
               F_create_message(obj.getPath,...
                   'Fichier non ouvert pour lecture !',1,1);
           end
           try
               line=fgetl(obj.Fid);
           catch getlError
               obj.close;
               F_create_message(obj.getPath,...
                   'Erreur de lecture du fichier !',1,1,getlError);
           end
       end
       
       function rewind(obj)
           % Rewind to the beginning of the file
           if ~obj.isOpen
               F_create_message(obj.getPath,...
                   'Fichier non ouvert pour lecture !',1,1);
           end
           try
               frewind(obj.Fid);
           catch rewError
               obj.close;
               F_create_message(obj.getPath,...
                   'Erreur de lecture du fichier !',1,1,rewError);
           end
           
       end
   end
   
   
end 
