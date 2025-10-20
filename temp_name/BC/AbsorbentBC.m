function [indices_faces_Absorbent, indices_cells_Absorbent] = AbsorbentBC(GetBfaces, GetBcells, BCflag)

[ids,species] = find(BCflag == "FreeDriftFlow");
indices_faces_Absorbent = [];
indices_cells_Absorbent = [];
for k = 1:numel(species)
    current_faces = GetBfaces(ids(k),species(k));
    current_cells = GetBcells(ids(k),species(k));
    indices_faces_Absorbent = [indices_faces_Absorbent; current_faces]; %#ok<AGROW>
    indices_cells_Absorbent = [indices_cells_Absorbent ; current_cells]; %#ok<AGROW>
end

end