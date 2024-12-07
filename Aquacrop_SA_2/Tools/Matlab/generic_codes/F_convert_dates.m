function v_out_dates = F_convert_dates(v_first_year,v_dates,varargin)
%F_CONVERT_DATES  conversion date <-> numero de jour
%   v_out_dates = F_convert_dates(v_first_year,v_dates[,v_vec])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_first_year : annee de reference (numeric)
%      - v_dates : dates ou liste de dates (format jj/mm/aaaa), numeros ou
%      vecteur de numeros de jour
%      - optionnel v_vect : 1 pour sortie des dates en vecteurs
%      annee,mois,jour, 0 sinon (valeur pas defaut)
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_out_dates : numeros ou vecteur de numeros de jour ou  dates ou
%      liste de dates (char) au format jj/mm/aaaa
%
%   CONTENU: descriptif de la fonction
%  
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      utilisee a travers les fonctions F_dates2num, F_num2dates
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
% See also F_dates2num, F_num2dates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% affectation valeur v_vect
v_vect=0;
if nargin==3 && (isnumeric(varargin{1}) || islogical(varargin{1}))
    v_vect=varargin{1};
end
%
if ischar(v_dates)
    v_out_dates=F_date2num(v_first_year,v_dates);
elseif iscellstr(v_dates)
    v_out_dates=cellfun(@(x) F_date2num(v_first_year,x),v_dates);
elseif isnumeric(v_dates)
    if ~isa(v_dates,'double')
        v_dates=double(v_dates);
    end
    v_out_dates=arrayfun(@(x) F_num2date(v_first_year,x,v_vect),v_dates,'UniformOutput',false);
else
    disp('La variable contenant les dates n''est pas du bon type');
    v_out_dates=[];
end
% transformation en matrice si on demande les vecteurs de dates
if ~iscellstr(v_out_dates) && iscell(v_out_dates)
    v_out_dates=cell2mat(v_out_dates');
end
    
function v_date = F_num2date(v_first_year,v_date_num,v_vect)
v_first_day_month='01/01/';
v_first_day_num=datenum([v_first_day_month num2str(v_first_year)]);
v_last_day_num=v_first_day_num+v_date_num-1;
if v_vect
    v_date=datevec(v_last_day_num);
    v_date=v_date(:,1:3);
else
    v_date=datestr(v_last_day_num,'dd/mm/yyyy');
end

function v_date_num = F_date2num(v_first_year,v_date)
v_first_day_month='01/01/';
v_first_day_num=datenum([v_first_day_month num2str(v_first_year)]);
v_last_day_num=datenum(v_date,'dd/mm/yyyy');
v_date_num=v_last_day_num-v_first_day_num+1;
if v_date_num<0
    error('La date %s est anterieure a l''annee de reference %d',v_date,v_first_year)
end
