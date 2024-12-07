function fileinput= f_fileinputvar(Param,fileinput,e,Law)
%% Descrizione:
% Funzione che sostituisce i parametri in fileinput.mat con  i Parametri 
% fondamentali (definiti in Param.mat e calcolati in Law.mat) 
% fileinput: Array di valori in cui sono definiti tutti i parametri di SAFY 
%            E' fondamentale che venga rispettata la struttura del file 
%            d'esempio fileinput_ref.mat
% Param : Array di valori in cui sono definiti i parametri fondamentali di 
%         SAFY. E' fondamentale che venga rispettata la struttura del file 
%         d'esempio Param_ref.mat
% Law : Ogni colonna di questo Array è un set di parametri definito in
%       Param.mat (ensemble). Il numero di colonne è N, numero degli 
%       ensemble scelto. 
% e : indice che può andare da un minimo di 1 a un massimo di N
%     (numero di ensemble e numero di colonne di LAW), rappresenta l'enseble
%     che si sta sostituendo in fileinput  

for p=1:size(Param.num,1)                       %each variable parameter
        par_name=cell2mat(Param.text(p+1,1));
        val=Law(p,e);                           % parameter value random realisation
        loc=cell2mat(Param.text(p+1,2));        % its location (field) in the fileinput structure
        loc=[loc '.' par_name];                 % full path in structure fileinput
        
        stringa=sprintf('%s=%f',loc, val); 
        eval(stringa)                           % writes the value form Law into the fileinput structure 
      

end
 
