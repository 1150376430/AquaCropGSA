function v_answer = F_can_i_create_file(v_dir,v_filename,v_loc_overwrite)
%F_CAN_I_CREATE_FILE  Gestion demande ecrasement ou sauvegarde d'un fichier
%
%   args_sortie = F_can_i_create_file(args_entree)   Liste detaillee les arguments d'entree/sortie
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_dir : chemin du fichier a creer
%      - v_filename : nom du fichier que l'on souhaite creer (comprenant
%      l'extension mais pas le chemin)
%      - v_loc_overwrite: to set locally forcing overwriting files
%  
%   SORTIE(S): descriptif des arguments de sortie
%      - v_answer : true si on peut creer le fichier false sinon
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - F_user_input
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%    if F_can_i_create_file(v_dir,v_pdf_name)
%        ... commande pour creer le fichier ...
%    end
%  
%  AUTEUR(S): S. Buis
%  DATE: 25-Feb-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-09-25 08:05:44 +0200 (mer., 25 sept. 2013) $
%    $Author: plecharpent $
%    $Revision: 975 $
%  
%  
%  See also: F_set_overwrite, F_set_display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global v_overwrite;
F_set_overwrite;

if nargin<3
    v_loc_overwrite=v_overwrite;
else
    v_overwrite_sav=v_overwrite;
    v_overwrite=v_loc_overwrite;
end

v_fullfile=fullfile(v_dir,v_filename);
v_answer=true;
if ~isempty(v_dir) && ~exist(v_dir,'dir')
    F_disp(sprintf('\nLe repertoire %s n''existe pas \nLe fichier %s ne sera pas cree !',v_dir,v_filename),'log');
    v_answer=false;
    return;
end
if exist(v_fullfile,'file')
    if ~v_loc_overwrite
        F_disp(sprintf('Le fichier %s existe deja dans %s. \n',v_filename,v_dir));
        v_del=F_user_input('Ecraser ?',{'oui','oui pour tous','non (Pas de sauvegarde)'},{'oui','tous','non'});
        if strcmp(v_del,'tous') 
          v_loc_overwrite=1;
          v_overwrite=v_loc_overwrite;
        end
    end
    if v_loc_overwrite || strcmp(v_del,'oui')
        try
            warning('OFF','MATLAB:DELETE:Permission');
            delete(v_fullfile);
            if exist(v_fullfile,'file')
                error('Probleme sur un fichier');
            end
        catch
            F_create_message(v_fullfile,'Le fichier n''a pu etre efface. Verifier les droits ou son utilisation par une autre application',...
                1,1,lasterror);
        end
        warning('ON','MATLAB:DELETE:Permission');
        if v_loc_overwrite
            F_disp(sprintf('L''ancien fichier %s a ete ecrase. \n',v_filename),'log');
        else
            F_disp(sprintf('L''ancien fichier %s va etre ecrase. \n%s',v_filename,'Appuyer sur "Entree" pour continuer'),'log');
        end
    else
        F_disp(sprintf('Le nouveau fichier %s ne sera pas cree. \n',v_filename));
        v_answer=false;
    end
end
% retablissement de la valeur de depart
if exist('v_overwrite_sav','var')
   v_overwrite=v_overwrite_sav; 
end

