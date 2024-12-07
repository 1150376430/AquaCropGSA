function[v_y]=F_jumping_man(v_x)
% Modele du saut a l'elastique
%
% Fonction qui calcule les valeurs du modele du saut a l'elastique 
% (cf. doc sur les modeles tests) pour plusieurs jeux de valeurs des
% parametres x1, x2, ..., xN. 
% Ce modele calcule la distance minimale atteinte lors des oscillations de
% l'elastique entre l'asphalte et un homme qui saute a l'elastique e
% partir d'une plateforme.
%
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_x : 
%         matrice de type reel de taille (nombre de jeux de valeurs
%         des parametres x, nombre de parametres x), qui contient les jeux
%         de valeurs des parametres xi sur lesquels appliquer le modele.
%         x1 correspond a H la distance entre plateforme et asphalte.
%         x2 correspond a la masse du sauteur.
%         x3 correspond au nombre de brin dans la corde.
%  
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_y : 
%         vecteur de type reel de taille (nombre de jeux de valeurs
%         des parametres x) qui contient les valeurs du modele obtenue
%         a partir des jeux de valeurs des parametres xi definis dans v_x.
%  
%   CONTENU: 
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
    v_H=v_x(:,1);     % distance entre plateforme et asphalte
    v_M=v_x(:,2);     % masse du sauteur
    v_sigma=v_x(:,3); % nombre de brins dans la corde
   
    v_g=9.80665;   % acceleration normale de la pesanteur (m/s^2) 
    v_k=1.5;       % constante d'elasticite d'un brin de corde (N/m)
    
    v_y=v_H-2*v_M*v_g./(v_k*v_sigma);
    
return
