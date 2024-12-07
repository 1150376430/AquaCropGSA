%% Grafici Paper 2.0
% INPUT
% Param_Efast
j=1;
vm_mu_star=cell2mat(Param_Efast.rank(:,3));
vm_mu_uncert=cell2mat(Param_Efast.rank(:,4));
vm_sigma=cell2mat(Param_Efast.rank(:,5));
vm_sigma_uncert=cell2mat(Param_Efast.rank(:,6));
k=length(vm_mu_star);
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
        
        
