%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAFY (CESBIO-IRD, Duchemin 2008) : variable file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DAY OF SIMULATION
I=1 ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUM of TEMPERATURE for DEGREE-DAY APPROACH (°C)
SMT(1:Pgen_StopSim-Pgen_StrtSim+1)=0;
% TEMPERATURE STRESS INDEX ([0-1],unitless)
TpS(1:Pgen_StopSim-Pgen_StrtSim+1)=0;
% ABSORBED PHOTOSYNTHETIC ACTIVE RADIATION (MJ/m2/day)
PAR(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
% DRY AERIAL & GRAIN MASS (g/m2=100 x t/ha)
DAM(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
DGM(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
% PARTITION-TO-LEAF INDEX ([0-1],unitless)
PRT(1:Pgen_StopSim-Pgen_StrtSim+1)=0;
% GREEN LEAF AREA INDEX (LAI, m2/m2) 
GLA(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
% DELTA of GREEN LAI from DAY D to D+1 
% (P=plus;M=minus;m2/m2)
DLP(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
DLM(1:Pgen_StopSim-Pgen_StrtSim+1)= 0;
% Day of Total Senescence
Day_Of_Anthesis=0;
Day_Of_Senescence=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THREESHOLD ON LAI TO DECLARE TOTAL YELLOWING (m2/m2)
InitLAI=Pgro_Ms0*Pgro_Sla ; % = Initial Value of LAI  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
