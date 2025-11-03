function [ordered_var] = OrderVariable(var,species,ns,name,type_flag)

input_species_order = vertcat(string(var(:,1)));

if type_flag == 1
    non_ordered_var = var(:,2);
elseif type_flag == 2
    non_ordered_var = cellfun(@(x)string(x),vertcat(var{:,2}));
else
    non_ordered_var = vertcat(var{:,2});
end

if numel(input_species_order) ~= ns
    error("The number of input species is wrong in %s",name)
end
if sum(unique(input_species_order)==unique(species)) ~= ns
    error("The input species and the species from the chemical model do not match in %s",name)
end

[~,species_mapping] = ismember(species,input_species_order);

ordered_var = non_ordered_var(species_mapping,:);

end