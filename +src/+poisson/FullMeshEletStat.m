function [Kelet, rho2RHS, bc2RHS] = FullMeshEletStat(full_msh, BCEL_FLAG, EPSR_VAL, coordinates)

Nnel = 3;
Nc = full_msh.Nc; % number of elements

[w,Z,dNdz, N] = get_fem_parameters();

select_nodes = sortrows([full_msh.ns_from_b(:), repmat(1:full_msh.Nb,1,2)']);
link_node_to_bfaces = sparse(select_nodes(:,1), repmat([1,2],1,full_msh.Nb), select_nodes(:,2), full_msh.Nn, 2);

II_Kelet = zeros(Nc*Nnel*Nnel,1);
JJ_Kelet = zeros(Nc*Nnel*Nnel,1);
SS_Kelet = zeros(Nc*Nnel*Nnel,1);

II_rho_rhs = zeros(Nc*Nnel + full_msh.Nd*2,1);
JJ_rho_rhs = zeros(Nc*Nnel + full_msh.Nd*2,1);
SS_rho_rhs = zeros(Nc*Nnel + full_msh.Nd*2,1);

if lower(coordinates) == "cartesian"
    f_fem_element = @(p,X,N,dNdz,Z,w) fem_element(p,X,N,dNdz,Z,w);
    f_fem_rhs = @(t,X,N,dNdz,Z,w) fem_rhs(t,X,N,dNdz,Z,w);
elseif lower(coordinates) == "cylindrical"
    f_fem_element = @(p,X,N,dNdz,Z,w) fem_element_cyl(p,X,N,dNdz,Z,w);
    f_fem_rhs = @(t,X,N,dNdz,Z,w) fem_rhs_cyl(t,X,N,dNdz,Z,w);
end

t = @(x) 1;
for i = 1:Nc
    nodes = full_msh.ns_from_c(i,:);
    X = [full_msh.xn(nodes), full_msh.yn(nodes)]';
    p = @(x) EPSR_VAL(full_msh.cID_from_c(i));
    Kel = f_fem_element(p,X,N,dNdz,Z,w);
    RHSel = f_fem_rhs(t,X,N,dNdz,Z,w);
    II_Kelet((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = repmat(nodes,1,Nnel);
    JJ_Kelet((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = repelem(nodes,Nnel);
    SS_Kelet((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = Kel(:);
    II_rho_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = nodes;
    JJ_rho_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = repelem(i,1,Nnel);
    SS_rho_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = RHSel;
end

k = 0;
for i_f = full_msh.f_from_d'
    k = k + 1;
    nodes = full_msh.ns_from_f(i_f,:);
    start = Nc*Nnel + 1 + (k-1)*2;
    II_rho_rhs(start:start+1) = nodes;
    JJ_rho_rhs(start:start+1) = Nc + [k, k];
    SS_rho_rhs(start:start+1) = [full_msh.areaf(i_f), full_msh.areaf(i_f)] / 2;
end

Dirichlet_nodes_indices = unique(full_msh.ns_from_f(full_msh.f_from_b(vertcat(full_msh.bs_from_bID{BCEL_FLAG==0})),:));
non_Dirichlet_nodes_indices = setdiff((1:full_msh.Nn)',Dirichlet_nodes_indices);

Kelet = sparse(II_Kelet, JJ_Kelet, SS_Kelet, full_msh.Nn, full_msh.Nn);
rho2RHS = sparse(II_rho_rhs, JJ_rho_rhs, SS_rho_rhs, full_msh.Nn, Nc + full_msh.Nd);
Kelet(Dirichlet_nodes_indices,:) = 0;
Kelet(sub2ind(size(Kelet),Dirichlet_nodes_indices,Dirichlet_nodes_indices)) = 1;
rho2RHS(Dirichlet_nodes_indices,:) = 0;

M_get_aux_BC_el = CreateMgetDirNodes(link_node_to_bfaces, full_msh.bID_from_b, Dirichlet_nodes_indices, BCEL_FLAG);
select_nodes = sparse(Dirichlet_nodes_indices,1:numel(Dirichlet_nodes_indices),1,full_msh.Nn,numel(Dirichlet_nodes_indices));
bc2RHS = select_nodes * M_get_aux_BC_el;

if full_msh.dim_cID > 1
    rho2RHS(:,vertcat(full_msh.cs_from_cID{2:full_msh.dim_cID})) = [];
end

end

function [ke] = fem_element(p,X,N,dNdz,Z,w)
ke = zeros(size(X,2));
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    gradN = dNdz(z) / J;
    x = X * N(z);
    % ke_i = p(X*N(z))*dNdz(z)/(dNdz(z)'*X'*X*dNdz(z))*dNdz(z)'*abs(det(X*dNdz(z)))
    ke_i = p(x) * (gradN * gradN') * abs(det(J));
    ke = ke + w(i) * ke_i;
end
end

function [ke] = fem_element_cyl(p,X,N,dNdz,Z,w)
ke = zeros(size(X,2));
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    gradN = dNdz(z) / J;
    x = X * N(z);
    ke_i = p(x) * (gradN * gradN') * abs(det(J)) * x(2);
    ke = ke + w(i) * ke_i;
end
end

function [krhs] = fem_rhs(t,X,N,dNdz,Z,w)
krhs = zeros(size(X,2),1);
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    x = X * N(z);
    krhs_i = N(z)*t(x)*abs(det(J));
    krhs = krhs + w(i) * krhs_i;
end
end

function [krhs] = fem_rhs_cyl(t,X,N,dNdz,Z,w)
krhs = zeros(size(X,2),1);
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    x = X * N(z);
    krhs_i = N(z)*t(x)*abs(det(J)) * x(2);
    krhs = krhs + w(i) * krhs_i;
end
end

function [w,Z,dNdz, N] = get_fem_parameters()

    w = 0.5 * [4.50000000000000011102230246251565e-01
               5.00000000000000027755575615628914e-02
               5.00000000000000027755575615628914e-02
               5.00000000000000027755575615628914e-02
               1.33333333333333331482961625624739e-01
               1.33333333333333331482961625624739e-01
               1.33333333333333331482961625624739e-01];
    
    Z = [3.33333333333333314829616256247391e-01 3.33333333333333314829616256247391e-01
         0.00000000000000000000000000000000e+00 0.00000000000000000000000000000000e+00
         0.00000000000000000000000000000000e+00 1.00000000000000000000000000000000e+00
         1.00000000000000000000000000000000e+00 0.00000000000000000000000000000000e+00
         5.00000000000000000000000000000000e-01 5.00000000000000000000000000000000e-01
         5.00000000000000000000000000000000e-01 0.00000000000000000000000000000000e+00
         0.00000000000000000000000000000000e+00 5.00000000000000000000000000000000e-01];
    
    dNdz = @(z) [1, 0; 0, 1; -1, -1];
    N = @(z) [z(1); z(2); 1-z(1)-z(2)];

end
