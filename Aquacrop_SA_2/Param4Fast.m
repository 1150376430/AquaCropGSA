%% Param for FAST

%% Input
% Param.mat
% vm_mu_star (da prendere nei risultati di Morris: vs_indices.vm_mu_star,
%            oppure creare il vettore vm_mu_star con all'interno il valore di mu star
%            medio per gli scenari analizzati
% Eseguire Preventivamente Grafici_Paper
j=1;
k=length(Param.num(:,1));
[vm_mu_star_decroissant, vv_index_mu_star_decroissant] = sort(vm_mu_star(:,j), 'descend');
 Param_Efast=Param;


for nn=1:k
        neg_rank_Param(nn,1) ={Param.text(vv_index_mu_star_decroissant(nn)+1)};
        neg_rank_Param(nn,2) ={vm_mu_star_decroissant(nn)};
        for kk=1:4
        Param_Enk.num(nn,kk)=Param.num(vv_index_mu_star_decroissant(nn),kk);
        end
        end       
  Param_Enk.text=neg_rank_Param(:,1); 
  Param_Enk.rank=neg_rank_Param;
  
 for h=1:k
     Param_Efast.num(h,:)=Param.num(vv_index_mu_star_decroissant(h),:);
 end
 
 
 for h=2:k
     
    Param_Efast.text(h,:)=Param.text(vv_index_mu_star_decroissant(h-1)+1,:);
    
 end
 
 Param_Efast.rank(:,2:3)=neg_rank_Param;
 for hh=1:k;
 Param_Efast.rank(hh,1)={vv_index_mu_star_decroissant(hh)}; % indice del parametro in Param.num 
 end
 
 Param_Efast.rank(:,4)=rank_mu_uncert_Param;
 Param_Efast.rank(:,5)=rank_sigma_Param;
 Param_Efast.rank(:,6)=rank_sigma_uncert_Param;
 Param_Efast.rank_name={'index in Param','Param name','mu_star','mu_uncert_Param','sigma_Param','sigma_uncert_Param'};
 
 save([namess(6:(end-4)) 'Param_EFAST'],'Param_Efast')
 
 
 
 