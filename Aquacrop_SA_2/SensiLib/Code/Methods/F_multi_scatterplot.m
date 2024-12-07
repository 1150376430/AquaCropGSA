function [v_S,v_bandwith]=F_multi_scatterplot(v_mat_variant,vc_parname,v_mat_out,v_varname,varargin)
% Trac a  des nuages de points d'une variable de sortie en fonction des
% diff a rents param a tres variants et des regressions non param a triques par
% noyau, calcul approch a  des indices principaux.
% ATTENTION, les r a gressions et les valeurs des indices calcul a s peuvent
%  a tre tr a s d a pendants des valeurs du param a tre v_bandwith.
% 
%
% ENTREES :
%       - v_mat_variant : 
%          matrice de type flottant de taille : 
%             no de simulations * no de param a tres variant
%          contenant l' a chantillon de valeurs des param a tres 
%
%       - vc_parname : 
%          cell a 1 dimension de taille : no de param a tres
%          contenant le nom des diff a rents param a tres.
%
%       - v_mat_out :
%          vecteur de type flottant de taille : no de simulations
%          contenant les valeurs simul a es d'une variable (a 1 date) a
%          analyser. 
%
%       - v_varname : 
%          nom de la variable a analyser (string).
%
%       - v_bandwith (OPTIONNEL) :
%          Largeur de bande qui caract a rise l'amplitude de la zone
%          d'influence du noyau.
%          Si c'est un scalaire, la valeur fournie sera utilis a e pour
%          l'ensemble des param a tre, sinon, v_bandwith doit  a tre un vecteur
%          de taille le nombre de param a tres.
%          Si cet argument n'est pas fourni, une valeur par d a faut est
%          utilis a e. 
%
%       - v_binf et v_bsup (OPTIONNELS) : 
%          vecteur de type entier et de taille le nombre de param a tres variants, 
%          contenant les bornes inf a rieures et sup a rieures des param a tres.
%          Si ces arguments sont fournis, les limites des axes des abscisses 
%          des diff a rents graphes seront fix a es a ces bornes.  
%          Les bornes peuvent  a tre fix a es a -Inf (borne inf a rieure) ou Inf
%          (borne sup a rieure) si certains param a tres ne sont pas born a s ou
%          si l'utilisateur ne souhaite pas que l'axe des abscisses des graphes de ces
%          param a tres soit redimensionn a .
%
% SORTIE :
%       - v_S : vecteur de taille no de param a tres 
%       contenant les valeurs approch a es des indices de sensibilit a 
%       principaux des diff a rents param a tres pour la variable/date consid a r a e. 
%
%       Figures contenant les diff a rents nuages de points (1 par param a tre)
%       et les regressions associ a es.
%
%
% CONTENU :
%
% AUTEUR : S. BUIS
% DATE : 23-mai-2008
% VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:49:50 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 40 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisations
v_nb_par=length(vc_parname);
v_nb_maxcol=5;
v_nb_maxrow=5;
v_nb_fig_max=v_nb_maxcol*v_nb_maxrow;
v_bandwith=[];
v_bandwith_tmp=zeros(1,v_nb_par);

v_binf=-Inf*ones(size(v_mat_variant,2),1);
v_bsup=Inf*ones(size(v_mat_variant,2),1);
if nargin==5 || nargin==7
    v_bandwith=varargin{1};
    if length(v_bandwith)~=v_nb_par
        v_bandwith=v_bandwith*ones(1,v_nb_par);
    end
end
if nargin==6 || nargin==7
    v_binf=varargin{1+nargin-6};
    v_bsup=varargin{2+nargin-6};
    v_tmp=v_binf<v_bsup;
    if ~all(v_tmp)
        v_param_list=strcat(vc_parname(v_tmp),',');
        error(['Les bornes inferieures des param a tres ',[v_param_list{:}],' sont superieures ou egales a leurs bornes superieure.'])
    end
else
end

figure
j=1;
v_S=zeros(v_nb_par,1);
for i=1:v_nb_par
    if (j>v_nb_fig_max) 
        figure
        j=1;
    end
    subplot(min(ceil(sqrt(v_nb_par)),v_nb_maxrow),min(ceil(v_nb_par/ceil(sqrt(v_nb_par))),v_nb_maxcol),j)
    plot(v_mat_variant(:,i),v_mat_out,'.')
    %scattercloud(v_mat_variant(:,i),v_mat_out)
    hold on;
    try
        if ~isempty(v_bandwith)
            r=ksr(v_mat_variant(:,i),v_mat_out,v_bandwith(i));
            v_bandwith_tmp(i)=v_bandwith(i);
        else
            r=ksr(v_mat_variant(:,i),v_mat_out);
            v_bandwith_tmp(i)=r.h;
        end
        plot(r.x,r.f,'r')
        v_S(i)=var(r.f)/var(v_mat_out);
        title(strcat(v_varname,' vs ',vc_parname{i},' ; S~=',num2str(v_S(i))));
    catch
        disp(['Parametre ' vc_parname{i} ' : pas assez de variation dans les donn a es, la regression ne sera pas trac a e'])
        title(strcat(v_varname,' vs ',vc_parname{i}));
    end
    xlim([v_binf(i) v_bsup(i)]);
    j=j+1;
end
v_bandwith=v_bandwith_tmp;
