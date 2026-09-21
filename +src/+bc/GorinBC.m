function [indices_faces_Gorin, indices_cells_Gorin,...
    indices_faces_Gorin_electrons, indices_faces_Gorin_positive_ions,...
    v_th_x, v_th_y] = GorinBC(GetBfaces, GetBcells, BCflag, qs, v_th_single, sn)

indices_pos_ions = find(qs > 0);

[ids,species] = find(BCflag == "GorinLike");
indices_faces_Gorin = [];
indices_cells_Gorin = [];
v_th_x = [];
v_th_y = [];
for k = 1:numel(species)
    current_faces = GetBfaces(ids(k),species(k));
    current_cells = GetBcells(ids(k),species(k));
    indices_faces_Gorin = [indices_faces_Gorin; current_faces]; %#ok<AGROW>
    indices_cells_Gorin = [indices_cells_Gorin; current_cells]; %#ok<AGROW>
    v_th_x = [v_th_x; v_th_single(species(k))*sn(GetBfaces(ids(k),1),1)]; %#ok<AGROW>
    v_th_y = [v_th_y; v_th_single(species(k))*sn(GetBfaces(ids(k),1),2)]; %#ok<AGROW>
end

BCflag = AddGorin_e(BCflag);

[ids,~] = find(BCflag == "GorinLike_electrons");

indices_faces_Gorin_electrons = [];
indices_faces_Gorin_positive_ions = [];
for k = 1:numel(ids)
    partial_indices_faces_Gorin_positive_ions = [];
    for p = indices_pos_ions
        partial_indices_faces_Gorin_positive_ions = [partial_indices_faces_Gorin_positive_ions,GetBfaces(ids(k),p)]; %#ok<AGROW>
    end
    indices_faces_Gorin_positive_ions = [indices_faces_Gorin_positive_ions;partial_indices_faces_Gorin_positive_ions]; %#ok<AGROW>
    current_gorin_electron_faces = GetBfaces(ids(k),1);
    indices_faces_Gorin_electrons = [indices_faces_Gorin_electrons; current_gorin_electron_faces]; %#ok<AGROW>
end

end
