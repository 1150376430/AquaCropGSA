function x = discrinv(p,mod,varargin)
% Inverse fonction de distribution cumulee loi discrete definie par ses
% modalites et les proba associees.
%
%   ENTREES :
%       - p : vecteur des probabilites a inverser (chaque valeur comprise entre 0 et
%       1).
%       - x : modalites de la loi discrete
%       - px : vecteur des probabilites associees aux modalites de la loi
%       discrete. S'il n'est pas fourni, alors les probabilites sont considerees comme 
%       etant toutes egales a 1/N, avec N le nombre de modalites.   
%
%   SORTIES :
%       - x : valeurs de X correspondant aux probabilites p.
%
%
%   AUTEUR : S. BUIS
%   DATE : 07-mai-2010
%   VERSION : 0
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-06-19 14:05:22 +0200 (mer., 19 juin 2013) $
%    $Author: plecharpent $
%    $Revision: 938 $
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbmod=length(mod);

pmod=ones(nbmod,1)./nbmod;
if nargin==3
    pmod=varargin{1};
end

if (any(p<0) || any(p>1))
    error('p must be between 0 and 1')
end
if (any(pmod<0) || any(pmod>1))
    error('px must be between 0 and 1')
end
if (any(p<0) || any(p>1))
    error('p must be between 0 and 1')
end

tmp(1)=0;
tmp(2:nbmod+1)=cumsum(pmod);
x=zeros(length(p),1);
for i=2:length(tmp+1)
    x(p>tmp(i-1) & p<=tmp(i))=mod(i-1);
end




