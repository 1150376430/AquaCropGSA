function v_nb_digits = F_give_nb_digits(v_a)
% Compte le nombre de digits de nombres
% 
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_a: vecteur contenant les nombres dont on souhaite compter le
%      nombre de digits
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_nb_digits: vecteur contenant le nombre de digits de v_a
%
%
%
%  AUTEUR(S): S. Buis
%  DATE: 04-nov-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_indtot=1:length(v_a);
for i=0:16
    v_indtmp=v_a.*10^i-fix(v_a.*10^i)<=eps;
    v_nb_digits(v_indtot(v_indtmp))=i;
    v_indtot(v_indtmp)=[];
    v_a(v_indtmp)=[];
end
