function [LAI, Yield]=F_SAFY_original(fileinput)
%% Descrizione
%  Funzione del modello SAFY(CESBIO, UMR CNES-CNRS-IRD-UPS, Duchemin et al.
%  2008), riadattata per essere ripetuta N volte, con input letti da un
%  file .m (fileinput, vedere come riferimento fileinput_ref.m)









%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 0a) INIT PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

InitPar_fileinput  ;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% 0b) READ CLIMATE %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% Descrizione file Clima: 
% Il file Clima deve essere strutturato nelle seguenti colonne
%   1       2       3      4          5                        6                       7                  8          9         10        11        12             13        
% [Anno] [Mese] [Giorno] [JD] [Giorno del Ciclo] [Global Radiation (MJ/m2/day)] [Temp air mean (°C)] [Tmin(°C)] [TMAX(°C)] [Rain(mm)] [ETo(mm)] [URmin(%)] [Wind Speed at 2m (m s-1)] 


load(fileinput.Climatefile.CLIM)          %modificare in fileinput.Climatefile.CLIM con il nome del file CLIM desiderato. (i.e. CLIM_ref)
period=CLIM(:,4);                         % period: Vettore dove ogni elemento è un giorno del ciclo in JD 
Rglb=CLIM(1:length(period),6)	;         % Global Radiation (MJ/m2/day)
Tair=CLIM(1:length(period),7)   ;         % Air Temperature (°C)
                                          % IMPORTANTE: In questo momento di esecuzione dello script fare attenzione che Pgen_StrtSim e Pgen_StopSim corrispondano ai
                                          % giorni iniziali e final dell'intero ciclo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 0c) INIT VARIABLES	%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Init_Var ;



%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEGETATION FUNCTIONING & 
%%%%%%%%%%%%%%%%%%%%%%%%%%
for I=2:Pgen_StopSim-Pgen_StrtSim+1
   %%%%%%%%%%%%%%%%%%%%
   % VEGETATION MODEL %
   %%%%%%%%%%%%%%%%%%%%
   if I == Pfen_MrgD % DAY OF EMERGENCE
         
        % Init Vegetation Model
        SMT(I) = max(Tair(I)-Ptfn_Tmin,0) ; 
        DAM(I) = Pgro_Ms0 ; 
        GLA(I) = InitLAI  ; 
        Day_Of_Emergence = I ;
           
   elseif I>Pfen_MrgD & GLA(I-1)>=InitLAI % VEGETATIVE PERIOD
       
        % Temperature Sum and Stress
        TpS(I) = Temp_Stress(Tair(I),Ptfn_Tmin,Ptfn_Topt,Ptfn_Tmax,Ptfn_TpSn)   ;
        SMT(I) = SMT(I-1)+max(Tair(I)-Ptfn_Tmin,0)                              ; 

        % Daily Total PAR Absorbed by the Canopy, Daily Dry Mass Production 
        PAR(I)= Pgro_R2P * Rglb(I) * ( 1 - exp( -Pgro_Kex*GLA(I-1) ) ) ;   
        ddam=Pgro_Lue*PAR(I)*TpS(I) ; DAM(I)= DAM(I-1) + ddam          ;
 
        % PaRTitioning, Green LAI Increase (DLP) and Leave Senescence Function (DLM), 
        PRT(I) = max(1-Pfen_PrtA*exp(Pfen_PrtB*SMT(I)),0)   ; 
        DLP(I) = ddam*PRT(I)*Pgro_Sla                       ;	
        if SMT(I)>Pfen_SenA
            DLM(I)=GLA(I-1)*(SMT(I)-Pfen_SenA)/Pfen_SenB    ;
        end
        GLA(I)=GLA(I-1)+DLP(I)-DLM(I) ; 

        %Yield (Grain Mass increase after the leaf production period)
        if PRT(I)==0 
            if PRT(I-1)>0  % End of Leaf Growing Period
                SMT_ANT=SMT(I) ; Day_Of_Anthesis=I ;            
            else                              
                DGM(I)=DGM(I-1)+Pgro_P2G*DAM(I) ;    
            end
        end                                                  

       % End of Vegetation Model if LAI < initial value
        if GLA(I)<InitLAI
            Day_Of_Senescence=I ; 
        end
   end
end
LAI=GLA;
Yield=DGM;
