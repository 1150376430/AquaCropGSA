function v_str = F_detrail(v_str,varargin)
%F_DETRAIL  Ajout ou suppression de caracteres repetitifs en fin d'une chaine
%   v_str = F_detrail(v_str[,v_rev,v_trailer,v_str_size])
%  
%   ENTREE(S): 
%      - v_str : chaine de caracteres
%      Optionnelles:
%      - v_rev : par defaut 0 pour supprimer les caracteres, 1 pour
%      completer la chaine de caracteres 
%      - v_trailer : caractere a utiliser pour completer la chaine v_str
%      - v_str_size : taille en dessous de laquelle il faut completer la
%      chaine v_str
%
%       Valeurs par defaut
%        v_rev=0;
%        v_trailer='_';
%        v_str_size=7;
%  
%   SORTIE(S): 
%      - v_str : chaine completee ou non en fonction de sa longueur
%  
%   CONTENU: Ajout de carateres repetitifs a une chaine de caractere pour
%   obtenir une longueur donnee, ou suppression de caracteres repetitifs en
%   fin de chaine.
%  
%   APPEL(S):
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%    >>  a='tg_a___'
%    >> a=F_detrail(a)
%       a =
%       tg_a
%    >> a=F_detrail(a,1)
%       a =
%       tg_a___
%
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 23-Jul-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_dehead, F_csv2struct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Valeurs par defaut
v_rev=0;
v_trailer='_';
v_str_size=7;

% dimension de v_var
[v_var_lines,v_var_cols]=size(v_str);
if v_var_lines>1
    F_disp('F_detrail: erreur, impossible de traiter les tableaux de caracteres');
    return 
end

switch nargin
    case 2
        v_rev=varargin{1};
    case {3,4}
        v_rev=varargin{1};
        for i=2:length(varargin)
            if ischar(varargin{i})
                v_trailer=varargin{i};
            elseif isnumeric(varargin{i})
                v_str_size=varargin{i};
            end
        end
end

switch v_rev
    case 0 % Suppression du caractere v_trailer (consecutifs)
        for i=length(v_str):-1:0
            if i>0 && strcmp(v_str(i),v_trailer)
                continue
            else
                break
            end
        end
        v_str=v_str(1:i);
    case 1 % Ajout du caractere repete pour completer v_str si besoin
        v_str = [v_str repmat(v_trailer,1,(v_str_size - length(v_str)))];
end
