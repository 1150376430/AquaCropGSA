function[v_y]=F_ishigami(v_x)
% Modele d'Ishigami
%
% Fonction qui calcule les valeurs de la fonction d'Ishigami
% (cf. doc sur les modeles tests) pour plusieurs jeux de valeurs des
% parametres x1, x2, ..., xN
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_x : 
%         matrice de type reel de taille (nombre de jeux de valeurs
%         des parametres x, nombre de parametres x), qui contient les jeux
%         de valeurs des parametres xi sur lesquels appliquer la fonction
%         d'Ishigami. 
%  
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_y : 
%         vecteur de type reel de taille (nombre de jeux de valeurs
%         des parametres x) qui contient les valeurs de la fonction d'Ishigami
%         obtenue a partir des jeux de valeurs des parametres xi definis dans
%         v_x. 
%  
%   CONTENU: 
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
    
    v_y=sin(v_x(:,1))+7.*sin(v_x(:,2)).^2+0.1.*v_x(:,3).^4.*sin(v_x(:,1));
    
return
