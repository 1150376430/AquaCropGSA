function [v_cat]=F_write_index(v_vect)
% Concatene un vecteur d'entiers en un entier 
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_vect : 
%         vecteur d'entiers
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_cat : 
%         scalaire entier resultat de la concatenation des entier
%         contenus dans v_vect.
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%     >> F_write_index([2 4])
%     ans =
%          24
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
    v_cat=0;	
    for i=1:length(v_vect)
       v_cat=v_cat+10^(length(v_vect)-i)*v_vect(i); 
    end    
