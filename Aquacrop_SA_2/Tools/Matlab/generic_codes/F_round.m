function x = F_round(x,dim)
% Arrondit un nombre a un certain nombre de decimales
%   x = F_round(x,dim)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - x: nombre a arrondir, type double
%      - dim: decimale de 10 pour arrondissement (ex:-2 pour les centiemes)
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - x: nombre arrondit
%  AUTEUR(S): J. Bourges
%  DATE: 17-Mar-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_calc_cristat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = round(x*(10^(fix(-dim))))/(10^(fix(-dim)));
