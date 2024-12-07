function vs_xml_struct=F_gen_xml_struct(v_csv_file_name)
% F_GEN_XML_STRUCT Transformation d'un fichier csv en structure compatible
% avec xml_tools
%   vs_xml_struct=F_gen_xml_struct(v_csv_file_name)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_csv_file_name: nom du fichier au format csv contenant les
%      informations permettant la creation de la structure xml avec
%      attributs et valeurs de champs (ATTRIBUTE, CONTENT)
%  
%   SORTIE(S): 
%      - vs_xml_struct: structure avec des champs correspondants aux noms
%      de balises, et les champs ATTRIBUTE (structure avec noms de champs
%      == noms d'attributs et valeurs des champs == valeurs attributs) et
%      CONTENT dont la valeur est la valeur affectee au champ parent.
%  
%   CONTENU: Le fichier csv contient des colonnes contenant des noms de
%   balises, et des colonnes contenant des nomls d'attributs ou valeurs par
%   defaut des balises (quand elles n'ont pas de sous-balises)
%  
%   APPEL(S): liste des fonctions appelees
%      - F_csv2struct
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - vs_xml_struct=F_gen_xml_struct(v_csv_file_name)
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 26-Jul-2010
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also F_csv2struct, F_create_message,orderfields
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialisation de la structure pour xml
vs_xml_struct=struct;

% Verification du contenu avant la tranformation en structure: nb de
% separateurs ; par ligne
v_fid=fopen(v_csv_file_name);
vc_lines=textscan(v_fid,'%s','delimiter','\n');
fclose(v_fid);

v_delim_nb=unique(cellfun(@(x) sum(x>0),strfind(vc_lines{1},';')));
if length(v_delim_nb)>1
    F_create_message(['Erreur sur le fichier ' v_csv_file_name],'Le nombre de colonnes n''est pas identique sur toutes les lignes',...
        1,1);
end
v_data_col_nb=v_delim_nb+1;
% Recuperation de la structure a partir du fichier csv qui fourni
vs_csv_struct=F_csv2struct(v_csv_file_name,repmat('%s',1,v_data_col_nb),';',1);

% Controle de presence de caracteres pouvant poser pb
% pour la generation du fichier xml: uniquement " pour l'instant
% (reserve pour la valeur des attributs xml)
if ~isempty(cell2mat(structfun(@(x) {cell2mat(strfind(x,'"'))},vs_csv_struct)))
    F_create_message(['Erreur sur le fichier ' v_csv_file_name],'Le caractere " est present, le supprimer ou le remplacer par '' ',...
        1,1);
end

% Initialisation des indices des noeuds
v_current_node=1;

% Les champs des noeuds a parcourir
vc_fnames=fieldnames(vs_csv_struct);
vc_node_names=vc_fnames(strmatch('n',vc_fnames));
v_nodes_nb=length(vc_node_names);

% Elimination des elements inutiles dans la structure
% lignes ne comportant pas de noeud, noeuds ne comportant
% pas de nom
% Elimination des nodes vides = champs de la structure
v_empty_fields_idx=structfun(@(x) (all(cellfun(@isempty,x))),vs_csv_struct);
vc_empty_nodes=vc_node_names(v_empty_fields_idx(1:v_nodes_nb));
for n=1:length(vc_empty_nodes)
    vs_csv_struct=rmfield(vs_csv_struct,vc_empty_nodes{n});
end

% MAJ des infos
% Les champs des noeuds a parcourir
vc_fnames=fieldnames(vs_csv_struct);
vc_node_names=vc_fnames(strmatch('n',vc_fnames));
v_nodes_nb=length(vc_node_names);
v_current_node_name=vc_node_names{1};

% Determination du nombre de lignes utiles
vv_index_max=cell2mat(struct2cell(structfun(@(x) max(find(~cellfun(@isempty,x))),vs_csv_struct,'UniformOutput',false)));
vv_index_max=max(vv_index_max(1:v_nodes_nb));

% Recalcul du contenu des champs en fonction du nouveau nb de lignes
for n=1:length(vc_fnames)
    vs_csv_struct.(vc_fnames{n})=vs_csv_struct.(vc_fnames{n})(1:vv_index_max);
    % Ajout d'une ligne pour le traitement
    vs_csv_struct.(vc_fnames{n}){end+1}='';
end

% Ajout d'un noeud vide pour le traitement
% avant les colonnes dediees aux attributs
vs_csv_struct.(['n' num2str(v_nodes_nb+1)])=cell(vv_index_max+1,1);
vc_node_names={vc_node_names{:} ['n' num2str(v_nodes_nb+1)]};
v_nodes_nb=length(vc_node_names);

% Calcul vecteur permutation d'ordre pour avoir tous les n* a la suite
% (apres ajout du noeud vide necessaire au traitement)
vv_perm=[1:v_nodes_nb-1 length(fieldnames(vs_csv_struct)) v_nodes_nb:length(fieldnames(vs_csv_struct))-1];
vs_csv_struct=orderfields(vs_csv_struct,vv_perm);
% MAJ de la liste des champs (pour avoir le bon ordre)
vc_fnames=fieldnames(vs_csv_struct);
%
%

% Numero de ligne dans le fichier (hors en-tete: utilisee pour les noms des champs) 
i=1;

% Calcul du nombre de colonnes d'attributs
v_attr_nb=length(vc_fnames)-length(vc_node_names);

% Creation de la pile des noms de champs pour la hierarchie
vc_pile={};

% Parcours de la structure
v_lines_nb=length(vs_csv_struct.(v_current_node_name));
%
while i<=v_lines_nb-1 % On enleve la derniere ligne, presente pour le traitement
    % 
    v_fname=vs_csv_struct.(v_current_node_name){i};
    if ~isempty(v_fname)     
        % Si la pile des noms de champ est vide (creation d'une struct dans
        % un champ de premier niveau)
        if isempty(vc_pile)
            vs_xml_struct.(v_fname)=struct;
        else % sinon creation d'un sous-champ des champs stockes dans la pile
            eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(v_fname)=struct;']);
        end
        %
        % Traitement des attributs
        eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(v_fname).ATTRIBUTE=struct;']);
        % Enchainement du renseignement des attributs
        for j=1:v_attr_nb
            % Extraction valeur et nom de l'attribut
            v_attr_field_data=vs_csv_struct.(vc_fnames{v_nodes_nb+j});
            v_attr_name=vc_fnames{v_nodes_nb+j};
            % Extraction de la valeur de l'attribut
            try % extraction dans un cell, chaines de caracteres
                v_attr_value=v_attr_field_data{i};
            catch % sinon extraction dans un array, numeriques
                v_attr_value=v_attr_field_data(i);
            end
            % Generation de l'attribut
            eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(v_fname).ATTRIBUTE.(v_attr_name)=v_attr_value;']);
        end

    end
    
    % Traitement hierarchique des elements en fonction presence collateraux,
    % descendants, et affectation de la valeur par defaut (CONTENT)
    v_default_value='';
    if i==v_lines_nb % on arrive au dernier element du tableau qu'il faut renseigner avec un contenu
        eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(vs_csv_struct.(v_current_node_name){i}).CONTENT=v_default_value;']);
        break
    else
        if ~isempty(vs_csv_struct.(v_current_node_name){i+1}) % si un noeud frere existe (ligne suivante non vide)
            % on ajoute le content : vide pour l'instant
            eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(vs_csv_struct.(v_current_node_name){i}).CONTENT=v_default_value;']);
            % on change de ligne
            i=i+1;
        elseif ~isempty(vs_csv_struct.(vc_node_names{v_current_node+1}){i+1}) % si un noeud enfant existe (ligne suivante et colonne suivante non vide)
            % Le noeud courant a un descendant, on empile le nom extrait dans le noeud courant
            vc_pile{length(vc_pile)+1}=vs_csv_struct.(vc_node_names{v_current_node}){i};
            % on change de noeud et de ligne
            i=i+1;
            v_current_node=v_current_node+1;
            v_current_node_name=vc_node_names{v_current_node};
        else
            % on ajoute le content : vide pour l'instant
            eval(['vs_xml_struct' sprintf(repmat('.%s',1,length(vc_pile)),vc_pile{:}) '.(vs_csv_struct.(v_current_node_name){i}).CONTENT=v_default_value;']);
            i=i+1;
             % on depile tant que l'on a rien
            while v_current_node > 1 && isempty(vs_csv_struct.(vc_node_names{v_current_node}){i})
                v_current_node=v_current_node-1;
            end
            % mise a jour de la pile des noms de champs
            vc_pile=vc_pile(1:v_current_node-1);
            v_current_node_name=vc_node_names{v_current_node};
        end
    end
end


