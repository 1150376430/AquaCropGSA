function F_debug(varargin)
%F_DEBUG  Affiche un message de debogage si la variable globale v_debug==1
%
%   F_debug([v_str, v_var])
%
%   ENTREE(S): descriptif des arguments d'entree
%        - v_str : une chaine de caractere constituant le message a
%        afficher
%        - v_var : une variable a afficher
%
%   SORTIE(S): 
%        - Pas de variable de sortie. Uniquement message affiche.
%
%   CONTENU: 
%       Cette fonction utilise une variable globale v_debug. Si elle vaut
%       1, les arguments de la fonction sont utilises et les arguments sont
%       utilises pour l'affichage d'un message
%
%   APPELS: 
%      - F_debug(v_str, v_var)
%  
%   EXEMPLE(S): 
%      - F_debug('Message d''erreur')
%      - F_debug('Chaine de caractere',my_variable)
%
%  AUTEUR(S): P. Clastre
%  DATE: 7-12-2006
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global v_debug;


if v_debug
    switch nargin
        case 0
            %rien a faire !
        case 1 % chaine de caractere seule
            disp(strcat('Debug: ',varargin{1}))
        case 2 % une chaine de caractere et une valeur numerique
            disp(['Debug: ' varargin{1}])
            disp(varargin{2})
    end
end

