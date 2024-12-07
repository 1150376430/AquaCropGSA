%% SCRIPT utilizzato per trasformare il file clima BEI_08-12.TMP in un 2 vettori (.mat) TMP_sim,TMP_mean 
lclima=length(fileinput.climate);
tempname=['BEI_08-12_noref.txt'];
file_sim=sprintf(tempname);
 TMP_sim=dlmread(file_sim); 
 TMP_mean=zeros(1:length(TMP_sim(:,1)),3);
for i=1:length(TMP_sim(:,1))
 TMP_mean(i,3)=(TMP_sim(i,1)+TMP_sim(i,2))/2;
end

for j=1:366            % creazione del vettore delle temperature medie TMP_mean(:,1)=JD TMP_mean(:,2)=temp media
    TMP_mean(j,2)=j; 
    TMP_mean(j,1)=cell2mat(fileinput.simdate.first(3));
end
for j=367:(367+365)
    TMP_mean(j,2)=j-366;
    TMP_mean(j,1)=cell2mat(fileinput.simdate.first(3))+1;
end
for j=(367+365):(367+365+365)
    TMP_mean(j,2)=j-(366+365);
    TMP_mean(j,1)=cell2mat(fileinput.simdate.first(3))+2;
end
for j=(367+365+365):(367+365+365+365)
    TMP_mean(j,2)=j-(366+365+365);
    TMP_mean(j,1)=cell2mat(fileinput.simdate.first(3))+3;
end
for j=(367+365+365+365):length(TMP_mean(:,1))
    TMP_mean(j,2)=j-(366+365+365+365);
    TMP_mean(j,1)=cell2mat(fileinput.simdate.first(3))+4;
end
   