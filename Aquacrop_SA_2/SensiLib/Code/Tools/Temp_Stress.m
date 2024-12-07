%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAFY (CESBIO-IRD) : temperature stress function (after Brisson 1998)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  TpS = Temp_Stress(T,Tmin,Topt,Tmax,TpSn) ;

if T < Tmin | T > Tmax   % T outside the functioning range 
   TpS=0 ; 
else if T <= Topt         % T lower than the optimal value
   TpS = 1-power((T-Topt)/(Tmin-Topt),TpSn);
     else                % T higher than the optimal value
        TpS = 1-power((T-Topt)/(Tmax-Topt),TpSn);
     end
end
