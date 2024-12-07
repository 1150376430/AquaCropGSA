function p = triangcdf(X,a,c,b)
% Fonction de distribution cumulee loi triangulaire (F(P(X<x))
%
%   ENTREES :
%       - X : vecteur des valeurs pour lesquelles on veut calculer les probabilites cumulées 
%       - a : parametre a de la loi triangulaire (borne inferieure)
%       - c : parametre c de la loi triangulaire (abscisse du pic)
%       - b : parametre b de la loi triangulaire (borne superieure)
%
%     avec a<=c<=b.
%
%   SORTIES :
%       - p : vecteur des valeurs des probabilités cumulées correspondant aux valeurs
%       de X.
%
%   AUTEUR : S. BUIS
%   DATE : 01-aug-2013
%   VERSION : 0
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (any(X<a) || any(X>b))
    error(['X must be between a (' num2str(a) ') and b (' num2str(b) ')'])
end
if (a>c || b<c)
    error(['a (' num2str(a) '), b (' num2str(b) ') and c (' num2str(c) ') must follow a<=c<=b'])
end

p=zeros(size(X));
for i=1:length(X)
   if X(i)<=c
       p(i)=(X(i)-a)^2/((b-a)*(c-a));     
   else      
       p(i)=1-(b-X(i))^2/((b-a)*(b-c));     
   end
end

