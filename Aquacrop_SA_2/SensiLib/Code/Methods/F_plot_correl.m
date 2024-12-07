function [v_corrcoef,v_p_values]=F_plot_correl(v_mat_variant,vc_parname)
% Trace des histogrammes des parametres et des nuages de points des parametres 
% les uns en fonction des autres ainsi que des valeurs de leur correlations.
%
% ENTREES :
%       - v_mat_variant : 
%          matrice de type flottant de taille : 
%             ne de simulations * ne de parametres variant
%          contenant l'echantillon de valeurs des parametres 
%
%       - vc_parname : 
%          cell e 1 dimension de taille : ne de parametres
%          contenant le nom des differents parametres.
%
% SORTIE :
%       - v_corrcoef : matrice des correlations entre parametres
%
%       - v_p_values : p-values associees aux correlations (chaque p-value 
%         est la probabilite d'avoir une correlation aussi grande avec 
%         des observations aleatoires theoriquement independantes). 
%
%       Figures
%
%
%
% CONTENU :
%
% AUTEUR : S. BUIS
% DATE : 05-mars-2010
% VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_nb_par=length(vc_parname);

figure
subplot(1,2,1)
tmp=zeros(v_nb_par+1,v_nb_par+1);
v_p=zeros(v_nb_par+1,v_nb_par+1);
[tmp(1:v_nb_par,1:v_nb_par),v_p(1:v_nb_par,1:v_nb_par)]=corrcoef(v_mat_variant);
pcolor(tmp)
set(gca,'XTick',1.5:v_nb_par+0.5)
set(gca,'XTickLabel',vc_parname)
set(gca,'YTick',1.5:v_nb_par+0.5)
set(gca,'YTickLabel',vc_parname)
colorbar
title('Correlations entre les parametres')
subplot(1,2,2)
pcolor(v_p)
set(gca,'XTick',1.5:v_nb_par+0.5)
set(gca,'XTickLabel',vc_parname)
set(gca,'YTick',1.5:v_nb_par+0.5)
set(gca,'YTickLabel',vc_parname)
colorbar
title('p-value associees')
v_corrcoef=tmp(1:v_nb_par,1:v_nb_par);
v_p_values=v_p(1:v_nb_par,1:v_nb_par);

figure
[H,AX] = plotmatrix(v_mat_variant);
for i=1:v_nb_par
    title(AX(1,i),vc_parname{i})
    ylabel(AX(i,1),vc_parname{i})
end
