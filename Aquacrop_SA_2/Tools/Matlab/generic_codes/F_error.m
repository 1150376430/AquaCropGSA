function [v_error_solution,v_last_error]=F_error(v_last_error,v_comment,v_stop)
%F_ERROR  Generation/formatage d'un message d'erreur detaille
%   F_error(v_last_error,v_comment,v_stop)
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_last_error : structure du type lasterror
%      - v_comment : indication sur la source de l'erreur
%      - v_stop : 1 si declenchement de l'arret 0 sinon (information
%      seulement)
%  
%   SORTIE(S): aucun
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_errors_lib : retourne la structure referencant les erreurs
%      recensees
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_error(v_err,'La valeur est erronee.',0)
%      - F_error(v_err,'Le fichier n''existe pas !',1)
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 24-Jul-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-05-17 10:39:37 +0200 (ven., 17 mai 2013) $
%    $Author: plecharpent $
%    $Revision: 890 $
%  
%  
% See also F_errors_lib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variable affichage
global v_display;
F_set_display;
% environnement
v_deployed=isdeployed;

% Gestion args entree
if nargin<3
    v_stop=0;
end
if nargin<2
   v_comment=''; 
end

% variable de debuggage
global v_debug;
if isempty(v_debug)
    v_debug=0;
end
v_msg_id=v_last_error.identifier;
% chargement de la structure qui contient la base de connaissance
v_errors_lib=F_get_errors_lib(v_msg_id);
% verification dans base connaissance que l'id du message existe
% si il n'existe pas afficher un message pour indiquer que l'identifiant
% n'est pas reference, mais afficher le contenu du v_msg_txt
v_error_num=F_get_error_num(v_errors_lib,v_msg_id);
if isempty(v_error_num)
    v_msg_id=v_errors_lib(1).msgid;
    v_error_num=F_get_error_num(v_errors_lib,v_msg_id);
end
if ~v_error_num
    v_error_solution=sprintf('Se referer a l''aide Matlab (%s)',v_msg_id);
else
    v_error_solution=v_errors_lib(v_error_num).solution;
end
% modification du message si erreur non referencee
v_last_error.identifier=v_msg_id;
% Sortie si on demande les arg en retour seulement
if nargout
   return 
end
% Si v_display == false pas d'affichage du message d'erreur
F_display_error(v_last_error,v_error_solution,v_comment,v_stop);
%

% pour arret execution du programme source de l'erreur
if v_stop
    % traitement lie au fichier de log
    if ~isempty(F_log('file'))
        F_log('Arret de l''execution du programme...');
        F_log('finish');
    end
    % Fermeture des fichiers restes ouverts
    fclose('all');
    % Affichage
    if ~v_display
        % Pour l'instant : concatenation simple des infos normalement mise 
        % en forme via F_display_error lors affichage des infos
        v_last_error.message=sprintf('%s \n%s\n%s',v_last_error.message,v_comment,v_error_solution);
        rethrow(v_last_error)
    else
        if ~v_deployed
            F_disp('           Appuyer sur <a href="matlab:">Ctrl+C</a> pour arreter l''execution du programme');
            
        else
            F_disp('           Appuyer sur Ctrl+C pour arreter l''execution du programme');
        end
        F_disp(sprintf('\n\n\n\n\n'));
        pause(200);
    end
end
%
% fonction retournant la structure des erreurs referencees
% avec modif de la solution pour erreur non referencees (indice=1)
function v_errors_lib = F_get_errors_lib(v_msg_id)
v_empty_msg_id='';
% structure contenant identifiants et solution dans F_errors_lib.m
v_tag='';
if ~isempty(v_msg_id)
    vc_splits=F_str_split(v_msg_id,':');
    if length(vc_splits)>1
        v_tag=vc_splits{1};
    end
end
v_errors_lib=F_errors_lib(v_tag);
if isempty(F_get_error_num(v_errors_lib,v_msg_id))
    v_errors_lib(1).solution=sprintf(v_errors_lib(1).solution,'       ',v_msg_id);
else
    v_errors_lib(1).solution=sprintf(v_errors_lib(1).solution,'',v_empty_msg_id);
end
%   
% Recuperation de l'indice de l'erreur dans v_errors_lib
% si c'est une erreur levee par matlab v_error_num=0
function v_error_num = F_get_error_num(v_errors_lib,v_msg_id)
if strmatch('MATLAB:',v_msg_id)
    v_error_num=0;
else
    v_error_num=strmatch(v_msg_id,{v_errors_lib.msgid},'exact');
end
%
% Fonction d'affichage de l'erreur: boete de dialogue + message complet
% dans fenetre de commmandes
function F_display_error(err,v_error_solution,v_comment,v_stop)
%clc
global v_debug;
global v_display
F_set_display;
% environnement
v_deployed=isdeployed;

v_l_marg='  ';
v_tab1=[v_l_marg '   - '];
v_tab2=[v_l_marg '       '];
v_tab3=[v_l_marg '           '];

v_hline=[v_l_marg repmat('-',1,90)];
F_disp(sprintf('\n\n\n\n\n'));
F_disp(v_hline);
[v_err,v_source]=strtok(err.message,sprintf('\n'));
%
if v_stop
    if v_display && ~v_deployed
        F_disp('                              <a href=".">>>>>>>>>> ERREUR >>>>>>>>>></a>'); 
    else
        F_disp('                              >>>>>>>>> ERREUR >>>>>>>>>>');
    end
else
    F_disp('                              >>>>>>>>>> ATTENTION >>>>>>>>>>'); 
end
if v_debug
    F_disp(sprintf('\n%sIdentifiant \t>> %s',v_tab2,err.identifier));
end
F_disp(v_hline);
F_disp(sprintf('%sMessage: \n%s%s',v_tab1,v_tab2,strrep(v_err,'Error using','Erreur lors de l''utilisation de')));
if ~isempty(v_source)
    % suppression of leading '\n', adding leading tab
    v_source=[v_tab2 v_source(strcmp(v_source(1),sprintf('\n'))+1:end)];
    F_disp(sprintf('%sSource:\n%s%s',v_tab1,strrep(v_source,sprintf('\n'),[sprintf('\n') v_tab2])));
end

F_disp(sprintf('%sCommentaire:\n%s%s',v_tab1,v_tab2,v_comment));
F_disp(sprintf('%sPiste: \n%s%s',v_tab1,v_tab2,v_error_solution));
if v_debug && v_stop
    if strmatch(err.identifier,'MSLIB:undefinedErrorId')
        v_deb=2;
    else
        v_deb=1;
    end
    if ~isempty(err.stack)
        F_disp(sprintf('%sInfos debogage: ',v_tab1));
        F_disp(sprintf('%sSource:',v_tab2));
        for i=v_deb:length(err.stack)
            if i>v_deb
                F_disp(sprintf('%sAppele par',v_tab2));
            end
            if v_display && ~v_deployed
                F_disp(sprintf('%sFichier: <a href="matlab:edit %s">%s</a>',v_tab3,err.stack(i).file,err.stack(i).name));
            else
                F_disp(sprintf('%sFichier: %s',v_tab3,err.stack(i).file));
            end
            F_disp(sprintf('%sLigne: %d',v_tab3,err.stack(i).line));
        end
    end
end
F_disp(v_hline);
F_disp(' ');
F_disp(' ');
