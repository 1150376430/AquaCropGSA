function [LAI_m,Yield_m]=F_SAFY_multipleIn(N,fileinput,Param,Law)

d=fileinput.GenPar.Pgen_StopSim-fileinput.GenPar.Pgen_StrtSim+1; %giorni della simulazione (impostato in fileinput con Strt-End Sim)

LAI_m=zeros(N,d);
Yield_m=zeros(N,d);

for e=1:N;                                                                                 
fileinput= f_fileinputvar(Param,fileinput,e,Law);                  % modifica il fileinput (f_fileinputvar.m)

fileinput.PhenParam.Pfen_MrgD=fix(fileinput.PhenParam.Pfen_MrgD);  % La discretizzazione pu� restituire valori decimali di alcuni parametri che il programma riconosce solo come interi (come i giorni all'emergenza, Pfen_MrgD). In questo passsaggio eliminiamo la parte decimale dal valore dei parametri che devono essere numeri interi. 
fileinput.PhenParam.Pfen_SenA=fix(fileinput.PhenParam.Pfen_SenA);
fileinput.PhenParam.Pfen_SenB=fix(fileinput.PhenParam.Pfen_SenB);

% %% 1) Safy Original
% [LAI, Yield]=F_SAFY_original(fileinput);                           % SAFY, calcola il LAI (GLA) e la Z  
%% 2) AzoSAFY
 V_output=F_AzoSAFYE(fileinput);
 Yield=V_output.Crop.data(:,4)'; 
 LAI=V_output.Crop.data(:,1)';
%% 
LAI_m(e,:)=LAI;                                                    % LAI: su ogni riga c'� un intero ciclo di LAI (dal giorno della semina alla raccolta) per ogni e-simo "punto dell'iperspazio" (vedi Campolongo et al. 2007) 
Yield_m(e,:)=Yield ;                                    
end
