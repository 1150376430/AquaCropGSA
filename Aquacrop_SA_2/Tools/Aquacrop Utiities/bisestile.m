
function ansBis=bisestile(year)
%% Paolo C. Silvestro 28/10/2008
%% funzione che stabilisce se un anno è bisestile o meno 
 % se ansBis=1 : l'anno è bisestile
 % se ansBis=0 : l'anno non è bisestile


if mod(year,400)==0 
    ansBis=1;    
end

if mod(year,4)==0 
     ansBis=1;   
else 
    ansBis=0;
end
