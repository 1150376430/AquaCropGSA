function v_val_choice = F_user_input(v_question,vc_list,v_check,v_default)
% Fait saisir à l'utilisateur une variable parmi une liste proposee
%   v_val_choice = F_user_input(v_question,vc_list,v_check)
%   ENTREE(S): descriptif des arguments d'entree
%      - v_question: string de la question a afficher pour guider
%      l'utilisateur
%      - vc_list: cell array of strings, liste des choix a proposer a l'utilisateur
%      - v_check: cell, cell   of strings, logical, numeric
%         liste indiquant les choix a retourner 
%      - v_default : reponse par defaut 
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_val_choice: variable (tout type) qui est retournee par la
%      fonction, elle sera une valeur de v_check
%
%   CONTENU: descriptif de la fonction
%       La fonction F_user_input propose egalement le choix 'exit' si
%       l'utilisateur saisi 0 et retourne la valeur -1.
%       Une boucle est faite jusqu'a ce que l'utilisateur saisisse le
%       chiffre approprie correpondant a l'indice du choix parmi la liste
%       proposee
%
%   EXEMPLE(S): cas d'utilisation de la fonction
%       v_val_choice = F_user_input('couleur ?',{'Bleu','Rouge'},{'b','r'})
%       
%       Quelle couleur ?
% 1 Bleu
% 2 Rouge
% 0 Exit
%       
% retournera 'b' ou 'r' ou -1 selon si l'utilisateur tape 1 , 2 ou 0
%
%  AUTEUR(S): J. Bourges, P. Lecharpentier
%  DATE: 07-Feb-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-07 14:15:34 +0200 (ven., 07 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 912 $
%  
% See also F_test_mfile_rev,F_set_display,F_disp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
F_test_mfile_rev('F_user_input','$Revision: 912 $',true)

% On fixe la variable d'affichage
global v_display;
F_set_display;

% Verification du contenu de la liste de choix (type identique)
v_check_type=class(v_check);

% Si valeur par defaut non fournie,
% on affecte la premiere reponse comme la reponse par defaut
if ~exist('v_default','var')
    if iscell(v_check)
        v_default=v_check{1};
    else
        v_default=v_check(1);
    end
end
% Status de sortie du while
valid=0;
v_question_status=false;
while ~valid
    if ~v_question_status % si la question n'a pas encore ete posee
        F_disp(sprintf('\n%s',v_question));

        v_question_status=true;
        for i=1:length(vc_list)
            if ischar(vc_list{1})
                F_disp(sprintf('%s : %s',num2str(i),vc_list{i}));
            else
                F_disp(sprintf('%g : %s',num2str(i),vc_list{i}));
            end
        end
        F_disp('Ctrl-c pour stopper l''execution du programme.');
        F_disp(' ');
    end
    if ~v_display
        switch v_check_type
            case {'logical','numeric'}
                v_numchoice=find(v_check==v_default);
            case 'cellstr'
                v_numchoice=find(ismember(v_check,v_default));
            case 'cell'
                v_numchoice=find(cellfun(@(x) x==v_default,v_check));
        end 
    else
        v_numchoice=str2double(input('  Choix (numero): ','s'));
    end
    if ~isempty(v_numchoice) && any(v_numchoice==[0 1:length(vc_list)])
        valid=1;
        F_disp(' ');
    else
        if isnan(v_numchoice)
            F_disp(sprintf('\n Aucune valeur fournie, ou le choix n''est pas une valeur ...\n'));
        else
            F_disp(sprintf('\n %s n''est pas une valeur correcte \n',num2str(v_numchoice)));
        end
        if ~v_display
            v_numchoice=0;
            valid=1;
        end
    end
end

if ~v_numchoice
    v_val_choice=-1;
else
    if iscell(v_check)
        v_val_choice=v_check{v_numchoice};
    else
        v_val_choice=v_check(v_numchoice);
    end
    
end


  
