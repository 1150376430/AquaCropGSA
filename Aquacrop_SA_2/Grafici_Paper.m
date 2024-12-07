%% Grafici_Paper
% Script che disegnai grafici degli indici di Morris usati nel Paper Sen.An.
% 
%
j=1; 
k=length(Param.num(:,1));
vm_mu_star=vs_indices.vm_mu_star;
m=fileinput.vs_method_options.r;
vm_sigma=vs_indices.vm_sigma;
vm_sigma_uncert=vs_indices.vm_sigma_uncert;
vm_mu_uncert=vs_indices.vm_mu_uncert;
% namess='Xiaotangshan_2008_2009_Morris';
vm_sigma=vs_indices.vm_sigma;
vm_mu_uncert=vs_indices.vm_mu_uncert;
vm_sigma_uncert=vs_indices.vm_sigma_uncert;
[vm_mu_star_decroissant, vv_index_mu_star_decroissant] = sort(vm_mu_star(:,j), 'descend');
        
        for nn=1:k
        neg_rank_Param(nn,1) ={Param.text(vv_index_mu_star_decroissant(nn)+1)};
        neg_rank_Param(nn,2) ={vm_mu_star_decroissant(nn)};
        rank_sigma_Param(nn,1)={vm_sigma(vv_index_mu_star_decroissant(nn))};
        rank_sigma_uncert_Param(nn,1)={vm_sigma_uncert(vv_index_mu_star_decroissant(nn))};
        rank_mu_uncert_Param(nn,1)={vm_mu_uncert(vv_index_mu_star_decroissant(nn))};
        
        for kk=1:4
        Param_Enk.num(nn,kk)=Param.num(vv_index_mu_star_decroissant(nn),kk);
        end
        end       
  Param_Enk.text=neg_rank_Param(:,1); 
  Param_Enk.rank=neg_rank_Param;
  Param_Enk.prov(:,1)=rank_mu_uncert_Param;
  Param_Enk.prov(:,2)=rank_sigma_Param;
  Param_Enk.prov(:,3)=rank_sigma_uncert_Param;
  Param_Enk.name_Prov={'rank_mu_uncert_Param','rank_sigma_Param','rank_sigma_uncert_Param'};
  
  Param4Fast;
  

        
        
        vv_chaineDeCaracteresSortie1 = '  ';
        vv_chaineDeCaracteresSortie2 = 'µ* : ';
        disp('valore di µ* per i differenti parametri ');
        for i = 1:size(vm_mu_star)
            vv_chaineDeCaracteresSortie1 = [vv_chaineDeCaracteresSortie1, '   X', num2str(vv_index_mu_star_decroissant(i)),'      '];
            vv_chaineDeCaracteresSortie2 = [vv_chaineDeCaracteresSortie2, num2str(vm_mu_star_decroissant(i), '%3.2e'),' ; ' ];
        end
        disp(vv_chaineDeCaracteresSortie1);
        %disp(['µ* : ', num2str(vm_mu_star_decroissant', '%3.2e')]);
        disp(vv_chaineDeCaracteresSortie2);

        figure
        hold on
        if m>1
          errorbar(vm_mu_star(:,j), vm_sigma(:,j), vm_sigma_uncert(:,j), '.') % on pourrait tracer des boxplot fin (est-ce que ça existe en horizontal ?) ...
          herrorbar(vm_mu_star(:,j), vm_sigma(:,j), vm_mu_uncert(:,j), '.') % ... ou le min et max (mais retourner en sortie les ect)
        end
        xlim([min(0*max(abs(vm_mu_star(:,j))+vm_mu_uncert(:,j)),-0.1) max(1.1*max(abs(vm_mu_star(:,j))+vm_mu_uncert(:,j)),0.1)])
        ylim([min(min(abs(vm_sigma(:,j))-vm_sigma_uncert(:,j))-0.1*abs(min(abs(vm_sigma(:,j))-vm_sigma_uncert(:,j))),0) max(1.1*max(abs(vm_sigma(:,j))+vm_sigma_uncert(:,j)),0.1)])
        xminmax=xlim;
        yminmax=ylim;
        xoffset=diff(xlim)/100;
        yoffset=diff(ylim)/50;
        for i=1:k 
         text(vm_mu_star(i,j)+xoffset, vm_sigma(i,j)+yoffset,Param.text(i+1))
        end
        plot([max(xminmax(1),-yminmax(2)) 0],[abs(max(xminmax(1),-yminmax(2))) 0],'r--')
        plot([0 min(xminmax(2),yminmax(2))],[0 min(xminmax(2),yminmax(2))],'r--')
        hold off
        xlabel('µ*');
        ylabel('sigma');
        title(['Morris indexes for each parameter ' num2str(j)])
    
        figure
        hold on
        x=1:1:k;
        bar(x,vm_mu_star(:,j));  
        
%         for i=1:k 
%          text( x(i)+xoffset, 100+yoffset,Param.text(i+1))
%         end
        
        title(['Histogram mu*  '  num2str(i) ' parameters'])
        
        

