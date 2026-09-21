function [M, Mindices, Nindices, stoichiometric_matrix] = MatrixChemistry(reactants, products, const_species, const_vals, np)

stoichiometric_matrix = products - reactants;
[nr, ns] = size(stoichiometric_matrix);
stoichiometric_matrix(:,const_species) = [];
stoichiometric_matrix = sparse(stoichiometric_matrix);

max_num_reactants = max(sum(reactants,2));

M = ones(max_num_reactants+1,nr*np);
dim = sum(sum(reactants,2))*np;
Mindices = zeros(dim,1);
Nindices = zeros(dim,1);

effective_ns = ns - numel(const_species);
species_mapping = sparse(setdiff(1:ns,const_species),ones(1,effective_ns),1:effective_ns,ns,1);

k = 1;
for r = 1:nr
    p = 1;
    for s = 1:ns
        coeff = reactants(r,s);
        if coeff ~= 0
            for i = 1:coeff
                [mindices,nindices] = GetIndices(r,p,species_mapping(s));
                is = find(const_species==s,1);
                if ~isempty(is)
                    M(mindices) = const_vals(is);
                else
                    Mindices((k-1)*np+1:np*k) = mindices;
                    Nindices((k-1)*np+1:np*k) = nindices;
                end
                p = p + 1;
                k = k + 1; 
            end
        end
    end
end
Mindices(Mindices==0) = [];
Nindices(Nindices==0) = [];
temp = [Mindices, Nindices];
temp = sortrows(temp);
Mindices = temp(:,1);
Nindices = temp(:,2);

function [mindices,nindices] = GetIndices(r,p,s)
    first = (max_num_reactants+1)*np*(r-1) + p + 1;
    last = first + (max_num_reactants+1)*(np-1);
    mindices = (first:(max_num_reactants+1):last)';
    nindices = ((s-1)*np+1:np*s)';
end

end
