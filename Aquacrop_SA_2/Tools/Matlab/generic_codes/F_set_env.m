function F_set_env(v_action_key,varargin)
%F_SET_ENV  definition variable(s) globale(s) v_display,v_pause
%   v_action = F_set_env([v_disp,v_forc])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      v_action_key: nom d'action associe e une variable globale qui permet
%      d'activer ou desactiver: l'affichage ecran ('display'), 
%      l'execution de pause ('pause'), l'ecrasement / suppression de
%      fichiers ('overwrite')
%
%      Arguments optionnels
%      - v_switch : 'on ou 'off' pour activer ou non l'action
%      - v_forc : 'deployed' pour forcer l'action en environnement compile
%      (par defaut en environnement compile desactivee)
%  
%   SORTIE(S): affectation des variables globales v_display, v_pause
%              ou v_overwrite
%
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_set_env('display','on')
%      - F_set_env('display','off')
%      - F_set_env('pause','on','deployed')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 01-Apr-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%  
% See also F_test_mfile_rev,warning,isdeployed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vc_action_keys={'display','pause','overwrite'};
vc_default_values={true true false};
vc_set_keys={'on','off'};
vc_disp_values={true,false};
vc_forc_keys={'deployed'};

if ~nargin || ~ismember(v_action_key,vc_action_keys)
   return 
end

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

F_test_mfile_rev('F_set_env','$Revision: 940 $',v_args{:})

% globale variable creation: v_display, v_pause
eval(['global v_' v_action_key])
eval(['v_local_action=v_' v_action_key ';']);

% Stockage si environnement compile/deploye
v_deployed=isdeployed;
%
v_forc_cmd='';
v_action_cmd='';

% Traitement des arguments
nargs=numel(varargs);
for i=1:nargs
    if ismember(varargs{i},vc_set_keys)
        v_action_cmd=varargs{i};
    end
    if ismember(varargs{i},vc_forc_keys)
        if v_deployed
            v_forc_cmd=varargs{i};
        end
    end
end



% recherche action idx
v_action_idx=ismember(vc_action_keys,v_action_key);
% default value
v_default=vc_default_values{v_action_idx};


% Switch sur le nb d'arguments
switch nargs
    case 0
        if isempty(v_local_action)
            if ~v_deployed
                v_local_action=v_default;
            else
                v_local_action=~v_default;
            end
        end
    case {1,2}
        if ismember(v_action_cmd,vc_set_keys)
            if ~isempty(v_forc_cmd)
                v_local_action=v_default;
            else
                if ~v_deployed
                    v_local_action=vc_disp_values{strcmp(v_action_cmd,vc_set_keys)};
                else
                    v_local_action=~v_default;
                end
            end
        end
        
end

% Gestion des warnings
if ~v_local_action
    warning off all;
else
    warning on all;
end
v_action_str='true';
if ~v_local_action
    v_action_str='false';
end

% Setting value to global var
eval(['v_' v_action_key '=' v_action_str ';']);
