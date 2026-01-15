function [AxVol, AxArea] = AxisymmetricVolumeArea(link_cell_to_nodes, link_face_to_nodes, link_cell_to_faces, link_nodes_to_face, xv, yv, Ncells, Nfaces)

x1 = xv(link_face_to_nodes(:,1));
y1 = yv(link_face_to_nodes(:,1));
x2 = xv(link_face_to_nodes(:,2));
y2 = yv(link_face_to_nodes(:,2));

AxArea = pi * sqrt((x2-x1).^2 + (y2-y1).^2) .* (y1 + y2);

axfvol = (1/3) * pi * abs(x2 - x1) .* (y1.^2 + y2.^2 + y1.*y2);

n1 = link_cell_to_nodes(:,1);
n2 = link_cell_to_nodes(:,2);
n3 = link_cell_to_nodes(:,3);

x1 = xv(n1);
x2 = xv(n2);
x3 = xv(n3);

[~, i_max] = max([x1,x2,x3],[],2);
[~, i_min] = min([x1,x2,x3],[],2);

M_max = sparse(1:Ncells, i_max, ones(1,Ncells), Ncells, 3);
M_min = sparse(1:Ncells, i_min, ones(1,Ncells), Ncells, 3);
M_other = ones(Ncells,3) - (M_min + M_max);

[~,i_other] = max(M_other,[],2);

n_max = link_cell_to_nodes(sub2ind([Ncells,3],(1:Ncells)',i_max));
n_min = link_cell_to_nodes(sub2ind([Ncells,3],(1:Ncells)',i_min));
n_other = link_cell_to_nodes(sub2ind([Ncells,3],(1:Ncells)',i_other));

li_type_2 = ((yv(n_other) < yv(n_min)) & (yv(n_other) < yv(n_max))); % type 2 corresponds to "other node" on the bottom

nodes_of_different_face = [n_max, n_min];
li = nodes_of_different_face(:,1) > nodes_of_different_face(:,2);
nodes_of_different_face(li,:) = flip(nodes_of_different_face(li,:),2);

CoeffMatrix = ones(Ncells,3);
CoeffMatrix(li_type_2,:) = -1;

different_faces = zeros(Ncells,1);
for i = 1:Ncells
    different_faces(i) = link_nodes_to_face(nodes_of_different_face(i,1),nodes_of_different_face(i,2));
    li_val = link_cell_to_faces(i,:) == different_faces(i);
    CoeffMatrix(i,li_val) = -CoeffMatrix(i,li_val);
end

I = repmat(1:Ncells,1,3);
J = link_cell_to_faces(:);
S = CoeffMatrix(:);

AxFaceVol2AxVol = sparse(I,J,S,Ncells,Nfaces);

AxVol = AxFaceVol2AxVol * axfvol; 

end
