function v_y=F_g_function(v_x,v_a)
% Fonction g de Sobol'
%
% Fonction qui calcule les valeurs de la fonction g de Sobol'
% (cf. doc sur les modeles tests) pour plusieurs jeux de valeurs des
% parametres x1, x2, ..., xN
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_x : 
%         matrice de type reel de taille (nombre de jeux de valeurs
%         des parametres x, nombre de parametres x), qui contient les jeux 
%         de valeurs des parametres xi sur lesquels appliquer la fonction g.
%
%      - v_a : 
%         vecteur de type reel de taille (nombre de parametres x)
%         contenant les valeurs des parametres ai qui definissent la
%         fonction g. 
%
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_y : 
%         vecteur de type reel de taille (nombre de jeux de valeurs
%         des parametres x) qui contient les valeurs de la fonction g
%         obtenue a partir des jeux de valeurs des parametres xi definis
%         dans v_x. 
%  
%   CONTENU: 
%      - calcul du nombre de parametres et verification de la taille de v_a
%      - calcul de v_y
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

% Calcul du nombre de parametres et verification de la taille de v_a
    v_k=size(v_x,2);    
    if (v_k~=size(v_a)) 
        error(['Les coefficients de la fonction g n''ont pas ete defini pour un nombre de parametre egal a ' int2str(v_k)]);
    end 
    
% Calcul de v_y
    v_y=1;
    for j=1:v_k
        v_y=v_y.*(abs(4.*v_x(:,j)-2)+v_a(j))/(1+v_a(j));
    end
    
return
