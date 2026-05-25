function [out_pp_k] = ProcessInstant(out,k)

msh = out.msh;
A = out.A;
B = out.B;
ns = out.ns;
qs = out.qs;
inv_mapping = out.inv_mapping;
odefun = out.odefun;
phi2ExFull = out.phi2ExFull;
phi2EyFull = out.phi2EyFull;

Nn = out.msh.Nn;
Nc = out.msh.Nc;
Nf = out.msh.Nf;
Nd = out.msh.Nd;

N_CELLS = out.yout(1:ns*Nc,k);
SIGMA = out.yout(ns*Nc+1:ns*Nc+Nd,k);
RHO_CELLS = e*sum(reshape(N_CELLS,Nc,ns).*qs,2);
I_TOT = out.yout(end-1,k);
V = out.yout(end,k);
VEXT = out.p.V_APPLIED(out.tout(k));

[~,BFVAL,EX,EY,OMEGA,GAMMA_X,GAMMA_Y,~,RATES,RATE_COEFF] = odefun(out.tout(k), out.yout(:,k));

% Electric potential at nodes
PHI_NODES = out.yout(ns*Nc+Nd+1:end-2,k); % PHI_NODES contains the values of the full mesh
EX_CELLS = phi2ExFull * PHI_NODES;
EY_CELLS = phi2EyFull * PHI_NODES;
PHI_NODES = PHI_NODES(inv_mapping); % keep PHI_NODES only at air nodes

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

out_pp_k.N_CELLS    = N_CELLS;
out_pp_k.SIGMA      = SIGMA;
out_pp_k.RHO_CELLS  = RHO_CELLS;
out_pp_k.V          = V;
out_pp_k.VEXT       = VEXT;
out_pp_k.I_TOT      = I_TOT;
out_pp_k.PHI_NODES  = PHI_NODES;
out_pp_k.EX_CELLS   = EX_CELLS;
out_pp_k.EY_CELLS   = EY_CELLS;
out_pp_k.EX         = EX;
out_pp_k.EY         = EY;
out_pp_k.OMEGA      = OMEGA;
out_pp_k.GAMMA_X    = GAMMA_X;
out_pp_k.GAMMA_Y    = GAMMA_Y;
out_pp_k.RATES      = RATES;
out_pp_k.RATE_COEFF = RATE_COEFF;
out_pp_k.N_NODES    = N_NODES;
out_pp_k.RHO_NODES  = RHO_NODES;
out_pp_k.EX_NODES   = EX_NODES;
out_pp_k.EY_NODES   = EY_NODES;
out_pp_k.I_bID      = I_bID;

end