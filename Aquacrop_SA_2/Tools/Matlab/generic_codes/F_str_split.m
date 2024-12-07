function vc_output = F_str_split(input,delim)
%F_STR_SPLIT  splitting string according to delimiter position
%   output = F_str_split(input,delim)
%  
%   INPUT(S): input arguments description
%      - input: string
%      - delim: a string delimiter, i.e. any character
%  
%   OUTPUT(S): output arguments description
%      - vc_output: cell of string
%  
%   CONTENT: in resulting splitted strings,  leading and trailing
%               spaces are deleted
%  
%   CALLS: list of the called functions
%      - F_deblank
%  
%   EXAMPLE(S): use(s) case(s) example(s)
%      - F_str_split('time to go')
%      - F_str_split('Today, I'm leaving.',',')
%  
%  AUTHOR(S): P. Lecharpentier
%  DATE: 26-Apr-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu. 18 avril 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also strfind, F_deblank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vc_output={};
if ~nargin || ~ ischar(input)
    return
end
% default delimiter
delimiter=' ';

if nargin>1 && length(delim)==1
    delimiter=delim;
end

istart=1;
found_idx=strfind(input,delimiter);


while ~isempty(found_idx) && found_idx(1)==1
   input=input(2:end);
   found_idx=strfind(input,delimiter);
end

% if no delimiter found
if isempty(found_idx)
    if isempty(input)
        vc_output=input;
    else
        vc_output={input};
    end
    return
end

% string splitting
for i=1:length(found_idx)+1
    if i>length(found_idx)
        iend=length(input);
    else
        iend=found_idx(i)-1;
    end
    splitted_str=F_deblank(input(istart:iend));
    % eliminating empty string
    if isempty(splitted_str)
        continue
    end
    vc_output={vc_output{:} splitted_str};
    if i<=length(found_idx)
        istart=found_idx(i)+1;
    end
end
