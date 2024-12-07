function v_equal = F_files_comp(v_file_path1,v_file_path2)
%F_FILES_COMP  egalite du contenu de 2 fichiers texte
%   v_equal = F_files_comp(args_entree)   Liste detaillee les arguments d'entree/sortie
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - 
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - 
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
%  DATE: 16-Jan-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also F_name1,...(fonctions dependantes/appelees, supprimer la ligne si aucune)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Valeur de depart v_equal
v_equal=true;
% Chargement infos sur les fichiers
try
    vc_files_path={v_file_path1 v_file_path2};
    v_file1=dir(v_file_path1);
    v_file2=dir(v_file_path2);
    v_exist=~[isempty(v_file1) isempty(v_file2)];
    if  any(~v_exist)
        error('Fichier inexistant: %s',vc_files_path{v_exist});
    end
catch
    v_err=lasterror;
    rethrow(v_err);
end

%Verification de la taille des fichiers
if v_file1.bytes~=v_file2.bytes
    v_equal=false;
    return;
end

% Chargement du contenu des fichiers
try
    v_fid1=fopen(v_file_path1);
    vc_file1_content=textscan(v_fid1,'%s','delimiter','\n');
    fclose(v_fid1);
    % nb lignes
    v_size1=size(vc_file1_content{1});
    v_fid2=fopen(v_file_path2);
    vc_file2_content=textscan(v_fid2,'%s','delimiter','\n');
    fclose(v_fid2);
    %nb lignes
    v_size2=size(vc_file2_content{1});
catch
    warning('Probleme de lecture de fichier...');
    v_equal=false;
end

% comparaison des tailles
if ~all(v_size1==v_size2)
   v_equal=false;
   return;
end

% Verification ligne a ligne des contenus
for v_ligne=1:v_size1(1)
    if ~strcmp(vc_file1_content{1}{v_ligne},vc_file2_content{1}{v_ligne})
        v_equal=false;
        %v_ligne
        return;
    end
end
    
