function [v_flag_truncated, vv_proba] = F_cdf(v_distribution,v_distr_param, vv_values)
% Applique la fonction de distribution cumulative d'une loi donnee
% sur un vecteur de valeurs. 
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%      - vv_values : vecteur des valeurs pour lesquelles on veut les proba
%      cumulées
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vv_proba: vecteur de valeurs des proba cumulées resultant de
%      l'application de la cdf aux valeurs données.
%      - v_flag_truncated : booleen indiquant (1) si la loi est tronquee ou pas 
%      (dans ce cas un algorithme d'acceptation-rejet doit-etre appele pour
%      generer l'echantillon souhaite).
%
%
%  AUTEUR(S): S. Buis
%  DATE: 31-jul-2013
%  VERSION: 0
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~F_check_distr(v_distribution,v_distr_param);
    error('Erreur lors de la generation de nombres aleatoires.');
end

v_flag_truncated=0;
switch lower(v_distribution)
    case 'uniform'
        if nargout==1, return, end
        vv_proba = (vv_values-v_distr_param(1))./(v_distr_param(2)-v_distr_param(1));
    case 'triangular'       
        if nargout==1, return, end
        vv_proba = triangcdf(vv_values,v_distr_param(1),v_distr_param(2),v_distr_param(3));   
    case 'beta'
        if length(v_distr_param)==2
            v_distr_param(3)=0;
            v_distr_param(4)=1;
        elseif length(v_distr_param)==3
            v_distr_param(4)=1;
        end
        if nargout==1, return, end
        vv_proba = betacdf((vv_values-v_distr_param(3))/(v_distr_param(4)-v_distr_param(3)),v_distr_param(1),v_distr_param(2));
    case 'gamma'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vv_proba = gamcdf(vv_values-v_distr_param(3),v_distr_param(1),v_distr_param(2));
    case 'normal'
        v_flag_truncated=length(v_distr_param)==3||length(v_distr_param)==4;
        if nargout==1, return, end
        vv_proba = normcdf(vv_values,v_distr_param(1),v_distr_param(2));
    case 'lognormal'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vv_proba = logncdf(vv_values-v_distr_param(3),v_distr_param(1),v_distr_param(2));
    case 'weibull'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vv_proba = wblcdf(vv_values-v_distr_param(3),v_distr_param(1),v_distr_param(2));
    case 'exponential'
        v_flag_truncated=length(v_distr_param)==3;
        if length(v_distr_param)==1
            v_distr_param(2)=0;
        end
        if nargout==1, return, end
        vv_proba = expcdf(vv_values-v_distr_param(2),v_distr_param(1));
    case 'discrete'
        if nargout==1, return, end
        vv_proba = discrcdf(vv_values,v_distr_param);
    otherwise 
        error('%s ne fait pas partie des distributions disponibles.', ...
            v_distribution);
end
