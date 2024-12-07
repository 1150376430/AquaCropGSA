function x = trianginv(p,a,c,b)
% Inverse fonction de distribution cumulee loi triangulaire (F^(-1)(P(X<x))
%
%   ENTREES :
%       - p : vecteur des probabilites (chaque valeur comprise entre 0 et
%       1).
%       - a : parametre a de la loi triangulaire (borne inferieure)
%       - c : parametre c de la loi triangulaire (abscisse du pic)
%       - b : parametre b de la loi triangulaire (borne superieure)
%
%     avec a<=c<=b.
%
%   SORTIES :
%       - x : valeurs de X correspondant aux probabilites p.
%
%   AUTEUR : S. BUIS
%   DATE : 06-mai-2010
%   VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:28:06 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 940 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (any(p<0) || any(p>1))
    error('p must be between 0 and 1')
end
if (a>c || b<c)
    error('a, b and c must follow a<=c<=b')
end

x=zeros(size(p));
for i=1:length(p)
   if p(i)==0
       x(i)=a;
   elseif p(i)==1
       x(i)=b;
   elseif p(i)<=(c-a)/(b-a)
       r=roots([1,-2*a,a^2-p(i)*(b-a)*(c-a)]);
       x(i)=r(isreal(r) & r<=c & r>=a);       
   elseif p(i)>=(c-a)/(b-a)
       r=roots([1,-2*b,b^2+(b-a)*(b-c)*(p(i)-1)]);
       x(i)=r(isreal(r) & r>=c & r<=b);       
   end
end

