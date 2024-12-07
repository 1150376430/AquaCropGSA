function tag_exists = F_exec_tag(dir_path,varargin)
%F_EXEC_TAG  Tag file management / status
%   tag_exists = F_exec_tag(dir_path,in_tag_name)
%  
%   INPUT(S): input arguments description
%      - dir_path: directory path
%      Optionnal: 
%      - in_tag_name: tag file name
%      - v_action : 'exist', 'delete'
%  
%   OUTPUT(S): output arguments description
%      - tag_exists: logical true if file exists, false otherwise
%  
%   CONTENT: function description
%  
%   CALLS: list of the called functions
%      - 
%  
%   EXAMPLE(S): use(s) case(s) example(s)
%      - 
%  
%  AUTHOR(S): P. Lecharpentier
%  DATE: 30-Sep-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu. 18 avril 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also fileDocument
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% defaults
tag_name='exec_done';
tag_exists=false;
status=false;
remove=false;
hidden=true;

vc_actions={'exist' 'delete' 'nohide'};

% Optionnal args.
if nargin>1
    for i=1:length(varargin)
        if ismember(varargin{i},vc_actions)
            if  strcmp('exist',varargin{i});
                status=true;
            end
            if strcmp('delete',varargin{i})
                remove=true;
            end
            if strcmp('nohide',varargin{i})
                hidden=false;
            end
        else
            tag_name=varargin{i};
        end
    end
end

if hidden
    if ispc
        tag_name=['_' tag_name];
    end
    if isunix
        tag_name=['.' tag_name];
    end
end

% file path & object
file_path=fullfile(dir_path,tag_name);
fobj=fileDocument(file_path);

% File deletion or existing status
if fobj.exist
    if remove
        fobj.delete;
    else
        tag_exists=true;
    end
    
% File creation if not exists
elseif ~status
    fobj.create(file_path);
    if hidden && ispc
        fobj.attrib('+h');
    end
end

