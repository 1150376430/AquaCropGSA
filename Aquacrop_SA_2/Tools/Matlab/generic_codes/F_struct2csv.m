function exitval=F_struct2csv(v_csv_name,v_data,varargin)
% Genere un fichier csv a partir d'une structure de sequences
%   exitval = F_struct2csv(v_csv_name,v_data [,v_delimiter,v_format])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_csv_name: string, nom du fichier a exporter (.csv)
%      - v_data: structure de cell ou numerical array
%     Optionnel:
%      - v_delimiter: separateur de colonnes
%      - v_format: chaine de formatage a inserer en 2eme ligne dans le
%      fichier
%      - v_loc_overwrite:logical to overwrite file if true, or not if false
%      
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - exitval: flag de validite
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_data2csv
%   
%  AUTEUR(S): P. Lecharpentier
%  DATE: 30-Jan-2013
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-07-11 11:00:05 +0200 (jeu., 11 juil. 2013) $
%    $Author: plecharpent $
%    $Revision: 961 $
%  
%  
% See also F_cell2csv, F_user_input, struct2cell,csvDocument, F_csv2struct,
%   F_data2csv,F_struct2csv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<2
   error('Nombre d''arguments insuffisant') 
end

exitval=F_data2csv(v_csv_name,v_data,varargin{:});
