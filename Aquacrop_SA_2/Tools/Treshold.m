treshold=1;
ord=sort(vs_indices.vm_mu_star(:,1));


Results(1:length(ord))=0;
for i=1:length(ord)
    if ord(i)>treshold
 Results(i)=find(ord(i)==vs_indices.vm_mu_star(:,1));
    end
 
end

Results=sort(Results)';
