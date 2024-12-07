function F_check_java_path(v_class_name)
%F_CHECK_JAVA_PATH  Verification de l'acces a une classe java ou un cell
%  contenant des noms de classes
%
%   F_check_java_path(v_class_name)
%  
%   ENTREE(S):
%      - v_class_name: chemin ou cellstr de chemins vers de repertoires
%     ou fichiers archive jar
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - 
%  
%   CONTENU: descriptif de la fonction
%    Verification que les classes sont chargees et levee d'une erreur si 
%    elles ne le sont pas toutes.
%  
%   APPEL(S): liste des fonctions appelees
%      - F_get_tmp_path
%      - F_create_message
%      - F_load_envpaths
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_check_java_path('execution.execute')
%      - F_check_java_path({'execution.execute' 'execution.Forcing'})
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 22-Mar-2011
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_get_tmp_path, F_load_envpaths, F_create_message,exist, cellfun
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin
    help F_check_java_path;
    return
end

% Selon le type d'argument
if ischar(v_class_name)
    vc_class_names={v_class_name};
elseif iscellstr(v_class_name)
    vc_class_names=v_class_name;
end

% Chemin de la librairie actuelle
v_lib_root_path=F_load_envpaths('root');

% Recuperation des infos sur les distrib. referencees
[v_lib_tmp_path, vs_referenced_paths] = F_get_tmp_path;
% Si plusieurs librairies sont referencees
% Verification que seul les chemins de la librairie actuelle 
% sont inclus dans les chemins des classes java declares
% dans le javaclasspath
v_nb_libs=length(vs_referenced_paths);
if v_nb_libs>1
    vv_found=repmat(v_nb_libs,1,false);
    vc_java_class_path=javaclasspath('-static');
    for i=1:v_nb_libs
        vv_found_lib_index=strmatch(vs_referenced_paths(i).lib_root,vc_java_class_path);
        vv_found(i)=any(cellfun(@(x) strcmp(x(length(vs_referenced_paths(i).lib_root)+1),filesep),vc_java_class_path(vv_found_lib_index)));
    end
    % Si trop de chemins sont presents, ou incoherence sur le chemin de la
    % librairie actuelle
    if sum(vv_found)>1
        F_create_message('Erreur sur les chemins specifies dans javaclasspath',...
            'Executer a nouveau F_startup et F_set_path.',1,1);
    end
end
% Verification pour le chemin de la librairie en cours
vv_javapaths_exist=strmatch(v_lib_root_path,javaclasspath('-static'));

% Verification de l'acces aux classes chargees via javaclasspath
vv_exist=cellfun(@(x) exist(x,'class'), vc_class_names);

% Si les chemins ne sont pas presents dans le javaclasspath ou les classes
% ne sont pas toutes accessibles
if isempty(vv_javapaths_exist) || ~all(vv_exist)
    F_create_message('Acces a une ou plusieurs classes java necessaires impossible',...
        sprintf('\t\t%s\n\t\t%s','Redemarrer Matlab et re-executer F_set_path.','Sinon, executer a nouveau F_startup et F_set_path.'),1,1);
end
