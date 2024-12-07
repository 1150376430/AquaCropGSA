function varargout = F_rdir(v_inputdir,vs_out_rdir)
%F_RDIR  Recursive dir function
%   vs_out_rdir = F_rdir(v_inputdir,vs_out_rdir)
%  
%   ENTREE(S):
%      - optionnal:
%         v_inputdir : dir name or pathnames,
%         wildcards may be used.
%         vs_out_rdir : existing structure of the same type as decribed in
%         outputs (for concatenation)
%  
%   SORTIE(S): 
%      - vs_out_rdir : structure array with fields
%       name: file name
%        date: last modification date
%       bytes: size
%       isdir: true or false (if file name is a directory)
%     datenum: datenum format of date
%         dir: path of the parent directory
%   
%   CONTENU: 
%  
%   APPEL(S): liste des fonctions appelees
%      - dir
%      - F_file_parts
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      F_rdir('*.m') lists all program files
%    in the current directory and all his subdirectories
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 30-Jul-2012
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
% See also dir, F_file_parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin
    v_inputdir=pwd;
end

% dir depart
start_dir=pwd;

% Initialisation wildcards
v_wildcards_filter='*';
vs_parts=F_file_parts(v_inputdir);
% A REVOIR POUR '?' ne semble pas marcher dans Matlab
if any(cell2mat(cellfun(@(x) {strfind([vs_parts.name vs_parts.ext],x)},{'*','?'})))
   down_inputdir=vs_parts.dir;
   if isempty(down_inputdir)
      down_inputdir=pwd; 
   end
   v_wildcards_filter=[vs_parts.name vs_parts.ext];
else
    down_inputdir=v_inputdir;
end

cd(down_inputdir);
v_cur_dir=pwd;
vs_dir=dir();
vc_filter_list=dir(v_wildcards_filter);
vc_filter_list={vc_filter_list.name};
for i=1:length(vs_dir)
    if any(strcmp(vs_dir(i).name,{'.','..'}))
        continue
    end
    % add full path to list cell
    if ismember(vs_dir(i).name,vc_filter_list)
        j=1;
        if exist('vs_out_rdir','var')
            j=length(vs_out_rdir)+1;  
        end
        vs_tmp=vs_dir(i);
        vs_tmp.dir=v_cur_dir;
        vs_out_rdir(j)=vs_tmp;
    end
    % recursion in subdir
    if vs_dir(i).isdir
        if exist('vs_out_rdir','var')
            vs_out_rdir=F_rdir(fullfile(vs_dir(i).name,v_wildcards_filter),vs_out_rdir);
        else
            vs_out_rdir=F_rdir(fullfile(vs_dir(i).name,v_wildcards_filter));
        end
    end
end

cd(start_dir);

if ~exist('vs_out_rdir','var')
    vs_out_rdir=struct;
    F_disp([vs_parts.name vs_parts.ext ' not found.']);
end

if nargout
    varargout{1}=vs_out_rdir;
else
    if ~isempty(fieldnames(vs_out_rdir))
        for ifile=1:length(vs_out_rdir)
           F_disp(fullfile(vs_out_rdir(ifile).dir, vs_out_rdir(ifile).name));
        end
    end
end