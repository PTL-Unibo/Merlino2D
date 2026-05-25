function [Jpattern] = CreateJpattern(msh, qs, Kelet, NcSigma2RHS, dphidv, indices_cells_el, inv_mapping)

ns = numel(qs);
Nc = msh.Nc;
Nd = msh.Nd;
Nphi = size(Kelet,1);

I_DnDn = zeros(4*Nc,1);
J_DnDn = zeros(4*Nc,1);
k = 1;
for ic = 1:Nc
    jj = unique(msh.cs_from_f(msh.fs_from_c(ic,:),:));
    jj(jj==0) = [];
    dim = numel(jj);
    I_DnDn(k:(k+dim-1)) = ic;
    J_DnDn(k:(k+dim-1)) = jj;
    k = k + dim;
end
I_DnDn(I_DnDn==0) = [];
J_DnDn(J_DnDn==0) = [];
I_DnDn_diag = reshape(I_DnDn + (0:Nc:(ns-1)*Nc),[],1);
J_DnDn_diag = reshape(J_DnDn + (0:Nc:(ns-1)*Nc),[],1);
P_full = sparse(I_DnDn_diag, J_DnDn_diag, 1, ns*Nc, ns*Nc);
DnDn = P_full + spdiags(ones(Nc*ns,2*(ns-1)),[-(ns-1)*Nc:Nc:-Nc,Nc:Nc:(ns-1)*Nc],Nc*ns,Nc*ns);

I_DsDn = (1:Nd)';
J_DsDn = msh.cs_from_f(msh.f_from_d,1);
I_DsDn_big = repmat(I_DsDn,1,ns);
J_DsDn_big = J_DsDn + (0:Nc:(ns-1)*Nc);
I_DsDn_big = I_DsDn_big .* abs(qs);
J_DsDn_big = J_DsDn_big .* abs(qs);
I_DsDn_big(I_DsDn_big==0) = [];
J_DsDn_big(J_DsDn_big==0) = [];
DsDn = sparse(I_DsDn_big, J_DsDn_big, 1, Nd, ns*Nc);

DnsDns = [[DnDn; DsDn], zeros(ns*Nc+Nd,Nd)];

I_DnDphi = zeros(6*Nc,1);
J_DnDphi = zeros(6*Nc,1);
k = 1;
for ic = 1:Nc
    cells = unique(msh.cs_from_f(msh.fs_from_c(ic,:),:));
    cells(cells==0) = [];
    nodes = unique(msh.ns_from_c(cells,:));
    dim = numel(nodes);
    I_DnDphi(k:(k+dim-1)) = ic;
    J_DnDphi(k:(k+dim-1)) = inv_mapping(nodes);
    k = k + dim;
end
I_DnDphi(I_DnDphi==0) = [];
J_DnDphi(J_DnDphi==0) = [];
DnDphi = repmat(sparse(I_DnDphi, J_DnDphi, 1, Nc, Nphi), ns, 1);

I_DsDphi = zeros(3*Nd,1);
J_DsDphi = zeros(3*Nd,1);
id = 1;
diel_cells = msh.cs_from_f(msh.f_from_d,1);
for ic_diel = diel_cells'
    nodes = msh.ns_from_c(ic_diel,:);
    I_DsDphi(1+(id-1)*3:id*3) = id;
    J_DsDphi(1+(id-1)*3:id*3) = inv_mapping(nodes);
    id = id + 1;
end
DsDphi = sparse(I_DsDphi, J_DsDphi, 1, Nd, Nphi);

DnsphiDnsphi = [DnsDns, [DnDphi; DsDphi]];

dvdphi_nodes = unique(msh.ns_from_c(indices_cells_el,:));
dvdphi_nodes = inv_mapping(dvdphi_nodes);
dvdphi = sparse(ones(size(dvdphi_nodes)), dvdphi_nodes, 1, 1, Nphi);

indices_cells_el = indices_cells_el + (0:msh.Nc:(ns-1)*msh.Nc);
indices_cells_el = indices_cells_el .* abs(qs);
indices_cells_el(indices_cells_el==0) = [];
dvdn = sparse(ones(size(indices_cells_el)), indices_cells_el, 1, 1, ns*msh.Nc);

Jpattern = [...
    [DnsphiDnsphi, zeros(ns*Nc+Nd,2)]; ...
    [[NcSigma2RHS, Kelet], zeros(Nphi,1), dphidv]; ...
    [zeros(1,Nc*ns+Nd+Nphi), 1, 1];...
    [dvdn, zeros(1,Nd), dvdphi, 0, 1]...
    ];

end
