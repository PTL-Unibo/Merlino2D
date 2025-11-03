function [species,reactants,products,indices_const_species] = GetReactantsProducts(reactions, const_species)
% reactions and const_species should always be a column string array

str_standard = arrayfun(@(x)Convert2Standard(x), reactions);

str_unrolled = arrayfun(@(x)UnRoll(x), str_standard);

members = split(str_unrolled,"->");
molecules = arrayfun(@(x) split(x,"++"), members, 'UniformOutput', false);

species_with_space = OrderSpecies(unique(vertcat(molecules{:})));

mol = cellfun(@(x)Cell2SpeciesArray(x,species_with_space), molecules, 'UniformOutput', false);

reactants = vertcat(mol{:,1});
products = vertcat(mol{:,2});
species = strrep(species_with_space," ",""); % trim spaces

[~,indices_const_species] = ismember(strtrim(const_species),species);
if indices_const_species == 0
    indices_const_species = [];
end

species(indices_const_species) = [];

end

function [count_array] = Cell2SpeciesArray(cell_in,species)
    [~,indices] = ismember(cell_in,species);
    count_array = histcounts(indices,"BinLimits",[0.5,numel(species)+0.5],"BinWidth",1);
end

function [out_string] = MultiplySpecies(block)
% <block> should be something like " 4N3H4 "
    num = regexp(block, "\s(\d+)\S*\s{1}", "tokens");
    molecule = regexp(block, "\s\d+(\S*)\s{1}", "tokens");
    out_string = " " + strjoin(repmat(molecule{1},1,str2double(num{1})), " ++ ") + " ";
end

function [string_out] = Convert2Standard(string_in)
    string_out = strrep(string_in," + "," ++ ");
    string_out = " " + string_out + " "; 
    string_out = strrep(string_out,"    "," ");
    string_out = strrep(string_out,"   "," ");
    string_out = strrep(string_out,"  "," ");
end

function [string_out] = UnRoll(string_in)
    string_out = string_in;
    tokens = regexp(string_in, "\s\d+\S*\s{1}", 'match');
    if ~isempty(tokens)
        for k = 1:numel(tokens)
            string_out = strrep(string_out,tokens(k),MultiplySpecies(tokens(k)));
        end
    end
end
