function nnconv = dataconv(dd,mm,yy)
%Funzione che converte la data in un formato compatibile con il file
%Progetto (PRO, PRM) di AquaCrop 
%Paolo C. Silvestro, March 2014
 %Literature
 % Dirk, R., Pasquale, S., Theodore C., H., & Elias, F. (2013). Plug-in
 %program Reference Manual.

%%Descrizione Input:
 % dd: giorno del mese (valore numerico)
 % mm: mese (jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)
 % yy: anno (per esteso)

%Costanti
C2=365.25;

% Costanti in accordo con il mese
 if mm=='jan'
     mn=0;
 elseif mm=='feb'
     mn=31;
 elseif mm=='mar'
     mn=59.25;
 elseif mm=='apr'
     mn=90.25;
 elseif mm=='may'
     mn=120.25;
 elseif mm=='jun'
     mn=151.25;
 elseif mm=='jul'
     mn=181.25;    
 elseif mm=='aug'
     mn=212.25;        
 elseif mm=='sep'
     mn=243.25;
 elseif mm=='oct'
     mn=273.25;        
 elseif mm=='nov'
     mn=304.25;        
 else mm=='dec'
     mn=334.25;  
 end
 
 %1. Subtract 1901 from the year
P1=yy-1901;
 %2. Multiply by 365.25
P2=P1*C2;
 %3. Add costant according to the month
P3=P2+mn;
 %4.Add the number of the day
P4=P3+dd;
 %5. Take the integer
P5=fix(P4); 

%output: data codificata
nnconv=P5;



