function [Kelet, rho2RHS, M_get_aux_BC_el, aux2RHS, ...
          phi2Ex, phi2Ey, aux2Ex, aux2Ey, phi2En, aux2En, ...
          inv_mapping, Dirichlet_nodes_indices, non_Dirichlet_nodes_indices] = EletStatFEM(msh, full_msh, BCEL_FLAG, EPSR_VAL, coordinates)

[Kelet, rho2RHS, M_get_aux_BC_el, aux2RHS, Dirichlet_nodes_indices, non_Dirichlet_nodes_indices] = ...
    FullMeshEletStat(full_msh, BCEL_FLAG, EPSR_VAL, coordinates);

inv_mapping = find(msh.nodes_mapping);
[~,~,small_Dirichlet_nodes_indices] = find(msh.nodes_mapping(Dirichlet_nodes_indices));
small_non_Dirichlet_nodes_indices = setdiff((1:msh.Nn)', small_Dirichlet_nodes_indices);

% fix the electric field at zero Neumann faces-----------------------------%|
removed_indices = GetRemovedIndices(full_msh);                             %|
small_BCEL_FLAG = BCEL_FLAG;                                               %|
small_BCEL_FLAG(removed_indices) = [];                                     %|
Neumann_zero_boundaries = vertcat(msh.bs_from_bID{small_BCEL_FLAG==1});    %|
Neumann_zero_faces = msh.f_from_b(Neumann_zero_boundaries);                %|
Neumann_zero_nodes = msh.ns_from_b(Neumann_zero_boundaries,:);             %|
%--------------------------------------------------------------------------%|

dNdz = [1,0;0,1;-1,-1]; % 2D triangles 1st order shape functions
[phi2Ex, phi2Ey] = CreateEMatricesFEM(msh.ns_from_c, msh.xn, msh.yn, msh.Nc, msh.Nn, dNdz);
E2Faces = CreateE2FacesFEM(msh.inv_vol_standard, msh.cs_from_f, msh.Nf, msh.Nc);
E2Faces(Neumann_zero_faces,:) = 0;
phi2Ex = E2Faces * phi2Ex;
phi2Ey = E2Faces * phi2Ey;

% fix the electric field at zero Neumann faces----------------------------------------------------------------------------------------------------%|
if numel(Neumann_zero_faces) > 0                                                                                                                  %|
    ii = repelem(Neumann_zero_faces,2);                                                                                                           %|
    jj = reshape(Neumann_zero_nodes',[],1);                                                                                                       %|
    ss = reshape(reshape(repelem(reshape(msh.Tv(Neumann_zero_faces,:)./(msh.areaf_standard(Neumann_zero_faces).^2),[],1),2),2,[]).*[1;-1],[],1);  %|
    phi2Ex(sub2ind(size(phi2Ex),ii,jj)) = ss(1:numel(ss)/2);                                                                                      %|
    phi2Ey(sub2ind(size(phi2Ey),ii,jj)) = ss(numel(ss)/2+1:end);                                                                                  %|
end                                                                                                                                               %|
% ------------------------------------------------------------------------------------------------------------------------------------------------%|

aux2Ex = phi2Ex(:,small_Dirichlet_nodes_indices);
aux2Ey = phi2Ey(:,small_Dirichlet_nodes_indices);
phi2Ex = phi2Ex(:,small_non_Dirichlet_nodes_indices);
phi2Ey = phi2Ey(:,small_non_Dirichlet_nodes_indices);

temp = [Dirichlet_nodes_indices, (1:numel(Dirichlet_nodes_indices))'];
real_index_aux = sparse(temp(:,1), ones(size(temp(:,1))), temp(:,2));
temp = [non_Dirichlet_nodes_indices, (1:numel(non_Dirichlet_nodes_indices))'];
real_index_phi = sparse(temp(:,1), ones(size(temp(:,1))), temp(:,2));
indices_phi_full_phi = inv_mapping(small_non_Dirichlet_nodes_indices);
indices_phi_full_aux_BC_el = inv_mapping(small_Dirichlet_nodes_indices);
indices_phi = full(real_index_phi(indices_phi_full_phi));
indices_aux = full(real_index_aux(indices_phi_full_aux_BC_el));
phi2Ex = phi2Ex * sparse(1:numel(indices_phi), indices_phi, ones(size(indices_phi)), numel(indices_phi), numel(non_Dirichlet_nodes_indices));
phi2Ey = phi2Ey * sparse(1:numel(indices_phi), indices_phi, ones(size(indices_phi)), numel(indices_phi), numel(non_Dirichlet_nodes_indices));
aux2Ex = aux2Ex * sparse(1:numel(indices_aux), indices_aux, ones(size(indices_aux)), numel(indices_aux), numel(Dirichlet_nodes_indices));
aux2Ey = aux2Ey * sparse(1:numel(indices_aux), indices_aux, ones(size(indices_aux)), numel(indices_aux), numel(Dirichlet_nodes_indices));

nx_matrix = spdiags(msh.sn(:,1),0,msh.Nf,msh.Nf);
ny_matrix = spdiags(msh.sn(:,2),0,msh.Nf,msh.Nf);
phi2En = nx_matrix * phi2Ex + ny_matrix * phi2Ey;
aux2En = nx_matrix * aux2Ex + ny_matrix * aux2Ey;

end
