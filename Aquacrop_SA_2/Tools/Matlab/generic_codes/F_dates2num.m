function v_out_dtnum = F_dates2num(v_first_year,v_dates_names)
%F_DATES2NUM  conversion de dates 'jj/mm/aaaa' en numeros de jour 
%   v_out_dtnum = F_dates2num(v_first_year,v_dates_name)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_first_year : annee de reference (numerique ou char)
%      - v_dates_name : nom ou liste de noms de dates au format jj/mm/aaaa 
%       ou j/m/aaaa (cell)
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_out_dtnum : vecteur des numeros de jour
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_convert_dates
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%     - v_out_dtnum = F_dates2num(2007,'27/03/2008');
%        451
%      - v_out_dtnum = F_dates2num(2007,{'27/03/2008' '27/10/2008'});
%     v_out_dtnum = 
%         451   665
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 02-Mar-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_convert_dates, F_dates2num
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
v_out_dtnum = F_convert_dates(v_first_year,v_dates_names);



