function v_answer=F_input(v_str,v_default)
%F_INPUT  gestion des saisies utilisateur
%   v_answer = F_input(v_str,v_default)   
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_str : chaine de caracteres a afficher
%      - v_default : chaine de caractere = valeur par defaut 
%      de la reponse
%  
%   SORTIE(S):
%      - v_answer = reponse, chaine de caractere
%  
%   CONTENU: 
%   Affichage d'un dialogue interactif permettant la saisie d'une reponse
%   a une question de la part de l'utilisateur ou pas d'interactivite et 
%   renvoi de la valeur de la reponse par defaut.
%  
%   APPEL(S): 
%      - input
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - v_answer=F_input('Voulez-vous effacer les fichiers ?','O')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 27-Apr-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-09-27 13:35:58 +0200 (ven., 27 sept. 2013) $
%    $Author: plecharpent $
%    $Revision: 981 $
%  
%  
% See also F_set_display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% On fixe la variable d'affichage
global v_display;
F_set_display;

% Pour supprimer l'affichage d'un message
% demandant d'entrer une valeur, ou enter !
global v_pause;
F_set_pause

% Initialisation de la reponse
v_answer='';

% Affichage
if v_display && v_pause
    v_answer=input(v_str,'s');
end
% Si pas d'input (v_display==false) ou reponse vide
if isempty(v_answer)
    v_answer=v_default;
end
