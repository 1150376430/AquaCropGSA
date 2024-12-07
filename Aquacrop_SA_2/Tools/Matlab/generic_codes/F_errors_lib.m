function varargout = F_errors_lib(v_lib_tag)
%F_ERRORS_LIB  chargement/ affcichage de nomenclature d'erreurs
%   [vs_lib] = F_errors_lib(v_lib_tag)
%  
%   ENTREE(S): 
%      - v_lib_tag: identifiant de la liste d'erreurs a charger
%      ex: MSLIB
%  
%   SORTIE(S): 
%      Optionnel:
%      - vs_lib: structure array, avec les champs
%             .msgid = identifiant unique de l'erreur, base sur la syntaxe
%             matlab ('MATLAB:noSuchFile'), pour MSLIB : 'MSLIB:nomErreur'
%             .solution: indication de piste pour remedier au probleme
%  
%   CONTENU:
%     Production de la structure vs_lib contenant les erreurs referencees...
%     ATTENTION : ce n'est pas definitif, il y a encore du travail pour
%     definir cette typologie, A REVOIR....
% 
%   APPEL(S):
%      - en fonction de v_lib_tag: F_(*)_errors
%      (*) correspondant au contenu de v_lib_tag (cf. exemple)
%
%   EXEMPLE(S):
%      F_errors_lib('MSLIB') : affichage de la liste des erreurs 
%      - vs_lib = F_errors_lib('MSLIB'): recuperation du tableau de
%      structures des erreurs.
%  
%      la fonction appelee contenant la listes des erreurs referencees et
%      des solutions pour MSLIB : F_MSLIB_errors
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 26-Jul-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:15:52 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 939 $
%  
%  
% See also F_error, F_MSLIB_errors, F_DEV_errors,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vs_lib.msgid='unknownError';
vs_lib.solution='Pas de solution. L''erreur n''est pas referencee....\n%s%s';
if nargout
   varargout{1}=vs_lib; 
end

% Liste des tags : groupes d'erreurs
vc_errors_lib_tags={'MSLIB' 'DEV'};

% Affichage de la liste des tags
if ~nargin
    F_disp(sprintf('\nNoms des listes disponibles a fournir en argument de F_errors_lib: \n\n%s',...
        sprintf('%s\n',vc_errors_lib_tags{:})));
    return
end

% Si le tag est vide
if isempty(v_lib_tag)
   return
end

% Si le tag n'existe pas, arret
if ~nargin || ~ismember(v_lib_tag,vc_errors_lib_tags)
    F_disp(sprintf('Le nom de la liste d''erreurs %s n''existe pas ou n''est pas accessible',v_lib_tag));
    F_disp(sprintf('Liste des noms disponibles a fournir en argument de F_errors_lib: \n%s',...
        sprintf('%s ',vc_errors_lib_tags{:})));
    return
end
% Si le fichier correspondant existe
if eval(['exist(''F_' v_lib_tag '_errors'',''file'')']);
    vs_lib=eval(['F_' v_lib_tag '_errors']);
end
if nargout
   varargout{1}=vs_lib; 
else
    % Simple affichage des msgid et solutions
    F_disp(sprintf('\n%s\t\t%s','Message identifier','Solution'));
    F_disp(repmat('*',1,100));
    for i=2:length(vs_lib)
        F_disp(sprintf('%s\t\t%s', vs_lib(i).msgid,vs_lib(i).solution));
    end
    F_disp(repmat('*',1,100));
end
