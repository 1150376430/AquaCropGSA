function vc_out_lines = F_purge_item_tags(vc_in_lines,vc_lines)
%F_PURGE_ITEM_TAGS  Suppression tags xml 'item', fichier generes par
%   xml_toolbox a partir d'une structure generees depuis un fichier xml
%
%   vc_out_lines = F_purge_item_tags(vc_in_lines[,vc_lines]) 
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - vc_in_lines : cell de chaines xml 
%      optionnel :
%         vc_lines: si appel en recursif, ou concatenation
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - vc_out_lines: lignes restructurees avec suppression des lignes
%      <item> </item>, remplacement noms de blocs item par le nom reel,...
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_find_item_tag (sous-fonction)
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - 
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 07-Aug-2012
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
% See also xmlDocument
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<2
    vc_lines={};
end
j=1;
i=1;
vc_out_lines={};
vc_tmp_lines={};

while i<length(vc_in_lines)
    found_begin_item=F_find_item_tag(vc_in_lines{i+1},'<item>');
    found_end_item=F_find_item_tag(vc_in_lines{i+1},'</item>');
    % found_item_attr=F_find_item_tag(vc_in_lines{i+1},'<item ');
    %ePeut-etre mettre detection de la presence des balises item et :item sur 2 lignes !!!
    
    if found_begin_item && found_end_item
        % c'est un content: creation d'autant se <tag>valeur</tag> que de
        % <item>valeur</item>
        v_b_tag=vc_in_lines{i};
        v_e_tag=strrep(v_b_tag,'<','</');
        while found_begin_item && found_end_item      
            vc_tmp_lines{j}=[ v_b_tag vc_in_lines{i+1}(found_begin_item+6:found_end_item-1) v_e_tag];
            i=i+1;
            j=j+1;
            if strfind(vc_in_lines{i+1},v_e_tag)
               break 
            end
            found_begin_item=F_find_item_tag(vc_in_lines{i+1},'<item>');
            found_end_item=F_find_item_tag(vc_in_lines{i+1},'</item>');
        end
         i=i+2;
        continue
    end
    vc_tmp_lines{j}=vc_in_lines{i};
    j=j+1;
    i=i+1;
    if i==length(vc_in_lines)
       % traitement de la derniere ligne, car arret avant dans le while
       vc_tmp_lines{j}=vc_in_lines{i};
    end
end


i=1;
h_level=0;
v_begin_idx=[];
v_end_idx=[];
v_tag_set=false;
% Detection de la presence de blocs
while i<length(vc_tmp_lines)
    if F_find_item_tag(vc_tmp_lines{i},'<item>') || F_find_item_tag(vc_tmp_lines{i},'<item ')
        if ~h_level
            if ~v_tag_set
                v_tag_name=vc_tmp_lines{i-1}(2:end-1);
                v_tag_set=true;
            end
            v_begin_idx=[v_begin_idx i];
            % disp(['debut bloc item: ' num2str(i)])
        end
        h_level=h_level+1;
    end
    if F_find_item_tag(vc_tmp_lines{i},'</item>')
        h_level=h_level-1;
        if ~h_level
            v_end_idx=[v_end_idx i];
            % disp(['fin bloc item: ' num2str(i)])
        end
    end
    i=i+1;
end
% Si presence de blocs...
if ~isempty(v_begin_idx)   
    if ~exist('vc_final_lines','var') 
        vc_final_lines={};
    end
    if ~all(size(v_end_idx)==size(v_begin_idx))
        error('Nombre de debut et fin de bloc item differents')
    end
    vc_start=vc_tmp_lines(1:min(v_begin_idx)-2);
    vc_end={};
    if length(vc_tmp_lines)>max(v_end_idx)+1
        vc_end=vc_tmp_lines(max(v_end_idx)+2:end);
    end
    
    for ibloc=1:length(v_begin_idx)
        vc_bloc_lines=vc_tmp_lines(v_begin_idx(ibloc):v_end_idx(ibloc));
        vc_bloc_lines{1}=strrep(vc_bloc_lines{1},'item',v_tag_name);
        vc_bloc_lines{end}=strrep(vc_bloc_lines{end},'item',v_tag_name);
        vc_final_lines=F_purge_item_tags(vc_bloc_lines,vc_final_lines);
    end
    vc_final_lines={vc_start{:} vc_final_lines{:} vc_end{:}};
end

if exist('vc_final_lines','var') && ~isempty(vc_final_lines)
    % traitement de blocs item
    vc_out_lines=vc_final_lines;
else
    % Pas de traitement de blocs item
    vc_out_lines=vc_tmp_lines; 
end
vc_out_lines={vc_lines{:} vc_out_lines{:}};

 end



function idx = F_find_item_tag(line_string,item_key)
% Recherche de tags item dans une chaine
%   line_string: chaine de caracteres
%   item_key : chaine a rechercher parmi vc_item_keys
%
%   idx : index du debut de chaine trouvee dans line_string
%         ou 0 si la chaine est absente
vc_item_keys={'<item>' '<item ' '</item>'};
idx=0;
if nargin<2
    return
end
if ~ismember(vc_item_keys,item_key)
    return
end

idx=strfind(line_string,item_key);
if isempty(idx)
    idx=0;
end

end