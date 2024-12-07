function F_version()
%F_VERSION  One description line goes here
%   output_args = F_version(input_args)   Write here detailed input/ouput arguments list
%  
%   INPUT(S): input arguments description
%      - 
%  
%   OUTPUT(S): output arguments description
%      - 
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
%  DATE: 26-Nov-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu., 18 avr. 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also F_name1,...(linked/called functions, if none, remove this line)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
F_test_mfile_rev(mfilename,'$Revision: 993 $',true);

% getting version file from temp dir
version_file=fileDocument(fullfile(F_load_envpaths('temp'),'VERSION.txt'));

% 
if version_file.exist
    lines=version_file.scan('%s');
else
    F_create_message('The version is not available (installation is probably incorrect)', 'please execute F_startup function to fix it',1,1)
end
F_disp(' ')
F_disp([lines{1} ' ' lines{2} ':' ' Version ' lines{5} '(' lines{end} ')']);
F_disp(' ');
