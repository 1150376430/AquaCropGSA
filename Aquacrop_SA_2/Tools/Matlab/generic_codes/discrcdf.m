function p = discrcdf(X,mod,varargin)
% Fonction de distribution cumulee loi discrete definie par ses
% modalites et les proba associees.
%
%   ENTREES :
%       - x : vecteurs de valeurs pour lesquelles on souhaite calculer les probabilites p.
%       - mod : modalites de la loi discrete
%       - px : vecteur des probabilites associees aux modalites de la loi
%       discrete. S'il n'est pas fourni, alors les probabilites sont considerees comme 
%       etant toutes egales a 1/N, avec N le nombre de modalites.   
%
%   SORTIES :
%       - p : vecteur des probabilites cumulées correspondant aux valeurs
%       de x.
%
%
%   AUTEUR : S. BUIS
%   DATE : 01-aug-2013
%   VERSION : 0
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbmod=length(mod);

pmod=ones(nbmod,1)./nbmod;
if nargin==3
    pmod=varargin{1};
end

if (any(pmod<0) || any(pmod>1))
    error('px must be between 0 and 1')
end

tmp(1:nbmod)=cumsum(pmod);
p=zeros(length(X),1);
for i=2:nbmod
    p(X>=mod(i-1) & X<mod(i))=tmp(i-1);
end
p(X>=mod(nbmod))=1;




