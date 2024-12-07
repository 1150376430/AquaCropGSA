function F_set_overwrite(varargin)
%F_SET_OVERWRITE  definition variable globale v_overwrite: affichage infos ecran
%   v_overwrite_out = F_set_overwrite([v_disp,v_forc])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      Arguments optionnels
%      - v_overwrite : 'on ou 'off' pour effectuer une overwrite ou non
%      - v_forc : pour forcer le overwrite en environnement compile
%      par defaut en environnement compile le overwrite desactivee
%  
%   SORTIE(S): descriptif des arguments de sortie
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_set_overwrite('on')
%      - F_set_overwrite('off')
%      - F_set_overwrite('on','deployed')
%  
%  AUTEUR(S): P. Lecharpentier
%  DATE: 01-Apr-2009
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-10-01 15:12:52 +0200 (mar., 01 oct. 2013) $
%    $Author: plecharpent $
%    $Revision: 985 $
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

F_test_mfile_rev('F_set_overwrite','$Revision: 985 $',v_args{:})

F_set_env('overwrite',varargs{:});

