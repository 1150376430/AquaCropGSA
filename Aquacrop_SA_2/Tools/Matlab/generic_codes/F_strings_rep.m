function v_out_str=F_strings_rep(v_in_str,v_str2rep,v_rep_str,vv_index)
%F_STRINGS_REP  Remplacement d'une ou plusieurs occurrence d'une chaine
%   v_out_str=F_strrep(v_in_str,v_str2rep,v_rep_str[,vv_index])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_in_str : chaine initiale
%      - v_str2rep : sous-chaine a remplacer dans v_in_str
%      - v_rep_str : chaine de remplacement
%      - vv_index : scalaire ou vecteur du numero d'ordre des occurrences 
%        de la chaine a remplacer dans la chaine initiale
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_out_str : chaine modifiee
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - v_out_str=F_strings_rep('TTbjbskjTT<jbjbTT','TT','A') 
%       [on remplace toutes les occurrences]
%      - v_out_str=F_strings_rep('TTbjbskjTT<jbjbTT','TT','A', [1 3])       
%       [on remplace les occurrences 1 et 3 de TT]
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 22-Nov-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also strrep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Retour par defaut
v_out_str=v_in_str;

% Test arguments obligatoires
if nargin<3
    v_rep_str=' ';
    %F_disp('Arguments insuffisants...')
end
% Si on veut utiliser du numerique en remplacement
v_rep_str=num2str(v_rep_str);
% Test du type de donnees
if  ~all(cellfun(@ischar, {v_in_str v_str2rep}))
    F_disp('Un argument au moins n''est pas un caractere...');
    F_disp('Pas de remplacement.');
    return;
end
vv_begin_index=strfind(v_in_str,v_str2rep);
if isempty(vv_begin_index)
    v_out_str=v_in_str;
    return
end
vv_end_index=vv_begin_index+length(v_str2rep);
% Si on specifie les index des occurrences a remplacer
% Sinon on remplace tout
if nargin>3
    % Selection des elements a remplacer
    vv_begin_index=vv_begin_index(sort(vv_index));
    vv_end_index=vv_end_index(sort(vv_index));
end
v_delta_str=0;
% Remplacement des occurrences de la chaine par une autre chaine
for i=1:length(vv_begin_index)   
    if i>1
        if abs(v_prev_index-vv_begin_index(i))<length(v_str2rep)
            continue
        end
        v_delta_str=v_delta_str-length(v_str2rep)+length(v_rep_str);
    end
    v_out_str=[v_out_str(1:vv_begin_index(i)+v_delta_str-1) v_rep_str v_out_str(vv_end_index(i)+v_delta_str:end)];
    v_prev_index=vv_begin_index(i);
end
