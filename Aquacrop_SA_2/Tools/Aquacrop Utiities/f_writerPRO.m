function f_writerPRO(Paths,Dates,Names,fileinput,cli)                 
%Script richiamato dallo script principale MAIN, contiene i codici di
%scrittura del file di testo .PRO formattato come richiesto dal plug-in di
%AquaCrop
%
%  INPUT
%   Paths       cell array containg full path to subfolder \DATA, \SIMUL and \LIST              
%   Dates       vector with 4 dates: First day of simulation,   last day
%               of simulation, first day of crop growth, last day of crop growth (in
%               Aquacrop format)
%   Names       cell array containing: soilname, cropname, inconname, namepro
%   fileinput   strucure containing all the parameters and input info
% 
% Paolo C. Silvestro March 2014
% modif Raffaele May 2014
%% get input variables

var6= fileinput.soil.fk;                    %Evaporation decline factor for stage II           
var7= fileinput.soil.Kex;                   %Ke(x) Soil evaporation coefficient for fully wet and non-shaded soil surface
var8= fileinput.crop.canopy.tCC;            %Threshold for green CC below which HI can no longer increase (% cover)
var9= fileinput.crop.root.zexR;              %Starting depth of root zone expansion curve (% of Zmin)
var10= fileinput.crop.root.zrate;            %Maximum allowable root zone expansion (fixed at 5 cm/day)
var11= fileinput.crop.root.wsrtshp;          %Shape factor for effect water stress on root zone expansion
var12= fileinput.crop.other.wgerm;         %Required soil water content in top soil for germination (% TAW)
var13= 1.0;        %Adjustment factor for FAO-adjustment soil water depletion (p) by ETo
var14= 3;          %Number of days after which deficient aeration is fully effective
var15= 1.00;       %Exponent of senescence factor adjusting drop in photosynthetic activity of dying crop
var16= 12;         %Decrease of p(sen) once early canopy senescence is triggered (% of p(sen))
var17= 1;          %Thresholds for water stress for stomatal closure are affected by soil salinity stress
var18= 30;         %Depth [cm] of soil profile affected by water extraction by soil evaporation
var19= 0.30;       %Considered depth (m) of soil profile for calculation of mean soil water content for CN adjustment
var20= 1;          %CN is adjusted to Antecedent Moisture Class
var21= 20;         %salt diffusion factor (capacity for salt diffusion in micro pores) [%]
var22= 100;        %salt solubility [g/liter]
var23= 16;         %shape factor for effect of soil water content gradient on capillary rise
var24= 12.0;       %Default minimum temperature (°C) if no temperature file is specified
var25= 28.0;       %Default maximum temperature (°C) if no temperature file is specified
var26= 3;          %Default method for the calculation of growing degree days
 
 %% Print file .PRO
filename=[cell2mat(Paths(3)) cell2mat(Names(4))];
f1 = fopen(filename,'wt');

fprintf(f1,'prova n %1.0f %s\n',1,date);
fprintf(f1,'      %1.1f\n',4);
fprintf(f1,'  %5.0f \n',Dates(1));
fprintf(f1,'  %5.0f \n',Dates(2));
fprintf(f1,'  %5.0f \n',Dates(3));
fprintf(f1,'  %5.0f \n',Dates(4));
fprintf(f1,'      %1.0f\n',var6);
fprintf(f1,'      %1.2f\n',var7);
fprintf(f1,'      %1.0f\n',var8);
fprintf(f1,'     %2.f\n',var9);
fprintf(f1,'      %1.2f\n',var10);
fprintf(f1,'     %1.0f\n',var11);
fprintf(f1,'     %2.0f\n',var12);
fprintf(f1,'      %1.1f\n',var13);
fprintf(f1,'      %1.0f\n',var14);
fprintf(f1,'      %1.2f\n',var15);
fprintf(f1,'     %2.0f\n',var16);
fprintf(f1,'      %1.0f\n',var17);
fprintf(f1,'     %2.0f\n',var18);
fprintf(f1,'      %1.2f\n',var19);
fprintf(f1,'      %1.0f\n',var20);
fprintf(f1,'     %2.0f\n',var21);
fprintf(f1,'    %3.0f\n',var22);
fprintf(f1,'     %2.0f\n',var23);
fprintf(f1,'     %2.1f\n',var24);
fprintf(f1,'     %2.1f\n',var25);
fprintf(f1,'      %1.0f\n',var26);
                      %Climate File
fprintf(f1,'-- 1. Climate (CLI) file\n');
fprintf(f1,'   %s\n',cell2mat(cli(1)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
fprintf(f1,'   1.1 Temperature (TMP) file\n');
fprintf(f1,'   %s\n',cell2mat(cli(2)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
fprintf(f1,'   1.2 Reference ET (ETo) file\n');
fprintf(f1,'   %s\n',cell2mat(cli(3)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
fprintf(f1,'   1.3 Rain (PLU) file\n');
fprintf(f1,'   %s\n',cell2mat(cli(4)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
fprintf(f1,'   1.4 Atmospheric CO2 (CO2) file\n');
fprintf(f1,'   %s\n',cell2mat(cli(5)));
fprintf(f1,'   %s\n',cell2mat(Paths(2)));
                     %Crop File
fprintf(f1,'-- 2. Crop (CRO) file\n');
fprintf(f1,'   %s\n',cell2mat(Names(2)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
                     %Irrigation File
fprintf(f1,'-- 3. Irrigation (IRR) file\n');
fprintf(f1,'   %s\n',cell2mat(Names(5)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
                     %Management File
fprintf(f1,'-- 4. Management (MAN) file\n');
fprintf(f1,'   %s\n',cell2mat(Names(6)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
                     %Soil Profile File
fprintf(f1,'-- 5. Soil profile (SOL) file\n');
fprintf(f1,'   %s \n',cell2mat(Names(1)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
                     %Groundwater File                     
fprintf(f1,'-- 6. Groundwater (GWT) file\n');
fprintf(f1,'   (None)\n');
fprintf(f1,'   (None)\n');
                     %Initial Condition File
fprintf(f1,'-- 7. Initial conditions (SW0) file\n');
fprintf(f1,'   %s \n',cell2mat(Names(3)));
fprintf(f1,'   %s\n',cell2mat(Paths(1)));
                     % Off-season Conditions File
fprintf(f1,'-- 8. Off-season conditions (OFF) file\n');
fprintf(f1,'   (None)\n');
fprintf(f1,'   (None)\n');


fclose(f1);