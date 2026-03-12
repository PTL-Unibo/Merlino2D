function [Ks,Si2RHS,ph_coeff,indices_src_reactions_ph,CellFromNodesPh] = ...
    CreatePh(exp_fitting,P,coordinates,Nc,Nn,xn,yn,ns_from_c,ns_from_b,bs_from_bID,BCPH_FLAG,species_coeff,ph_reactions,species,reactions)

weights = ...
    0.5 * [4.50000000000000011102230246251565e-01
    5.00000000000000027755575615628914e-02
    5.00000000000000027755575615628914e-02
    5.00000000000000027755575615628914e-02
    1.33333333333333331482961625624739e-01
    1.33333333333333331482961625624739e-01
    1.33333333333333331482961625624739e-01];
    
coords = ...
    [3.33333333333333314829616256247391e-01 3.33333333333333314829616256247391e-01
    0.00000000000000000000000000000000e+00 0.00000000000000000000000000000000e+00
    0.00000000000000000000000000000000e+00 1.00000000000000000000000000000000e+00
    1.00000000000000000000000000000000e+00 0.00000000000000000000000000000000e+00
    5.00000000000000000000000000000000e-01 5.00000000000000000000000000000000e-01
    5.00000000000000000000000000000000e-01 0.00000000000000000000000000000000e+00
    0.00000000000000000000000000000000e+00 5.00000000000000000000000000000000e-01];
    
dNdz = @(z) [1, 0; 0, 1; -1, -1];
N = @(z) [z(1); z(2); 1-z(1)-z(2)];
Nnel = 3;

A3 = [1.986e-4;0.0051;0.4886]*760*760*1e2*1e2;
lambda3 = [0.0553;0.1460;0.89]*760*1e2;

A2 = [0.0021;0.1775]*760*760*1e2*1e2;
lambda2 = [0.0974;0.5877]*760*1e2;

pq = (30/760)*101325; % quenching pressure = 30 Torr
pO2 = 0.21; % partial pressure of O2

pressure_coeff = pq/(P+pq);

if lower(coordinates) == "cartesian"
    f_fem_element = @(k,X,N,dNdz,Z,w) fem_element(k,X,N,dNdz,Z,w);
    f_fem_rhs = @(X,N,dNdz,Z,w) fem_rhs(X,N,dNdz,Z,w);
elseif lower(coordinates) == "cylindrical"
    f_fem_element = @(k,X,N,dNdz,Z,w) fem_element_cyl(k,X,N,dNdz,Z,w);
    f_fem_rhs = @(X,N,dNdz,Z,w) fem_rhs_cyl(X,N,dNdz,Z,w);
end

dirichlet_nodes = unique(ns_from_b(vertcat(bs_from_bID{BCPH_FLAG==0}),:));
dirichlet_nodes = reshape(dirichlet_nodes + (0:Nn:(exp_fitting-1)*Nn),[],1);

BIG_II_KS = [];
BIG_JJ_KS = [];
BIG_SS_KS = [];

BIG_II_Si_rhs = [];
BIG_JJ_Si_rhs = [];
BIG_SS_Si_rhs = [];

