function [const_species] = GetConstSpecies(const_species_in, Ngas)
if isempty(const_species_in)
    const_species = {"", []};
else
    dim = size(const_species_in,1);
    const_species = cell(dim,2);
    const_species(:,1) = const_species_in(:,1);
    for i = 1:dim
        if const_species_in{i,3} == "abs"
            const_species{i,2} = const_species_in{i,2};
        elseif const_species_in{i,3} == "rel"
            const_species{i,2} = const_species_in{i,2}*Ngas;
        end
    end
end

end
