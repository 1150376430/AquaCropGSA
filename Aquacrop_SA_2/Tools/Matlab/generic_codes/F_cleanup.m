function cu_obj = F_cleanup(v_type,v_ressource)
%F_CLEANUP  Ending safely function execution, interrupt
%   cu_obj = F_cleanup(v_type,v_ressource)
%  
%   INPUT(S): input arguments description
%      - v_type: action keyword
%      - v_ressource : needed by action
%  
%   OUTPUT(S): output arguments description
%      - cu_obj: onCleanup object or actions list (if no input args)
%  
%   CONTENT: function description
%  
%   CALLS: list of the called functions
%      - 
%  
%   EXAMPLE(S): use(s) case(s) example(s)
%      - obj = F_cleanup('cd',pwd)
%      - obj = F_cleanup('close',fid)
%  
%  AUTHOR(S): P. Lecharpentier
%  DATE: 20-Jun-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu. 18 avril 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also onCleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Actions label
v_types={'cd' 'close' 'delete'};
% if no args
if ~ nargin
    cu_obj=v_types;
    return
end

switch v_type
    case 'cd' % change current directory
        cu_obj=onCleanup(@()cd(v_ressource));
    case 'close' % close file(s)
        cu_obj=onCleanup(@()fclose(v_ressource));
    case 'delete' % delete file(s)
        cu_obj=onCleanup(@()delete_files(v_ressource));
    otherwise % do nothing
        cu_obj=onCleanup(@()disp(['Nothing to do, unknown action for clean up : ' v_type]));
end
end



function delete_files(vc_files)
if ischar(vc_files)
    vc_files={vc_files};
end
% Existing files selection
v_sel=cellfun(@(x) exist(x,'file'),vc_files)>0;
if any(v_sel)
    vc_files=vc_files(v_sel);
    delete(vc_files{:});
end

end