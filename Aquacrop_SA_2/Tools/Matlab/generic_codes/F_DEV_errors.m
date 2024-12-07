function vs_lib = F_DEV_errors
%F_DEV_ERRORS Nomenclature/classification des erreurs pour le DEVELOPPEMENT
%   vs_lib = F_DEV_errors
%  
%   ENTREE(S): aucun 
%  
%   SORTIE(S):
%      - vs_lib: structure array, avec les champs
%             .msgid = identifiant unique de l'erreur, base sur la syntaxe
%              'DEV:nomErreur'
%             .solution: indication de piste pour remedier au probleme
%  
%   CONTENU: 
%     Production de la structure vs_lib contenant les erreurs referencees...
%     ATTENTION : ce n'est pas definitif, il y a encore du travail pour
%     definir cette typologie, A REVOIR....
% 
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - vs_lib = F_DEV_errors
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 26-Jul-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%  
% See also F_error, F_errors_lib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vs_lib(1).msgid='undefinedError';
vs_lib(1).solution='Pas de solution. L''erreur n''est pas referencee....\n%s%s';
vs_lib(2).msgid='DEV:inputArgsError';
vs_lib(2).solution='Verifier les arguments en entree de la fonction';
% vs_lib(3).msgid='DEV:dirNotFound';
% vs_lib(3).solution='Verifier le nom du repertoire/chemin';
% vs_lib(4).msgid='DEV:fileWriteError';
% vs_lib(4).solution='Verifier les droits sur le fichier, acces au repertoire le contenant';
% vs_lib(5).msgid='DEV:configError';
% vs_lib(5).solution='Verifier la/les option(s) correspondante(s) dans le fichier de configuration';
% vs_lib(6).msgid='DEV:searchPathError';
% vs_lib(6).solution='Verifier si le chemin existe dans la variable path commande : what(''chemin'')';
% vs_lib(7).msgid='DEV:dirPathError';
% vs_lib(7).solution='Verifier si les chemins des repertoires / Re-executer la fonction F_startup...';
% vs_lib(8).msgid='DEV:dataTypeError';
% vs_lib(8).solution='Verifier le format/type de la structure de donnees';
% vs_lib(9).msgid='DEV:codeValueError';
% vs_lib(9).solution='Verifier les valeurs possibles dans la structure ou le fichier specifique';
% vs_lib(10).msgid='DEV:dataError';
% vs_lib(10).solution='Verifier la/les valeurs correspondantes dans le fichier des usm';
% vs_lib(11).msgid='DEV:functionError';
% vs_lib(11).solution='Verifier les arguments en entree de la fonction (voir l''aide : help NomFonction) ';
% vs_lib(12).msgid='DEV:fileTypeError';
% vs_lib(12).solution='Verifier la conformite de l''extension du fichier (type de fichier attendu)';
% vs_lib(13).msgid='DEV:missingDataError';
% vs_lib(13).solution='Verifier les donnees dans le fichier d''entree correspondant';
% vs_lib(14).msgid='DEV:modelExecutionError';
% vs_lib(14).solution='Verifier l''origine du probleme dans le message produit par le modele';
% vs_lib(15).msgid='DEV:modelOutputError';
% vs_lib(15).solution='Verifier les conditions d''execution du modele bloquant la production des fichiers de sortie';
% vs_lib(16).msgid='DEV:outputDataError';
% vs_lib(16).solution='Verifier les donnees des fichiers de sortie';
% vs_lib(17).msgid='DEV:inputDataError';
% vs_lib(17).solution='Verifier les donnees des fichiers d''entree';
% vs_lib(18).msgid='DEV:modelExeNameError';
% vs_lib(18).solution='Le nom de l''executable du modele est erronne ou inexistant';
