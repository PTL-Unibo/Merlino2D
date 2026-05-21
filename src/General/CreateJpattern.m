function [Jpattern] = CreateJpattern(msh, qs, Kelet, Flux2N, phi2En, rho2RHS, dphidv, dvdn, dvdphi, i_c_depend_on_v, i_sigma_depend_on_v, inv_mapping, non_Dirichlet_nodes_indices)

ns = numel(qs);
Nc = msh.Nc;
Nd = msh.Nd;
Nphi = size(Kelet,1);

% P_full
I_DnDphi = [];
J_DnDphi = [];
for ic = 1:Nc
    jj = unique(vertcat(msh.cs_from_n{msh.ns_from_c(ic,:)}));
    J_DnDphi = [J_DnDphi; jj];
    I_DnDphi = [I_DnDphi; ic*ones(size(jj))];
end
P = sparse(I_DnDphi,J_DnDphi,ones(size(I_DnDphi)),Nc,Nc);

% P_sigma_n
P_sigma_n = sparse(1:Nd, ...
                   msh.cs_from_f(msh.f_from_d,1), ...
                   ones(1,Nd), ...
                   Nd, Nc);


M = spdiags(ones(Nc*ns,2*(ns-1)),[-(ns-1)*Nc:Nc:-Nc,Nc:Nc:(ns-1)*Nc],Nc*ns,Nc*ns);
for is = 1:ns
    M(1+(is-1)*Nc:is*Nc,1+(is-1)*Nc:is*Nc) = P;
end

S = repmat(P_sigma_n,1,ns);
for is = 1:ns
    if qs(is) == 0
        S(:,1+(is-1)*Nc:is*Nc) = 0;
    end
end

M = [M; S];

DnsDns = [M, zeros(ns*Nc+Nd,Nd)];

% DnDphi_old = Flux2N*repmat(phi2En,ns,1);
% DsDphi = phi2En(msh.f_from_d,:);

% New version of DnDphi and DsDphi
diel_cells = msh.cs_from_f(msh.f_from_d,1);
I_DnDphi = [];
J_DnDphi = [];
I_DsDphi = [];
J_DsDphi = [];
for ic = 1:msh.Nc
    cells = unique(msh.cs_from_f(msh.fs_from_c(ic,:),:));
    cells(cells==0) = [];
    nodes = unique(msh.ns_from_c(cells,:));
    nodes = inv_mapping(nodes);
    [~,nodes] = ismember(nodes,non_Dirichlet_nodes_indices);
    nodes(nodes==0) = [];
    I_DnDphi = [I_DnDphi, repmat(ic,1,numel(nodes))];
    J_DnDphi = [J_DnDphi; nodes];
    [~,s_index] = ismember(ic,diel_cells);
    if s_index>0
        I_DsDphi = [I_DsDphi, repelem(s_index,1,numel(nodes))];
        J_DsDphi = [J_DsDphi; nodes];
    end
end
DnDphi = repmat(sparse(I_DnDphi,J_DnDphi,1,Nc,Nphi),ns,1);
DsDphi = sparse(I_DsDphi,J_DsDphi,1,Nd,Nphi);

R = [];
for i = 1:ns
    R = [R, speye(Nc)*qs(i)]; %#ok<AGROW>
end
RS = [[R, zeros(Nc,Nd)]; [zeros(Nd,Nc*ns), speye(Nd)]];

DAE = [rho2RHS * RS, Kelet];

DnDv = repmat(sparse(i_c_depend_on_v,ones(size(i_c_depend_on_v)),1,Nc,1),ns,1);
DsDv = sparse(i_sigma_depend_on_v,ones(size(i_sigma_depend_on_v)),1,Nd,1);

Jpattern = [[DnsDns,[DnDphi;DsDphi],zeros(ns*Nc+Nd,1),[DnDv;DsDv]]; ...
    [DAE, zeros(Nphi,1), dphidv]; ...
    [zeros(1,Nc*ns+Nd+Nphi), 1, 1];...
    [dvdn, zeros(1,Nd), dvdphi, 0, 1]];

end
