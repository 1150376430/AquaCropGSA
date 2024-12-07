function F_set_display(varargin)
%F_SET_DISPLAY  definition variable globale v_display: affichage infos ecran
%   v_display_out = F_set_display([v_disp,v_forc])
%  
%   ENTREE(S): descriptif des arguments d'entree
%      Arguments optionnels
%      - v_disp : 'on ou 'off' pour afficher ou non les retours ecran
%      - v_forc : pour forcer l'affichage en environnement compile
%      par defaut en environnement compile l'affichage est desactive
%  
%   SORTIE(S): descriptif des arguments de sortie
%  
%   CONTENU: descriptif de la fonction
%  
%   APPEL(S): liste des fonctions appelees
%      - 
%  
%   EXEMPLE(S): cas d'utilisation de la fonction
%      - F_set_display('on')
%      - F_set_display('off')
%      - F_set_display('on','deployed')
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

F_test_mfile_rev('F_set_display','$Revision: 940 $',v_args{:})

F_set_env('display',varargs{:});

