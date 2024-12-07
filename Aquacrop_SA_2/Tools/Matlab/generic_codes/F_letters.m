function v_letters = F_letters(varargin)
%F_LETTERS renvoi code(s) alpha colonne(s) excel en fonction du/des
%numero(s)
%   v_letters = F_letters([v_num_array])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_num_array : x, [x y z ...]
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - cellstr de l'alphabet majuscule
%      - Liste des codes alpha correspondant aux numeros de colonne
%      specifie en entree sou form d'une Cell
%      ex: {'A' 'B' 'AR' 'AZ'}
%  
%   CONTENU: descriptif de la fonction
%   - production du ou des codes alpha determinant la colonne dans une
%   feuille excel (c.a.d A, B, C... AA, AB...)
%   - calcul du code en base 26 et concatenation des des lettres
%   correspondantes extraites de la liste des lettres (v_list) dans
%   ls sous-fonction F_get_letters appelee en boucle et constitution de la
%   liste des codes alpha 
%  
%   APPEL(S): liste des fonctions appelees
%      - sous-fonction : F_get_letters
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - v_letters = F_letters()
%      v_letters = 
%      {'A'    'B' ... 'Y'    'Z'} % toutes les lettres de l'alphabet
%      - v_letters = F_letters([1 2 3 5 12])
%      v_letters =
%      {'A'    'B'    'C'    'E'    'L'}
%      - v_letters = F_letters(58)
%      v_letters =
%       {'BF'}
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 15-Feb-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_list={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
switch nargin
    case 0
        v_letters=v_list;
    case 1
        % un argument 
        if isnumeric(varargin{1})
            v_letters={};
            for i=1:length(varargin{1})
                v_letters{i}=F_get_letters(varargin{1}(i),26,v_list);
            end
        else
            error('Wrong parameter...');
        end
    otherwise
        v_letters=F_letters(varargin{1});
end
%
%
% calcul des code en base v_base... adapte
function v_letter = F_get_letters(v_num,v_base,v_val_list)
    v_res = [];
    % 
    while v_num > 0.5
        v_remainder = rem(v_num, v_base);
        v_res = [v_remainder, v_res];
        v_num = fix( (v_num-v_remainder) / v_base );
    end
    % adaptation : traitement des codes 0... a revoir ?
    if find(v_res==0)
        v_res=v_res-1;
        v_res(end)=v_base;
        v_res=v_res(v_res>0);
    end
    %
    v_tmp=v_val_list(v_res);
    v_letter=[v_tmp{:}];
    
