%% InitPar_fileinput
% Modified by Paolo C.Silvestro 29 10 2014
%% Descrizione: 
% Legge dal file fileinput.m i valori da assegnare ai parametri 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAFY (CESBIO-IRD, Duchemin 2008) : parameter file 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excepting Day of Emergence & Effective Light-Use-Efficiency, the
% values of the parameters correspond to [ Duchemin et al.(2008),
% Environmental Modelling and Software 23:876-892 ] 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General Parameter                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pgen_StrtSim = fileinput.GenPar.Pgen_StrtSim     ; % Day to Start the Simulation %Da modificare in fileinput, deve coincidere con il primo giorno del clima
Pgen_StopSim = fileinput.GenPar.Pgen_StopSim     ; % Day to Stop the Simulation  % Da modificare in fileinput, deve coincidere con l'ultimo giorno del clima  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crop growth Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pgro_R2P = fileinput.CropGrowParam.Pgro_R2P    ; % Global to PAR incident radiation ratio
Pgro_Kex = fileinput.CropGrowParam.Pgro_Kex    ; % Extinction of Radiation in Canopy (0.3-1)
Pgro_Lue = fileinput.CropGrowParam.Pgro_Lue    ; % Effective ligh-use efficiency (g.MJ-1)
Pgro_Ms0 = fileinput.CropGrowParam.Pgro_Ms0    ; % Emergence Dry Mass Value (g/m2=100 x t/ha)
Pgro_Sla = fileinput.CropGrowParam.Pgro_Sla    ; % Specific Leaf-Area 0.024 (m2 g-1)  
Pgro_P2G = fileinput.CropGrowParam.Pgro_P2G    ; % Partition coefficient To Grain 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phenological parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Day of Plant Emergence
Pfen_MrgD = fileinput.PhenParam.Pfen_MrgD     ; 
% Partitioning to Leaves (after Maas, 1993)
Pfen_PrtA = fileinput.PhenParam.Pfen_PrtA  ; % Make vary the origin slope of partition fn 
Pfen_PrtB = fileinput.PhenParam.Pfen_PrtB ; % Make vary the day of max LAI (partition=0)
% Senescence function
Pfen_SenA = fileinput.PhenParam.Pfen_SenA    ; % Temp. Threshold to Start Senescence (°C)
Pfen_SenB = fileinput.PhenParam.Pfen_SenB    ; % Make vary the rate of Senescence (°C)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature Effect On Development - result in TpS=TempStress[0-1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ptfn_Tmin = fileinput.TempEffParameter.Ptfn_Tmin ; % Minimum Temperature for Plant Development (°C)
Ptfn_Topt = fileinput.TempEffParameter.Ptfn_Topt ; % Optimum Temperature for Plant Development (°C)
Ptfn_Tmax = fileinput.TempEffParameter.Ptfn_Tmax ; % Maximum Temperature for Plant Development (°C)
Ptfn_TpSn = fileinput.TempEffParameter.Ptfn_TpSn  ; % Make vary the length of plateau around optimum T°    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    