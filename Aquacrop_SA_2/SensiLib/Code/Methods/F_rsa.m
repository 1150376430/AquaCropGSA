function [v_h,v_p,v_ks2stat] = F_rsa(v_mat_variant1,v_mat_variant2,varargin)
% Fonction pour l'analyse de sensibilite regionale : calcul du critere
% statistique et trace de graphiques.
%
%   ENTREES :
%       - v_mat_variant1 : 
%          matrice de type flottant de taille : 
%             N1 * no de parametres variant
%          contenant l'echantillon filtre de valeurs des parametres 
%       - v_mat_variant2 : 
%          matrice de type flottant de taille : 
%             N2 * no de parametres variant
%          contenant l'echantillon complementaire de valeurs des parametres 
%       - vc_parname (OPTIONNEL): 
%          cell a 1 dimension de taille : no de parametres
%          contenant le nom des differents parametres a imprimer sur les graphiques 
%          (x1,x2,... par defaut si cet argument n'est pas fourni)
%       
%   SORTIES :
%       - v_h : vecteur de type flottant de taille le nombre de parametres 
%          contenant les resultats du test de Kolmogorov-Smirnov pour les
%          differents parametres (1 si la distribution du premier
%          echantillon est significativement differente de celle du
%          deuxieme echantillon)
%       - v_p : vecteur de type flottant de taille le nombre de parametres 
%          contenant les p-value pour chaque parametre (plus petit niveau pour 
%          lequel on rejette l'hypothese d'egalite entre les distributions)
%       - v_ks2stat : vecteur de type flottant de taille le nombre de parametres 
%          contenant les valeurs de la statistique du test (max(|F1(x)-F2(x)|) 
%          pour chaque parametre.
%
%       + trace des graphiques des fonctions de distribution cumulatives des 
%         deux echantillons pour chaque parametre. 
%
%   AUTEUR : S. BUIS
%   DATE : 12-mai-2010
%   VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-10-23 16:17:24 +0200 (mer., 23 oct. 2013) $
%    $Author: sbuis $
%    $Revision: 73 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_nb_par=size(v_mat_variant1,2);
v_nb_maxcol=5;
v_nb_maxrow=5;
v_nb_fig_max=v_nb_maxcol*v_nb_maxrow;

if (length(varargin)==0) || isempty(varargin{1})
    for i=1:v_nb_par
        vc_parname{i}=['x' num2str(i)];
    end
else
    vc_parname=varargin{1};
end

for i=1:v_nb_par

    % Realise le test de Kolmogorov-Smirnov
    [v_h(i),v_p(i),v_ks2stat(i)] = kstest2(v_mat_variant1(:,i),v_mat_variant2(:,i));

end

[v_ks2statSort,isort]=sort(v_ks2stat,2,'descend');
figure
j=1;
v_S=zeros(v_nb_par,1);
for i=1:v_nb_par
    if (j>v_nb_fig_max) 
        figure
        j=1;
    end
    subplot(min(ceil(sqrt(v_nb_par)),v_nb_maxrow),min(ceil(v_nb_par/ceil(sqrt(v_nb_par))),v_nb_maxcol),j)
    handle1 = cdfplot(v_mat_variant1(:,isort(i)));
    set(handle1,'LineStyle',':')
    hold on
    handle2 = cdfplot(v_mat_variant2(:,isort(i)));
    set(handle2,'LineStyle','-.')
    handle3 = cdfplot([v_mat_variant1(:,isort(i));v_mat_variant2(:,isort(i))]);
    legend([handle1 handle2 handle3],'F1(x)','F2(x)','F(x)','Location','SW')
    title(strcat(vc_parname{isort(i)},' - \alpha=',num2str(v_p(isort(i))),' - d_{m,n}=',num2str(v_ks2stat(isort(i)))))
    j=j+1;
end
