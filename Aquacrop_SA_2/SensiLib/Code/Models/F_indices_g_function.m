function[v_indlist,v_S,v_ST]=F_indices_g_function(v_a)
% Indices de sensibilite theoriques de la fonction g de Sobol'
%
% Fonction de calcul des valeurs theoriques des
% indices de sensibilite de la fonction g de Sobol'.
%  
%   ENTREE(S): descriptif des arguments d'entree
%      - v_a : 
%         vecteur de type reel de taille (nombre de parametres x)
%         contenant les valeurs des parametres ai qui definissent la
%         fonction g. 
%  
%
%   SORTIE(S): descriptif des arguments de sortie
%      - v_indlist : 
%         vecteur de type entier, de taille le nombre total d'indices de 
%         sensibilite (a tous les ordres, mais sans les indices totaux), 
%         contenant le nom des indices donnes dans v_S (i correspond a 
%         l'indice principal Si, ij e l'indice de second d'ordre Sij, ...) 
%
%      - v_S : 
%         vecteur de type reel, de taille le nombre total d'indices de
%         sensibilite (a tous les ordres, mais sans les indices totaux),
%         contenant la valeurs des indices de sensibilite de la fonction g  
%         a tous les ordres. 
%         Pour avoir l'indice principal Si, utiliser v_S(find(v_indlist==i)).
%         Pour avoir l'indice d'ordre 2 Sij, utiliser v_S(find(v_indlist==ij))
%
%      - v_ST : 
%         vecteur de type reel, de taille le nombre de parametres xi 
%         de la fonction g, contenant la valeurs des indices de sensibilite 
%         totaux de la fonction g. 
%
%
%   APPEL(S): liste des fonctions appelees
%      - F_creer_matrice, F_ecrit_indice
%  
%  
%  AUTEUR(S): S. Buis
%  DATE: 31-Aug-2007
%  VERSION: 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%  
% See also F_gen_matindice_vs, F_ecrit_indice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcul du nombre de parametres et initialisation diverses
v_nb_par=length(v_a);
v_S=[];
v_ST=zeros(v_nb_par,1);

% Calcul de la variance totale D.
v_Dtemp=1.;
for i=1:v_nb_par
    v_Di(i)=1/(3*(1+v_a(i))^2);
    v_Dtemp=v_Dtemp*(1+v_Di(i));
end
v_D=v_Dtemp-1;

% Creation de la matrice pour definir l'ordre de calcul des indices
% principaux
[v_M]=F_gen_matindex_vs(v_nb_par);

% Calcul du nombre total d'indices principaux
v_nb_main_indices=0;
for i=1:v_nb_par
    v_nb_main_indices=v_nb_main_indices+nchoosek(v_nb_par,i);
end
if ((size(v_M,1)-1)~=v_nb_main_indices) 
        error('Erreur dans le nombre d''indices principaux.');
end


% Calcul des indices principaux et totaux
v_indcount=1;
%   Boucle sur les indices principaux de tous les ordres
for i=2:size(v_M,1)
	%ex: pour la ligne 0101 de M, k=[2 4]
    v_k=[];
	v_k=find(v_M(i,:));
     
    if length(v_k)==1 
       % calcul de l'indice principal de 1er ordre du facteur k
       v_indlist(v_indcount)=v_k;
       v_S(v_indcount)=v_Di(v_k)/v_D;

    else
       % calcul de l'indice principal d'ordre length(k) concernant les
       % facteurs listes dans k.
        
       ll=F_write_index(v_k);
       v_indlist(v_indcount)=ll;

       v_S(v_indcount)=1;
       for l=1:length(v_k)
          v_S(v_indcount)=v_S(v_indcount)*v_Di(v_k(l));
       end
       v_S(v_indcount)=v_S(v_indcount)/v_D;
       
    end

    % Ajout de l'indice calcule dans tous les indices totaux dans lesquels
    % il est implique
    for l=1:length(v_k)
       v_ST(v_k(l))=v_ST(v_k(l))+v_S(v_indcount);
    end

    v_indcount=v_indcount+1;

end
