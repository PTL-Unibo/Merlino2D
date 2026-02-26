function [phi2Ex, phi2Ey] = CreateEMatricesFEM(link_cell_to_nodes, xv, yv, Nel, Nnodes, dNdz)

Nnel = 3;

IIphi2Ex = zeros(Nel*Nnel,1);
JJphi2Ex = zeros(Nel*Nnel,1);
SSphi2Ex = zeros(Nel*Nnel,1);
IIphi2Ey = zeros(Nel*Nnel,1);
JJphi2Ey = zeros(Nel*Nnel,1);
SSphi2Ey = zeros(Nel*Nnel,1);

for i = 1:Nel
    nodes = link_cell_to_nodes(i,:);
    X = [xv(nodes), yv(nodes)]';
    J = (X * dNdz);
    gradN = (dNdz / J);
    IIphi2Ex((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = repelem(i,Nnel,1);
    JJphi2Ex((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = nodes;
    SSphi2Ex((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = gradN(:,1);
    IIphi2Ey((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = repelem(i,Nnel,1);
    JJphi2Ey((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = nodes;
    SSphi2Ey((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = gradN(:,2);
end

phi2Ex = sparse(IIphi2Ex, JJphi2Ex, -SSphi2Ex, Nel, Nnodes);
phi2Ey = sparse(IIphi2Ey, JJphi2Ey, -SSphi2Ey, Nel, Nnodes);

end
