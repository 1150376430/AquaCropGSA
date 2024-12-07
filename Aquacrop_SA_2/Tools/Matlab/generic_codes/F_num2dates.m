function v_out_dtnames = F_num2dates(v_first_year,v_dates_num,varargin)
%F_NUM2DATES  conversion de numeros de jour en dates 'jj/mm/aaaa'
%   v_out_dtnames = F_num2dates(v_first_year,v_dates_num)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_first_year : annee de reference (numerique ou char)
%      - v_dates_num : numero ou vecteur de numeros de jour
%      
%        
%   SORTIE(S): descriptif des arguments de sortie
%      - v_out_dtnames : dates ou liste de dates au format jj/mm/aaaa (cell)
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_convert_dates
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%  
%     - v_out_dtnum = F_num2dates(2007,451);
%        '27/03/2008'
%     - v_out_dtnum = F_num2dates(2007,[451 665]);
%     v_out_dtnum = 
%      {'27/03/2008' '27/10/2008'}
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 02-Mar-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%
% See also F_convert_dates, F_dates2num
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_args=varargin;
v_out_dtnames = F_convert_dates(v_first_year,v_dates_num,v_args{:});
if isempty(v_out_dtnames)
    v_out_dtnames={};
end
