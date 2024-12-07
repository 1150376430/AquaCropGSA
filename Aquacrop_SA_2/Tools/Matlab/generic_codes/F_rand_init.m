function v_seed=F_rand_init(varargin)
% Initialisation pour les tirages aleatoires.
%
%   ENTREE(S): descriptif des arguments d'entree
%      - v_seed (OPTIONNEL) : graine pour initialiser la suite aleatoire. 
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_seed : graine utilisee pour les futurs tirages aleatoires
%
%   CONTENU: descriptif de la fonction
%      On defini la methode de tirage (twister, la methode par defaut dans
%      Matlab), et une graine soit donnee par l'utilisateur soit qui depend de la date-heure, pour que la
%      suite soit differente a chaque execution de Matlab 
%
%   APPEL(S): liste des fonctions appelees
%      - rand
%
%  AUTEUR(S): S. Buis
%  DATE: 25-Juil-2008
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin==1) && (~isempty(varargin{1}))
    v_seed=varargin{1};
else
    v_seed=sum(100*clock);
end

try 
    RandStream.setGlobalStream (RandStream('mt19937ar','Seed',v_seed));
catch
    rand('twister',v_seed);
end
