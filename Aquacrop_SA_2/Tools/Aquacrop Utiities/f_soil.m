 %%%Soil model Creator for AquaCrop Plugin
  % Paolo C. Silvestro March 2014
  % modif Raffaele May 2014
 
function f_soil(path1,soilname, fileinput)  
 %% header
type = fileinput.soil.type;  %descrizione estesa

 %% Input
 
 var1=3.0;                      %AquaCrop Version (June 2012)
 CN=fileinput.soil.cn;           %CN (Curve Number                 
 rew=fileinput.soil.rew;        %Readily evaporable water from top layer (mm)
 nhor=fileinput.soil.nhor;      %number of soil horizons
 restdp=fileinput.soil.restdp;  %Depth (m) of restrictive soil layer inhibiting root zone expansion
 
  %Table (N.B. a value is needed for each soil layer)
 int1='Thickness';              %Th
 Th=  fileinput.soil.th;  
 int2='Sat';                    %Sat
 Sat= fileinput.soil.sat; 
 int3='FC';                     %FC, Soil Water Content at Field Capacity
 FC=  fileinput.soil.fc;
 int4='WP';                     %WP, Soil Water content at Wilting Point ------> called pwp on E.Vanuytrecht et al. / Environmental Modelling & Software (2014)
 WP=  fileinput.soil.pwp;
 int5='Ksat';                   %Ksat
 Ksat=fileinput.soil.Ksat;
 int6='description';            %description (tessitura)
 des= fileinput.soil.des;
 
 
 %% Text File .SOL Creation

filename=[path1 soilname];
f1 = fopen(filename,'wt');

fprintf(f1,type); 
fprintf(f1,'      %1.1f\n',var1);
fprintf(f1,'     %2.0f \n',CN);
fprintf(f1,'     %2.0f \n',rew);
fprintf(f1,'      %1.0f \n',nhor);
fprintf(f1,'      %1.2f \n',restdp);
fprintf(f1,' %s  %s   %s    %s     %s        %s\n',int1,int2,int3,int4,int5,int6);
fprintf(f1,'  ---(m)-   ----(vol p)-----  (mm/day)  --------------------------------- \n');
for i=1:length(Th)
fprintf(f1,'    %1.2f    %2.1f  %2.1f  %2.1f   %3.1f        %s \n',Th(i),Sat(i),FC(i),WP(i),Ksat(i),des);
end
fclose(f1);
% cd(path0);



 

         
  
  
  
  