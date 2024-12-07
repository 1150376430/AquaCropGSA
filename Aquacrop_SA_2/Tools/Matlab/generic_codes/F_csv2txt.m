function F_csv2txt(v_filename,v_ext)
%F_CSV2TXT    Transformation d'un fichier csv en fichier texte (sep. espace)
%   F_csv2txt(v_filename,v_ext)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_filename: nom du fichier csv
%      - v_ext: extension du fichier
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - 
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
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_csv2struct, F_struct2csv, F_file_parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2
   v_ext='.txt'; 
end
if v_ext(1)~='.'
    v_ext=['.' v_ext];
end

% Passage csv2struct
vs_struct=F_csv2struct(v_filename,';',1);

% Passage struct2csv, sep=' '
vs_parts=F_file_parts(v_filename);
% fichier de sortie
v_txt_filename=fullfile(vs_parts.dir,[vs_parts.name v_ext]);

% Generation du fichier texte
F_struct2csv(v_txt_filename,vs_struct,' ');

