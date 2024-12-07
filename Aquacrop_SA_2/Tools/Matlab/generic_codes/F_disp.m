function F_disp(v_str,varargin)
%F_DISP  gestion d'affichage de chaines ou ecriture de log
%   F_disp(v_str,v_key)
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_str : chaine de caracteres a afficher
%      optionnel:
%      - v_key : 'pause' , activer une pause pres affichage de v_str,
%                'log' pour activer l'ecriture dans un fichier de log
%                'stop' pour indiquer l'arret
%
%   SORTIE(S):
%      - aucun arg
%      - affichage a l'ecran ou non selon la valeur de la variable globale
%      ou ecriture dans le fichier de log
%
%   CONTENU: en fonction de la valeurs de v_display affichage d'une
%   chaine de caracteres a l'ecran avec pause eventuelle, ou ecriture de la
%   chaine dans un fichier de log.
%
%   APPEL(S): liste des fonctions appelees
%      -
%
%   EXEMPLE(S):
%      - F_disp('Le texte a afficher')
%      - F_disp('Le texte a afficher','pause') si v_display=true
%      - F_disp('Le texte a afficher','nolog') si v_display=false
%
%  AUTEUR(S): P. Lecharpentier
%  DATE: 27-Apr-2009
%  VERSION: 0
%
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-26 17:54:09 +0200 (mer., 26 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 956 $
%
%
% See also F_test_mfile_rev,F_set_display, F_log, isdeployed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Test de la revision du fichier pour la version stockee dans le
% repertoire temporaire de multisimlib
v_args={};
varargs={};

v_logical_arg=cellfun(@islogical,varargin);
if any(v_logical_arg)
    v_args=varargin(v_logical_arg);
    varargs=varargin(~v_logical_arg);
else
    varargs=varargin;
end
F_test_mfile_rev('F_disp','$Revision: 956 $',v_args{:})


% On fixe la variable d'affichage
global v_display;
F_set_display(v_args{:});
global v_pause;
F_set_pause(v_args{:});

global v_overwrite;
F_set_overwrite;

% Variable definissant le type d'environnement
v_dep_str='notdeployed';
v_deployed=isdeployed;
if v_deployed
    v_dep_str='deployed';
end
% valeurs possibles pour keys
vc_keys={'pause' 'stop'};
% Structure contenant les messages
vs_msg.pause.deployed=sprintf('\nAppuyer sur "Entree" pour continuer \n(ou "Ctrl+c" pour arreter le programme)');
vs_msg.pause.notdeployed=sprintf('\n<a href=".">Appuyer sur "Entree" pour continuer \n(ou "Ctrl+c" pour arreter le programme)</a>');
vs_msg.stop.deployed=sprintf('\nAppuyer sur "Ctrl+c" pour arreter le programme)');
vs_msg.stop.notdeployed=sprintf('\n<a href=".">Appuyer sur "Ctrl+c" pour arreter le programme</a>');

% Si on ne fourni pas d'argument
nargs=nargin-numel(v_args);
if nargs<1
    v_str=' ';
else
    v_str=num2str(v_str);
end
% Affichage ou ecriture dans le fichier de log
if v_display
    disp(v_str)
    if nargs==2
        v_key=varargs{1};
        if ismember(v_key,vc_keys)
            if v_pause
                disp(vs_msg.(v_key).(v_dep_str));
            end
        end
        if strcmp(v_key,'stop')
            % 200: because inf argument is not efficient under linux
            % platforme!
            F_pause(10000);
        elseif  ~v_overwrite
            F_pause;
        end
    end
    
else
    if nargs==2 && strcmp(varargs{1},'nolog')
        % on ne fait rien.
    else % ecriture de v_str dans le fichier de log
        F_log(v_str);
    end
end

    function F_pause(varargin)
        if v_pause
            v_args=varargin;
            pause(varargin{:});
        end
    end

end