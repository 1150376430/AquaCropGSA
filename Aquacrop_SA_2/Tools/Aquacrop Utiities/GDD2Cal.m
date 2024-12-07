function  [eme_cd,root_cd,sen_cd,mat_cd,flo_cd,flolen_cd]=GDD2Cal(fileinput,TMP_mean,dos,dof)
% Funzione che trasforma le variabili assegnate in INPUT da GDD a giorni 
%% INPUT descrizione  
% fileinput: struttura contenente tutti i parametri di Aquacrop, fare 
%            riferimento a AC_fileinput_ref.mat
% TMP_mean : Matrice delle temperature medie. Ogni riga � un giorno. 
%            Le colonne sono:  [year][JD][Temp.�C]. Prendere come riferimento              
%            BEI_08-12_TMP.mat
% dos      : day of sowing, Giorno della semina.
% dof      : giorno di fine ciclo (pu� essere arbitrario, non crea problemi)
%% OUTPUT descrizione
% eme_cd:    giorni dalla semina all'emergenza in "calendar days"
% root_cd:   giorni dalla semina al raggiungimento dell'estensione massima delle radici in "calendar days"
% sen_cd:    giorni dalla semina alla senescenza in "calendar days"
% mat_cd:    giorni dalla semina alla maturit� in "calendar days"
% flo_cd:    giorni dalla semina alla fioritura "calendar days"
% flolen_cd: durata fioritura in "calendar days"

%% INPUT elaborazione

% Date della Simulazione
% Temperature limite
To=fileinput.crop.other.To_crop;
Tmax=fileinput.crop.other.Tmax_crop;

% Variabili AC
eme=fileinput.crop.canopy.eme;
root=fileinput.crop.root.root;
sen=fileinput.crop.canopy.sen;
flo=fileinput.crop.canopy.flo;
flolen=fileinput.crop.canopy.flolen;
mat=fileinput.crop.canopy.mat;

% Clima 
in_1=find(TMP_mean(:,1)==cell2mat(fileinput.simdate.first(3)));
TMP_1=TMP_mean(in_1(1):in_1(end),:);
in_2=find(TMP_mean(:,1)==cell2mat(fileinput.simdate.first(3))+1);
TMP_2=TMP_mean(in_2(1):in_2(end),:);
start=find(TMP_1(:,2)==dos);
stop=find(TMP_2(:,2)==dof);

TMP=[TMP_1(start:end,:); TMP_2(1:stop,:)]; % File finale delle Temperature medie dal giorno della semina alla fien del ciclo colturale
dd=length(TMP(:,1));                       % Lunghezza del ciclo colturale 
%% OUTPUT
% Trasformazioni delle variabili di input in giorni del calendario
 
% eme_cd
somma=0;
 for i=1:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=eme))
   somma=somma+TMP(i,3);
   eme_cd=i;
    end
 end
% root_cd
 somma=0;
 for i=1:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=root))
   somma=somma+TMP(i,3);
   root_cd=i;
    end
 end
 % sen_cd
 somma=0;
 for i=1:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=sen))
   somma=somma+TMP(i,3);
   sen_cd=i;
    end
 end
 % flo_cd
 somma=0;
 for i=1:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=flo))
   somma=somma+TMP(i,3);
   flo_cd=i;
    end
 end
 % flolen_cd
somma=0;
 for i=flo_cd:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=flolen))
   somma=somma+TMP(i,3);
   flolen_cd=i-flo_cd;
    end
 end
 % mat_cd  
somma=0;
 for i=1:dd
    if (TMP(i,3)>=To) && (TMP(i,3)<=Tmax && (somma<=mat))
   somma=somma+TMP(i,3);
   mat_cd=i;
    end
 end





