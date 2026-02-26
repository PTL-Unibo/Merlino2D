function [ordered_species] = OrderSpecies(species)

ns = numel(species);
index_electrons = find(species==" e ", 1);
if isempty(index_electrons)
    error("Electrons 'e' must be present in the species")
else
    ii = [index_electrons, 1:(index_electrons-1), (index_electrons+1):ns];
    ordered_species = species(ii);
end

end
