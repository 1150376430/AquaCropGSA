function F_txt2csv(v_filename,varargin)
%F_TXT2CSV  Transformation d'un fichier texte (sep. espace) en fichier csv
%   F_txt2csv(v_filename)  
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_filename: nom de fichier au format texte, separateur espace
%
%     Optionnel:
%      - v_loc_overwrite:logical to overwrite file if true, or not if false
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - fichier au format csv : separateur ;
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
%  DATE: 23-Feb-2012
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-07-11 11:00:05 +0200 (jeu., 11 juil. 2013) $
%    $Author: plecharpent $
%    $Revision: 961 $
%  
%  
% See also F_csv2struct, F_struct2csv, F_file_parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_ext='.csv'; 
% Passage csv2struct
vs_struct=F_csv2struct(v_filename,' ',1);

% Passage struct2csv, sep=' '
vs_parts=F_file_parts(v_filename);
% fichier de sortie
v_csv_filename=fullfile(vs_parts.dir,[vs_parts.name v_ext]);

% Generation du fichier texte
F_struct2csv(v_csv_filename,vs_struct,';',varargin{:});
