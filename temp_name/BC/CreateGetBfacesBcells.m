function [GetBfaces, GetBcells] = CreateGetBfacesBcells(msh)

boundary_faces_from_bID = cell(msh.dim_bID,1);
boundary_cells_from_bID = cell(msh.dim_bID,1);

for i = 1:msh.dim_bID
    boundary_faces_from_bID{i} = msh.f_from_b(msh.bs_from_bID{i});
    boundary_cells_from_bID{i} = msh.cs_from_f(boundary_faces_from_bID{i},1);
end

GetBfaces = @(id,s) boundary_faces_from_bID{id} + msh.Nf*(s-1);
GetBcells = @(id,s) boundary_cells_from_bID{id} + msh.Nc*(s-1);

end
