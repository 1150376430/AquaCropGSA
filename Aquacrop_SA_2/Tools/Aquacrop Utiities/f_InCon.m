function f_InCon(path1,inconname,fileinput)
%% Initial Condition text Creator for AquaCrop Plugin
 % Paolo C. Silvestro March 2014
 
 
 %% Header
 type = 'Wet top soil (30 vol) and dry sub soil (15 vol) \n';
 
 
 %% Input
  var1=3.0;                                    %AquaCrop Version (June 2012)
  var2=fileinput.InCon.WSbSB;                  %water stored between soil bunds (if present)
  var3=fileinput.InCon.SWC;                    %soil water content specified at particular depths
  var4=fileinput.InCon.SND;                    %number of soil depths considered

  sd=fileinput.InCon.SD;          %soil depth in meters
  wc=fileinput.InCon.WC;          %soil water content (vol%)
  


 %% Initial Condition Text File .SW0 Creation
 filename=[path1 inconname];
 f1 = fopen(filename,'wt');

 fprintf(f1,type);
 fprintf(f1,'    %1.1f\n',var1);
 fprintf(f1,'    %1.1f \n',var2);
 fprintf(f1,'    %1.0f \n',var3);
 fprintf(f1,'    %1.0f \n',var4);
 fprintf(f1,'                 \n');
 fprintf(f1,'  Soil depth (m)         Soil water content (vol)\n');
 fprintf(f1,'==================================================\n');
 
 for i=1:length(sd)
 
 fprintf(f1,'      %1.2f                         %2.2f \n',sd(i),wc(i));    


 end
 fclose(f1);
