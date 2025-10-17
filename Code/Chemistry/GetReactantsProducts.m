function [reactants,products] = GetReactantsProducts(species,reactions)

species = species(:);
reactions = reactions(:);

str_standard = arrayfun(@(x)Convert2Standard(x), reactions);

str_unrolled = arrayfun(@(x)UnRoll(x), str_standard);

members = split(str_unrolled,"->");
molecules = arrayfun(@(x) split(x,"++"), members, 'UniformOutput', false);

mol = cellfun(@(x)Cell2SpeciesArray(x,arrayfun(@(x)" "+x+" ", species)), molecules, 'UniformOutput', false);

reactants = vertcat(mol{:,1});
products = vertcat(mol{:,2});

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
