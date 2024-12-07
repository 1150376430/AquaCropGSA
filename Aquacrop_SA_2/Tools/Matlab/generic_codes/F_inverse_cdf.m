function [v_flag_truncated, vm_sample] = F_inverse_cdf(v_distribution,v_distr_param, v_proba)
% Applique l'inverse d'une fonction de distribution cumulative d'une loi donnee
% sur un vecteur de probabilite. 
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%      - v_proba : vecteur des probabilites
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vm_sample: vecteur contenant l'echantillon resultant de
%      l'application de la cdf inverse.
%      - v_flag_truncated : booleen indiquant (1) si la loi est tronquee ou pas 
%      (dans ce cas un algorithme d'acceptation-rejet doit-etre appele pour
%      generer l'echantillon souhaite).
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
    error('Erreur lors de la generation de nombres aleatoires.');
end

v_flag_truncated=0;
switch lower(v_distribution)
    case 'uniform'
        if nargout==1, return, end
        vm_sample = v_distr_param(1)+v_proba.*(v_distr_param(2)-v_distr_param(1));
    case 'triangular'
        if nargout==1, return, end
        vm_sample = trianginv(v_proba,v_distr_param(1),v_distr_param(2),v_distr_param(3));
    case 'beta'
        if length(v_distr_param)==2
            v_distr_param(3)=0;
            v_distr_param(4)=1;
        elseif length(v_distr_param)==3
            v_distr_param(4)=1;
        end
        if nargout==1, return, end
        vm_sample = v_distr_param(3)+betainv(v_proba,v_distr_param(1),v_distr_param(2)).*(v_distr_param(4)-v_distr_param(3));
    case 'gamma'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vm_sample = v_distr_param(3)+gaminv(v_proba,v_distr_param(1),v_distr_param(2));
    case 'normal'
        v_flag_truncated=length(v_distr_param)==3||length(v_distr_param)==4;
        if nargout==1, return, end
        vm_sample = norminv(v_proba,v_distr_param(1),v_distr_param(2));
    case 'lognormal'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vm_sample = v_distr_param(3)+logninv(v_proba,v_distr_param(1),v_distr_param(2));
    case 'weibull'
        v_flag_truncated=length(v_distr_param)==4;
        if length(v_distr_param)==2
            v_distr_param(3)=0;
        end
        if nargout==1, return, end
        vm_sample = v_distr_param(3)+wblinv(v_proba,v_distr_param(1),v_distr_param(2));
    case 'exponential'
        v_flag_truncated=length(v_distr_param)==3;
        if length(v_distr_param)==1
            v_distr_param(2)=0;
        end
        if nargout==1, return, end
        vm_sample = v_distr_param(2)+expinv(v_proba,v_distr_param(1));
    case 'discrete'
        if nargout==1, return, end
        vm_sample = discrinv(v_proba,v_distr_param);
    otherwise 
        error('%s ne fait pas partie des distributions disponibles.', ...
            v_distribution);
end
