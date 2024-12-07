function [u]=F_unif2loi(v,v_distribution_law,v_p1,v_p2)
% Transformation loi uniforme [0,1] --> loi specifiee
%
% Cette fonction sert a transformer la variable uniforme v appartenant a 
% [0;1] en une variable u de loi de distribution specifiee dans 
% "v_distribution_law"
%
% ENTREES :
%       - v : 
%          vecteur de type flottant contenant les valeurs de la
%          variable a transformer
%
%       - v_distribution_law : 
%          scalaire entier contenant le code de la loi
%          de distribution choisie
%                              1:uniforme, 2:normale, 3:exponentielle,
%                              4:weibull, 5:Gamma, 6:Student, 7:beta,
%                              8:chi2, 9:lognormale
%          ATTENTION: pour v_distribution_law(i)>1, il est necessaire 
%          d'avoir la toolbox matlab "statistics".
%
%       - v_p1 : 
%          1er parametre de la loi
%
%       - v_p2 : 
%          2eme parametre de la loi
%       
%
% SORTIE :
%       - u : 
%          vecteur de type flottant contenant les valeurs de la
%          variable transformee
%
% CONTENU :
%

% AUTEUR : S. BUIS
% DATE : 04-mai-2007
% VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if v_distribution_law==1 % loi uniforme entre v_p1 et v_p2
           u=v.*(v_p2-v_p1)+v_p1;
        end
        if v_distribution_law==2 % loi normale N(v_p1,v_p2) 
            %u=erfinv(2.*v-1).*v_p2+v_p1
            u=norminv(v,v_p1,v_p2);
        end
        if v_distribution_law==3 % loi Expo E(v_p1)
            u=expinv(v,v_p1);
        end
        if v_distribution_law==4 % Weibull W(v_p1,v_p2)
            u=weibinv(v,v_p1,v_p2);
        end
        if v_distribution_law==5 % Gamma G(v_p1,v_p2)
            u=gaminv(v,v_p1,v_p2);
        end
        if v_distribution_law==6 % student t(v_p1)
            u=tinv(v,v_p1);
        end
        if v_distribution_law==7 % beta B(v_p1,v_p2)
            u=betainv(v,v_p1,v_p2);
        end
        if v_distribution_law==8 % chi2 X2(v_p1)
            u=chi2inv(v,v_p1);
        end
        if v_distribution_law==9 % lognormale LN(v_p1,v_p2)
            u=logninv(v,v_p1,v_p2);
        end
