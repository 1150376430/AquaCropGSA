n = 1; 
m=5;
vm_mu_star=vs_indices.vm_mu_star;
vm_mu_star_uncert=vs_indices.vm_mu_star_uncert;
vm_sigma_uncert=vs_indices.vm_sigma_uncert;
vm_sigma=vs_indices.vm_sigma;
figure(1)
 for j=1:n      
 hold on
        if m>1
          errorbar(vm_mu_star(:,j), vm_sigma(:,j), vm_sigma_uncert(:,j), '.') % on pourrait tracer des boxplot fin (est-ce que ça existe en horizontal ?) ...
          herrorbar(vm_mu_star(:,j), vm_sigma(:,j), vm_mu_star_uncert(:,j), '.') % ... ou le min et max (mais retourner en sortie les ect)
        end
        k=size(Param.num,1);
        text(vm_mu_star(:,j), vm_sigma(:,j),num2str([1 : k]'))
        hold off
        
        
        axis([0 25 0 25 ])
        xlabel('µ*');
        ylabel('sigma');
        title('2009-2010 ')
 end