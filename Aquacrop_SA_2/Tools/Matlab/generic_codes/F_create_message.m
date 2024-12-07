function F_create_message(v_input_name,v_text_header,v_status,v_mess_status,varargin)
%F_CREATE_MESSAGE  Generation d'un message ou d'une erreur
%   F_create_message(v_input_name,v_text_header,v_status,v_mess_status [,v_lasterror])
%  
%   ENTREE(S): 
%      - v_input_name : nom de variable ou autre indication a afficher
%      - v_text_header : chaine de caratere d'information
%      - v_status : succes 1 ou echec 0 (du test defini par ailleurs)
%      - v_mess_status :  status du message a afficher : 1 erreur, 0 info 
%      Optionnel :  
%      - vs_last_error: structure correspondant a la derniere erreur produite
%      ou un objet MException 
%  
%   SORTIE(S): 
%      - aucun argument
%      - affichage message a l'ecran direct ou via F_error si une erreur
%      est levee
%  
%   CONTENU: 
%      
%  
%   APPEL(S): 
%      - 
%  
%   EXEMPLE(S): 
%      F_create_message(v_conf.Options.ModelName,'Nom du modele errone',1,1,lasterror)
%
%     ??? Error using ==> F_create_message
%      >>> ERREUR <<< 
%     => Stics : Nom du modele errone
%
%      F_create_message('NomVariable','Valeur manquante',1,0)
%
%        NomVariable : Valeur manquante .... (Info)
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 06-Dec-2006
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-07 16:28:30 +0200 (ven., 07 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 916 $
%  
%
% See also F_set_display, F_disp, F_error, F_disp,MException
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% environnement 
v_deployed=isdeployed;
%  On fixe le controle des erreurs et affichages : infos,erreurs
if v_status
    global v_display;
    F_set_display;
    v_sep_line=repmat('-',1,80);
    v_pause=0;
    v_message_id='undefined%s';
    %
    switch nargin
        case 5
            switch class(varargin{1})
                case 'char'
                    if strmatch(varargin{1},'pause','exact')
                        v_pause=1;
                    end
                case {'struct','MException'}
                    vs_error_to_throw=F_gen_error_struct(varargin{1});
            end
    end
    
    if isnumeric(v_input_name)
        v_input_name=num2str(v_input_name);
    end
    if iscellstr(v_input_name)
        v_input_name=sprintf('%s\n',v_input_name{:});
    end
    if v_mess_status
            if ~exist('vs_error_to_throw','var') % on cree la structure d'erreur
               vs_error_to_throw=F_gen_error_struct(sprintf(v_message_id,'Error'),...
                   'Erreur inconnue, voir le commmentaire');    
            end
            v_comment=sprintf('=> %s : \n         %s',v_input_name,v_text_header);
            F_error(vs_error_to_throw,v_comment,1);           
    else
        if ~exist('vs_error_to_throw','var')
            v_status=sprintf('\nINFO');
            v_message_id=sprintf(v_message_id,'Info');
            if v_display && ~v_deployed
                v_status=sprintf('\n<a href=".">INFO</a>');
            end
            
            v_arg={};
            if v_pause
                v_arg={'pause'};
            end
            F_disp(sprintf('%s\n%s\n%s\n%s\n => %s : %s\n',v_sep_line,v_status,v_message_id,v_sep_line,v_input_name,v_text_header),v_arg{:});
                
        else
            v_comment=sprintf('=> %s : \n       %s',v_input_name,v_text_header);
            F_error(vs_error_to_throw,v_comment,0);
        end
    end
end
