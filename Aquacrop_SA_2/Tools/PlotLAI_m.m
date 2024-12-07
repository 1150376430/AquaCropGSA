figure(6)
for i=127:140 % for i=1:length(LAI_m(:,1))
plot(LAI_m(i,1:293),'DisplayName','LAI_m(1,1:293)','YDataSource','LAI_m(1,1:293)');figure(gcf)
hold on
end


figure()
bar(vs_indices.vm_mu_star(1:47,1),'DisplayName','vs_indices.vm_mu_star(1:47,1)');figure(gcf)
