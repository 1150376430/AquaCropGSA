function v_in_mat_real=F_conv_int01_to_real(Param,v_in_mat,k,p)
%% Trasformazione dell'ipercubo unitario nei valori reali 
%  ref: Campolongo et al. 2007, pg 1510, 2.The elementary effects
%  Il Metodo di Morris impiega un campionamento cosiddetto OAT
%  (One-at-Time), per applicarlo è necessario che gli intervalli discreti
%  in cui è "pescato" il vaolre del parametro sia [0 1]. Questa funzione
%  riconverte l'intervallo discreto tra [0 1] (qui indicato con
%  int_disc(1,:) ) nell'intervallo reale, indicato in Param.num (1 e 2
%  colonna). Questa funzione esprime l'intervallo reale in int.disc(2,:). 
%
%  INPUT
%        
%       Param             : file . mat contenente il valore nominale dei parametri del
%                           modello. I parametri qui scelti saranno quelli 
%                           che Campolongo et al. 2007 definiscono: imput factors. 
%                           Vedere struttura di riferimento Param_ref.
%       v_in_mat          : gruppo di r triettorie di distanza interna massimale
%                           Tipo: matrice di dimensioni (r*(Nb+1),Nb). Creato tramite
%                           F_gen_variant_Morris(vs_factors_def,vs_method_options),
%                           vs_factors_def e vs_method_options sono definiti in fileinput.
%                           Seguono le caratteristiche descritte nello script
%                           F_gen_variant_Morris, (INPUT). 
%       k                 : numero di parametri. rappresenta pertanto il
%                           numero di colonne di v_in_mat e v_in_mat_real
%       p                 : numero di livelli. p-1 è il numero di segmenti in cui viene diviso 
%                           l'intervallo di appartenenza del valore del parametro. 
%                           E' definito in fileinput.vs_methods_options.
%
%  OUTPUT  
%      v_in_mat_real     : Matrice delle traiettorie in valori reali e non unitari come v_in_mat 
%                          (ogni traiettoria sono (k+1) punti dell'iperspazio, ogni linea della
%                          matrice è un punto). 

v_in_mat=chop(v_in_mat,3);         % approssimazione alla terza cifra decimale, necessario al corretto funzionamento di find()
v_in_mat_real=v_in_mat;            % definizione della matrice v_in_mat_real

num=Param.num;

% int_disc : è l'intervallo discreto in cui viene pescata la variabile.
%            Tipo: Matrice, la prima riga è l'intervallo unitario (ovvero
%            [0 1]), la seconda riga è l'intervallo reale (ovvero
%            [Param_min Param_MAX]).

int_disc=zeros(2,p);                      
%            Creazione intervallo discreto unitario        
for i=1:(p-1)
int_disc(1,p-i)=1-i/(p-1);
end
int_disc(1,p)=1 ;
%            Creazione intervallo discreto reale 
 for par=1:k;
range=num(par,2)-num(par,1);              
for i=1:(p-1)
int_disc(2,p-i)=num(par,2)-((i*(range))/(p-1));
end
int_disc(2,p)=num(par,2) ;
int_disc=chop(int_disc,3);       % approssimazione alla terza cifra decimale, necessario al corretto funzionamento di find()
%            Modifica della matrice v_in_mat in v_in_mat_real 
for i=1:length(v_in_mat(:,par))
ind=find(int_disc(1,:)==v_in_mat(i,par));
v_in_mat_real(i,par)=int_disc(2,ind);
end
 end
