function v_exp = F_give_distr_exp(v_distribution,v_distr_param)
% Retourne l'esperance de la distribution specifiee. 
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_exp : l'esperance de la loi specifiee
%
%   ATTENTION: pour les lois tronquees (sauf la loi normale), ca ne renvoie
%   pas l'esperance mais le centre du support.
%
%
%  AUTEUR(S): S. Buis
%  DATE: 09-aout-2010
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
    error('Erreur lors de la recuperation de l''esperance d''une loi de probabilite.');
end

switch lower(v_distribution)
    case 'uniform'
        v_exp = v_distr_param(1)+(v_distr_param(2)-v_distr_param(1))/2;
    case 'triangular'
        v_exp = (v_distr_param(1)+v_distr_param(2)+v_distr_param(3))/3;
    case 'beta'
        if length(v_distr_param)==2
            v_distr_param(3)=0;
            v_distr_param(4)=1;
        elseif length(v_distr_param)==3
            v_distr_param(4)=1;
        end
        v_exp = v_distr_param(3)+v_distr_param(1)*(v_distr_param(4)-v_distr_param(3))/(v_distr_param(1)+v_distr_param(2));
    case 'gamma'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        v_exp = v_distr_param(3)+v_distr_param(1)/v_distr_param(2);
        if v_flag_truncated
            v_exp=v_distr_param(3)+(v_distr_param(4)-v_distr_param(3))/2;
        end
    case 'normal'
        v_flag_truncated=length(v_distr_param)==3||length(v_distr_param)==4;
        v_exp = v_distr_param(1);
        if v_flag_truncated
            if isinf(v_distr_param(3))
                v_t4=0;
            else
                v_t4=normcdf((v_distr_param(3)-v_distr_param(1))/v_distr_param(2),v_distr_param(1),v_distr_param(2));
            end
            if length(v_distr_param)==3 || isinf(v_distr_param(4)) 
                v_t3=0;
            else
                v_t3=normcdf((v_distr_param(4)-v_distr_param(1))/v_distr_param(2),v_distr_param(1),v_distr_param(2));                
            end            
            v_t1=normpdf((v_distr_param(3)-v_distr_param(1))/v_distr_param(2),v_distr_param(1),v_distr_param(2));
            v_t2=normpdf((v_distr_param(4)-v_distr_param(1))/v_distr_param(2),v_distr_param(1),v_distr_param(2));
            if v_t4==0 && v_t3==0
                v_exp=v_distr_param(1);
            else
                v_exp = v_distr_param(1)+(v_t1-v_t2)*v_distr_param(2)/(v_t3-v_t4);
            end
        end
    case 'lognormal'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        v_exp = v_distr_param(3)+exp(v_distr_param(1)+v_distr_param(2)^2/2);
        if v_flag_truncated
            v_exp=v_distr_param(3)+(v_distr_param(4)-v_distr_param(3))/2;
        end
    case 'weibull'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        v_exp = v_distr_param(3)+v_distr_param(1)*gamma(1+1/v_distr_param(2));
        if v_flag_truncated
            v_exp=v_distr_param(3)+(v_distr_param(4)-v_distr_param(3))/2;
        end
    case 'exponential'
        v_flag_truncated=length(v_distr_param)==3;
        if length(v_distr_param)==1
            v_distr_param(2)=0;
        end
        v_exp = v_distr_param(2)+1/v_distr_param(1);
        if v_flag_truncated
            v_exp=v_distr_param(2)+(v_distr_param(3)-v_distr_param(2))/2;
        end
    case 'discrete'
        v_exp = sum(v_distr_param)/length(v_distr_param);
    otherwise 
        error('%s ne fait pas partie des distributions disponibles.', ...
            v_distribution);
end

if isnan(v_exp)
    error('Probleme lors du calcul de l''esperance d''une loi de probabilite : les parametres de la loi de distribution %s sont probablement mal definis.', ...
            v_distribution);
end
