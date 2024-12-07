function v_var = F_deblank(v_var)
%F_DEBLANK Elimination des espaces en debut et fin de chaines de caracteres
%   v_var = F_deblank(v_var)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_var: variable de type char, structure/cell simples ou complexes
%      combinant structures et cell contenant des char
%      - ne fonctionne pas pour des tableaux de caracteres
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_var : idem entree
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 19-Jul-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_detrail,F_dehead
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Liste des caracteres non imprimables (retours chariot,
% ...) a remplacer par un espace 
v_char_num_list=9:13;

switch class(v_var)
    case 'struct'
        vc_fnames=fieldnames(v_var);
        for i=1:length(vc_fnames)
            if ischar(v_var.(vc_fnames{i}))
                v_var.(vc_fnames{i})=F_remove_chars(v_var.(vc_fnames{i}),v_char_num_list,' ');
                v_var.(vc_fnames{i})=F_dehead(F_detrail(v_var.(vc_fnames{i}),0,' '),0,' ');
                if isempty(v_var.(vc_fnames{i}))
                    v_var.(vc_fnames{i})='';
                end
            else
                v_var.(vc_fnames{i})=F_deblank(v_var.(vc_fnames{i}));
            end
        end 
    case 'cell'
        for i=1:length(v_var)
            if ischar(v_var{i})
               v_var{i}=F_remove_chars(v_var{i},v_char_num_list,' ');
               v_var{i}=F_dehead(F_detrail(v_var{i},0,' '),0,' ');
                if isempty(v_var{i})
                    v_var{i}='';
                end
            else
                v_var{i}=F_deblank(v_var{i});
            end
        end
    case 'char'
        % remplacement des caracteres non imprimables
        v_var=F_remove_chars(v_var,v_char_num_list,' ');
        v_var=F_dehead(F_detrail(v_var,0,' '),0,' ');
        if isempty(v_var)
            v_var='';
        end
end



function v_var = F_remove_chars(v_var,v_char_list,v_rep_char)
% Suppression ou remplacement de caracteres dans une chaine
% Par defaut : suppression
if nargin <3
    v_rep_char='';
end
if iscellstr(v_char_list)
    vv_char_num=cellfun(@double,v_char_list);
elseif ischar(v_char_list)
    vv_char_num=double(v_char_list);
elseif isnumeric(v_char_list)
    vv_char_num=v_char_list;
end
% dimension de v_var
[v_var_lines,v_var_cols]=size(v_var);

for i=1:length(vv_char_num)
    for j=1:v_var_lines
        if ~isempty(setdiff(double(unique(v_var(j,:))),vv_char_num))
            v_var(j,:)=strrep(v_var(j,:),char(vv_char_num(i)),v_rep_char);
        end
    end
end

