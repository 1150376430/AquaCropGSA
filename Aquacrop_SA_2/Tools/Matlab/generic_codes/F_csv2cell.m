function vc_data = F_csv2cell(v_csv_file,varargin)
%F_CSV2CELL  loading a csv file as a matlab cell
%   vc_data = F_csv2cell(v_csv_file[,v_header_size,...
%              v_format,v_header,v_delim])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_csv_file : csv file name
%      - optional
%           - v_header_size :  number of lines (if exist in file)
%           - v_format : formatting string for reading file lines (i.e
%              '%s%s%d%f' for example)
%           - v_header : string with column names (with delimiter)
%           - v_delim : delimiter (default value : ';')
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - vc_data : data cell
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
%  DATE: 14-Feb-2013
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-02-18 11:35:14 +0100 (lun., 18 févr. 2013) $
%    $Author: plecharpent $
%    $Revision: 830 $
%  
% See also F_csv2struct, csvDocument, F_csv2Mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin || ~ischar(v_csv_file)
   error('Missing or bad input argument!'); 
end

[vs_struct,csv]=F_csv2struct(v_csv_file,varargin{:});

vc_data = csv.toCell;


