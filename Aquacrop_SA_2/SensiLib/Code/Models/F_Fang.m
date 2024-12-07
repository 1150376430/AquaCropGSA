function[v_y]=F_Fang(v_x)
% Modele test utilise dans Fang et al 2003, "Improved generalized Fourier
% amplitude sensitivity test (FAST) for model assessment"
%
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_x : 
%         matrice de type reel de taille (nombre de jeux de valeurs
%         des parametres x, nombre de parametres x), qui contient les jeux
%         de valeurs des parametres xi sur lesquels appliquer la fonction
%  
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_y : 
%         vecteur de type reel de taille (nombre de jeux de valeurs
%         des parametres x) qui contient les valeurs de la fonction 
%         obtenue a partir des jeux de valeurs des parametres xi definis dans
%         v_x. 
%  
%   CONTENU: 
%  
%  AUTEUR(S): S. Buis
%  DATE: 02-Juil-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    v_y=sum(v_x,2);
    
return
