function [indices_of_removed_boundaries] = GetRemovedIndices(full_msh)
indices_of_removed_boundaries = [];
for i = 1:full_msh.dim_bID
    if all(full_msh.cID_from_c(full_msh.cs_from_f(full_msh.f_from_b(full_msh.bs_from_bID{i})))>1)
        indices_of_removed_boundaries = [indices_of_removed_boundaries, i]; %#ok<AGROW>
    end
end
end
