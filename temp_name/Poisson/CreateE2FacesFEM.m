function [E2Faces] = CreateE2FacesFEM(inv_vol, link_face_to_cells, Nfaces, Nel)

li_zeros = link_face_to_cells(:,2) == 0;
link_face_to_cells(li_zeros,2) = 1;
coeff = inv_vol(link_face_to_cells);
coeff(li_zeros,2) = 0;
norm_coeff = coeff ./ sum(coeff,2);

II = [(1:Nfaces)'; (1:Nfaces)'];
JJ = link_face_to_cells(:);
SS = norm_coeff(:);

E2Faces = sparse(II, JJ, SS, Nfaces, Nel);

end

