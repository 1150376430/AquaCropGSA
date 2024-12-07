function v_M = F_gen_matindex_vs(v_p)
% Association entre l'ordre des indices v_S et numero des facteurs impliques
%
% Creation de la matrice dont chaque ligne i definit 
% le(s) numero(s) du(des) facteur(s) impliques dans le calcul de l'indice 
% de sensibilite v_S(i). 
%  
%   ENTREE(S): 
%      - v_p : 
%         scalaire entier contenant le nombre de facteurs variants du
%         modele a analyser
%  
%   SORTIE(S): 
%      - v_M : 
%         matrice de type entier (0 ou 1), de taille (2^v_p,v_p),
%         contenant pour chaque ligne le(s) numero(s) du(des) facteur(s) 
%         impliques dans le calcul de l'indice de sensibilite v_S(i) (en fait, 
%         ce numero est celui de la (des) colonne(s) contenant un 1. 
%         Ne pas utiliser la premiere ligne qui est systematiquement nulle.
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%    >> F_gen_matindex_vs(3)
%    ans = 
%         0     0     0
%         0     0     1
%         0     1     0
%         0     1     1
%         1     0     0
%         1     0     1
%         1     1     0
%         1     1     1
%    Donc pour 3 parametres variants :
%       v_S(1)=S3
%       v_S(2)=S2  
%       v_S(3)=S23  
%       v_S(4)=S1  
%       v_S(5)=S13  
%       v_S(6)=S12  
%       v_S(7)=S123  
%
%
%  AUTEUR(S): S. Buis
%  DATE: 31-Aug-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if v_p<15
        v_N=2^v_p;
	    v_M=zeros(v_N,v_p);
	    for v_k=1:v_p
	        v_v=[ zeros(2^(v_k-1),1) ; ones(2^(v_k-1),1) ];
	        v_M(:,v_p-v_k+1)=repmat(v_v,2^(v_p-v_k),1);
	    end
    else
        %matrice identite
        v_M=[zeros(1,v_p) ; eye(v_p)];
    end
