function [vm_sample,v_flag_completed] = F_acceptance_rejection(v_distribution,v_distr_param, vm_proposal_sample, varargin)
% Algorithme d'acceptation-rejet pour la simulation de lois tronquees.  
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_distribution: type de distribution 
%      - v_distr_param: vecteur contenant les parametres de la
%      distribution
%      - vm_proposal_sample : echantillon de la loi de proposition
%      - vm_sample_ini (OPTIONNEL): vecteur de taille la taille de l'echantillon souhaitee
%      pour la loi tronquee contenant un echantillon a completer pour cette
%      loi (NaN partout il faut mettre une valeur).
%      Si cet argument n'est pas fourni, vm_sample sera egal a
%      vm_proposal_sample sans ses valeurs en dehors des bornes.
%
%   SORTIE(S): descriptif des arguments de sortie
%      - vm_sample: vecteur contenant l'echantillon de la loi tronquee.
%      Attention, celui-ci peut-etre incomplet (i.e. contenir des NaN). 
%      Dans ce cas, re-iterer l'appel a la fonction
%      en fournissant un nouvel echantillon vm_proposal_sample ainsi que le 
%      resultat du premier appel en dernier argument, et ainsi de suite
%      jusqu'e obtenir un echantilon complet.
%      - v_flag_completed : 1 si l'echantillon est complet, 0 sinon.
%
%
%
%  AUTEUR(S): S. Buis
%  DATE: 27-juil-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~F_check_distr(v_distribution,v_distr_param);
    error('Erreur dans l''algorithme acceptation-rejet pour la generation d''echantillon selon une loi tronquee.');
end

% Recuperation des bornes
[a,b] = F_give_distr_bounds(v_distribution,v_distr_param);

% methode acceptation rejet
v_indices_accepted=find(vm_proposal_sample<=b & vm_proposal_sample>=a);  % indices des valeurs ajoutables

if nargin==4
    vm_sample=varargin{1};
    v_indices_NaN=find(isnan(vm_sample)); % indices des cases a completer
    v_nb_filledvalues=min(length(v_indices_NaN),length(v_indices_accepted)); % nombre de valeurs a remplir

    vm_sample(v_indices_NaN(1:v_nb_filledvalues))=vm_proposal_sample(v_indices_accepted(1:v_nb_filledvalues));

    %vm_sample=[vm_sample_ini(~isnan(vm_sample_ini));vm_proposal_sample(v_indices(1:min(length(v_indices),v_sample_size-sum(~isnan(vm_sample_ini)))))];
else
    vm_sample=nan(size(vm_proposal_sample));
    vm_sample(v_indices_accepted)=vm_proposal_sample(v_indices_accepted);
end

v_flag_completed=~(sum(isnan(vm_sample))>0);