for j = 1:exp_fitting
    II_Ks = zeros(Nc*Nnel*Nnel,1);
    JJ_Ks = zeros(Nc*Nnel*Nnel,1);
    SS_Ks = zeros(Nc*Nnel*Nnel,1);
    II_Si_rhs = zeros(Nc*Nnel,1);
    JJ_Si_rhs = zeros(Nc*Nnel,1);
    SS_Si_rhs = zeros(Nc*Nnel,1);
    
    if exp_fitting == 3
        k = lambda3(j)*pO2;
        A_coeff = A3(j)*pO2^2;
    elseif exp_fitting == 2
        k = lambda2(j)*pO2;
        A_coeff = A2(j)*pO2^2;
    end

    for i = 1:Nc
        nodes = ns_from_c(i,:);
        X = [xn(nodes), yn(nodes)]';
        Kel = f_fem_element(k,X,N,dNdz,coords,weights);
        RHSel = f_fem_rhs(X,N,dNdz,coords,weights);
        II_Ks((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = repmat(nodes,1,Nnel);
        JJ_Ks((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = repelem(nodes,Nnel);
        SS_Ks((i-1)*Nnel^2+1:(i-1)*Nnel^2+Nnel^2) = Kel(:);
        II_Si_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = nodes;
        JJ_Si_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = repelem(i,1,Nnel);
        SS_Si_rhs((i-1)*Nnel+1:(i-1)*Nnel+Nnel) = RHSel*pressure_coeff*A_coeff;
    end

    BIG_II_KS = [BIG_II_KS; II_Ks+(j-1)*Nn]; %#ok<AGROW>
    BIG_JJ_KS = [BIG_JJ_KS; JJ_Ks+(j-1)*Nn]; %#ok<AGROW>
    BIG_SS_KS = [BIG_SS_KS; SS_Ks]; %#ok<AGROW>

    BIG_II_Si_rhs = [BIG_II_Si_rhs; II_Si_rhs+(j-1)*Nn]; %#ok<AGROW>
    BIG_JJ_Si_rhs = [BIG_JJ_Si_rhs; JJ_Si_rhs]; %#ok<AGROW>
    BIG_SS_Si_rhs = [BIG_SS_Si_rhs; SS_Si_rhs]; %#ok<AGROW>
end

Ks = sparse(BIG_II_KS, BIG_JJ_KS, BIG_SS_KS, exp_fitting*Nn, exp_fitting*Nn);
Ks(dirichlet_nodes,:) = 0;
Ks(sub2ind(size(Ks),dirichlet_nodes,dirichlet_nodes)) = 1;

Si2RHS = sparse(BIG_II_Si_rhs, BIG_JJ_Si_rhs, BIG_SS_Si_rhs, exp_fitting*Nn, Nc);
Si2RHS(dirichlet_nodes,:) = 0;

% -------------------------------------------------------------------------
ph_coeff = zeros(1,numel(species));
ph_coeff(1) = 1; % for electrons

for i = 1:size(species_coeff,1)
    species_index = find(species == species_coeff{i,1});
    ph_coeff(species_index) = species_coeff{i,2}; %#ok<FNDSB>
end

photo_reactions = vertcat(string(ph_reactions));
reactions = string(vertcat(reactions(:,1)));
[~,indices_src_reactions_ph] = ismember(photo_reactions,reactions);

% -------------------------------------------------------------------------
CellFromNodesPh = sparse(repmat(1:Nc,1,3),ns_from_c(:),ones(Nc*3,1)*(1/3),Nc,Nn) * repmat(speye(Nn),1,exp_fitting);

end

function [ke] = fem_element(k,X,N,dNdz,Z,w)
ke = zeros(size(X,2));
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    gradN = dNdz(z) / J;
    ke_i = (gradN * gradN' + k^2 * (N(z)*N(z)')) * abs(det(J));
    ke = ke + w(i) * ke_i;
end
end

function [ke] = fem_element_cyl(k,X,N,dNdz,Z,w)
ke = zeros(size(X,2));
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    gradN = dNdz(z) / J;
    x = X * N(z);
    ke_i = (gradN * gradN' + k^2 * (N(z)*N(z)')) * abs(det(J));
    ke = ke + w(i) * ke_i*x(2);
end
end

function [krhs] = fem_rhs(X,N,dNdz,Z,w)
krhs = zeros(size(X,2),1);
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    krhs_i = N(z)*abs(det(J));
    krhs = krhs + w(i) * krhs_i;
end
end

function [krhs] = fem_rhs_cyl(X,N,dNdz,Z,w)
krhs = zeros(size(X,2),1);
for i = 1:numel(w)
    z = Z(i,:);
    J = (X * dNdz(z));
    x = X * N(z);
    krhs_i = N(z)*abs(det(J));
    krhs = krhs + w(i) * krhs_i*x(2);
end
end