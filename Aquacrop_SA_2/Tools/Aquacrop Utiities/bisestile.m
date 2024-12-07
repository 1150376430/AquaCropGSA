
function ansBis=bisestile(year)
%% Paolo C. Silvestro 28/10/2008
%% funzione che stabilisce se un anno � bisestile o meno 
 % se ansBis=1 : l'anno � bisestile
 % se ansBis=0 : l'anno non � bisestile


if mod(year,400)==0 
    ansBis=1;    
end

if mod(year,4)==0 
     ansBis=1;   
else 
    ansBis=0;
end
