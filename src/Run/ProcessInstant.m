function [N_CELLS,SIGMA,RHO_CELLS,VAPP,I_SATO,PHI_NODES,EX_CELLS,EY_CELLS,...
    EX,EY,OMEGA,GAMMA_X,GAMMA_Y,RATES,N_NODES,...
    RHO_NODES,EX_NODES,EY_NODES,I_bID] = ProcessInstant(out,k)

msh = out.msh;
A = out.A;
B = out.B;
ns = out.ns;
Dirichlet_nodes_indices = out.Dirichlet_nodes_indices;
non_Dirichlet_nodes_indices = out.non_Dirichlet_nodes_indices;
qs = out.qs;
I_s = out.I_s;
inv_mapping = out.inv_mapping;
odefun = out.odefun;
Phi2Ex_c = out.Phi2Ex_c;
Phi2Ey_c = out.Phi2Ey_c;

Nn = out.msh.Nn;
Nc = out.msh.Nc;
Nf = out.msh.Nf;
Nd = out.msh.Nd;

N_CELLS = out.yout(1:ns*Nc,k);
SIGMA = out.yout(ns*Nc+1:ns*Nc+Nd,k);
RHO_CELLS = e*sum(reshape(N_CELLS,Nc,ns).*qs,2);
VAPP = out.p.V_APPLIED(out.tout(k));

[~,DIRICHLET_NODES,BFVAL,EX,EY,OMEGA,GAMMA_X,GAMMA_Y,I,RATES] = odefun(out.tout(k), out.yout(:,k));

I_SATO = I + I_s(k);

% Electric potential at nodes
PHI_NODES(Dirichlet_nodes_indices) = DIRICHLET_NODES;
PHI_NODES(non_Dirichlet_nodes_indices) = out.yout(ns*Nc+Nd+1:end,k);
PHI_NODES = PHI_NODES';
% now PHI_NODES contains the values of the full mesh
EX_CELLS = Phi2Ex_c * PHI_NODES;
EY_CELLS = Phi2Ey_c * PHI_NODES;
% keep PHI_NODES only at air nodes
PHI_NODES = PHI_NODES(inv_mapping);

N_NODES = A*N_CELLS + B*BFVAL; 
RHO_NODES = e*sum(reshape(N_NODES,Nn,ns).*qs,2);

EX_NODES = msh.Face2Node * EX;
EY_NODES = msh.Face2Node * EY;

nx_matrix = spdiags(repmat(msh.sn(:,1),ns), 0, ns*Nf, ns*Nf);
ny_matrix = spdiags(repmat(msh.sn(:,2),ns), 0, ns*Nf, ns*Nf); 
GAMMA_DOT_N = nx_matrix*GAMMA_X + ny_matrix*GAMMA_Y;

I_bID = zeros(msh.dim_bID,ns);
J_faces = e * reshape(GAMMA_DOT_N, Nf, ns) .* qs;
for i = 1:msh.dim_bID
 indices = msh.f_from_b(msh.bs_from_bID{i});
 I_bID(i,:) = sum(J_faces(indices,:) .* msh.areaf(indices),1);
end

end