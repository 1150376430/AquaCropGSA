function F_set_pause(varargin)
%F_SET_PAUSE  definition variable globale v_pause: affichage infos ecran
%   v_pause_out = F_set_pause([v_disp,v_forc])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      Arguments optionnels
%      - v_pause : 'on ou 'off' pour effectuer une pause ou non
%      - v_forc : pour forcer la pause en environnement compile
%      par defaut en environnement compile la pause desactivee
%  
%   SORTIE(S): descriptif des arguments de sortie
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_set_pause('on')
%      - F_set_pause('off')
%      - F_set_pause('on','deployed')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 01-Apr-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-09-27 13:35:21 +0200 (ven., 27 sept. 2013) $
%    $Author: plecharpent $
%    $Revision: 980 $
%  
%  
% See also F_set_env, F_test_mfile_rev,warning,isdeployed, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Test de la revision du fichier pour la version stockee dans le 
% repertoire temporaire de multisimlib
v_args={};

v_logical_arg=cellfun(@islogical,varargin);
if any(v_logical_arg)
    v_args=varargin(v_logical_arg);
    varargs=varargin(~v_logical_arg);
else
    varargs=varargin;
end

F_test_mfile_rev('F_set_pause','$Revision: 980 $',v_args{:})

F_set_env('pause',varargs{:});

