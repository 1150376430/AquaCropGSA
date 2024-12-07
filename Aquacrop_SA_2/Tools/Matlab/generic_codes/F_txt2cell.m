function vc_content = F_txt2cell(v_file_path,v_delimiter)
%F_TXT2CELL  Convert a text file to a cellstr
%   vc_content = F_txt2cell(v_file_path,v_delimiter)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_file_path: file name or path
%      Optional:
%      - v_delimiter: delimiter character
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - vc_content: cell of strings
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE CREATION: 04-Oct-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu. 18 avril 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also fileDocument, cellfun, textscan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loading file lines
vc_file_lines=fileDocument(v_file_path).scan('%s','delimiter','\n', 'whitespace', '');
% converting lines to cell
if exist('v_delimiter','var') % given delimiter
    vc_lines=cellfun(@(x) textscan(x,'%s','Delimiter',v_delimiter),vc_file_lines);
else % default delimiter (space, tab)
    vc_lines=cellfun(@(x) textscan(x,'%s','MultipleDelimsAsOne',true),vc_file_lines);
end
% initialization of output cell
cell_sz=[length(vc_lines) max(cellfun(@(x) max(size(x)),vc_lines))];
vc_content=cell(cell_sz);
% filling cell
for i=1:cell_sz(1)
   vc_content(i,1:length(vc_lines{i}))=vc_lines{i}; 
end