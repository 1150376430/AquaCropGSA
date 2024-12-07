function [v_min,v_max] = F_give_distr_bounds(v_distribution,v_distr_param)
% Retourne les bornes de la distribution specifiee. 
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_min : borne inferieure
%      - v_max : borne superieure
%
%
%  AUTEUR(S): S. Buis
%  DATE: 06-may-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~F_check_distr(v_distribution,v_distr_param);
    error('Erreur lors de la recuperation des bornes d''une loi de probabilite.');
end


v_min=-Inf;
v_max=Inf;
switch lower(v_distribution)
    case 'uniform'
        v_min = v_distr_param(1);
        v_max = v_distr_param(2);
    case 'triangular'
        v_min = v_distr_param(1);
        v_max = v_distr_param(3);
    case 'beta'
        if length(v_distr_param)==2
            v_distr_param(3)=0;
            v_distr_param(4)=1;
        elseif length(v_distr_param)==3
            v_distr_param(4)=1;
        end
        v_min = v_distr_param(3);
        v_max = v_distr_param(4);
    case {'gamma','lognormal','weibull'}
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        v_min = v_distr_param(3);
        if length(v_distr_param)==4
            v_max = v_distr_param(4);
        end
    case 'normal'
        if length(v_distr_param)>=3
            v_min = v_distr_param(3);
        end
        if length(v_distr_param)==4
            v_max = v_distr_param(4);
        end
    case 'exponential'
        if length(v_distr_param)==1
            v_distr_param(2)=0;
        end
        v_min = v_distr_param(2);
        if length(v_distr_param)==3
            v_max = v_distr_param(3);
        end
    case 'discrete'
        v_min = min(v_distr_param);
        v_max = max(v_distr_param);
    otherwise 
        error('%s ne fait pas partie des distributions disponibles.', ...
            v_distribution);
end
