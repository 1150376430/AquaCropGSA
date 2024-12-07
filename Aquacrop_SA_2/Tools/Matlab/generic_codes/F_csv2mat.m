function [v_data,vc_col_names]= F_csv2mat(v_csv_file,varargin)
%F_CSV2MAT  loading a csv file as a matlab matrix, column names
%   [v_data,vc_col_names] = F_csv2cell(v_csv_file[,v_header_size,...
%              v_format,v_header,v_delim])  
%  
%   ENTREE(S): 
%      - v_csv_file : csv file name
%      - optional
%           - v_header_size :  number of lines (if exist in file)
%           - v_format : formatting string for reading file lines (i.e
%              '%s%s%d%f' for example)
%           - v_header : string with column names (with delimiter)
%           - v_delim : delimiter (default value : ';')
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_data : data matrix
%      - vc_col_names: columns names
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
%    $Date: 2013-11-13 17:59:35 +0100 (mer., 13 nov. 2013) $
%    $Author: plecharpent $
%    $Revision: 1006 $
%  
% See also F_csv2struct, csvDocument, F_csv2cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin || ~ischar(v_csv_file)
   error('Missing or bad input argument!'); 
end
[vs_struct,csv]=F_csv2struct(v_csv_file,varargin{:});

if ~all(structfun(@isnumeric,vs_struct))
   error('All columns of csv files content must be of numerical type!')
end

[v_data,vc_col_names]=csv.toMat;



