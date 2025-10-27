function [out_pp] = PostProcessing(out,type)
arguments
    out
    type (1,:) char {mustBeMember(type,{'light','full'})} = 'light' 
end

if type == "full"
    msh = out.msh;
    A = out.A;
    B = out.B;
end
ns = out.ns;
Dirichlet_nodes_indices = out.Dirichlet_nodes_indices;
non_Dirichlet_nodes_indices = out.non_Dirichlet_nodes_indices;
qs = out.qs;
I_s = out.I_s;
inv_mapping = out.inv_mapping;
odefun = out.odefun;
Phi2Ex_c = out.Phi2Ex_c;
Phi2Ey_c = out.Phi2Ey_c;

nt = numel(out.tout);
Nn = out.msh.Nn;
Nc = out.msh.Nc;
Nf = out.msh.Nf;
Nb = out.msh.Nb;
Nd = out.msh.Nd;

if type == "full"
    EX_MATRIX = zeros(Nf,nt);
    EY_MATRIX = zeros(Nf,nt);
    OMEGA_MATRIX = zeros(Nc*ns,nt);
    GAMMA_X_MATRIX = zeros(Nf*ns,nt);
    GAMMA_Y_MATRIX = zeros(Nf*ns,nt);
end
BFVAL_MATRIX = zeros(Nb*ns,nt);
I = zeros(1,nt);
V = zeros(1,nt);

N_CELLS = out.yout(1:ns*Nc,:);
SIGMA = out.yout(ns*Nc+1:ns*Nc+Nd,:);

DIRICHLET_NODES_MATRIX = zeros(size(Dirichlet_nodes_indices,1),nt);
partial_PHI_NODES = out.yout(ns*Nc+Nd+1:end,:);
if type == "full"
    for k = 1:nt
        % [dydt,aux_BC_el,Bfval,Ex,Ey,omega,Gamma_x,Gamma_y,I]
        [~,DIRICHLET_NODES_MATRIX(:,k),BFVAL_MATRIX(:,k),...
         EX_MATRIX(:,k),EY_MATRIX(:,k),...
         OMEGA_MATRIX(:,k),GAMMA_X_MATRIX(:,k),GAMMA_Y_MATRIX(:,k),I(k)] = odefun(out.tout(k), out.yout(:,k));
    end
elseif type == "light"
    for k = 1:nt
        % [dydt,aux_BC_el,Bfval,Ex,Ey,omega,Gamma_x,Gamma_y,I]
        [~,DIRICHLET_NODES_MATRIX(:,k),BFVAL_MATRIX(:,k),~,~,~,~,~,I(k)] = odefun(out.tout(k), out.yout(:,k));
    end
end


% Rho at cells
RHO_CELLS = reshape(e*sum(reshape(N_CELLS,Nc,ns,nt).*qs,2),Nc,nt);

% Electric potential at nodes
PHI_NODES(Dirichlet_nodes_indices,:) = DIRICHLET_NODES_MATRIX;
PHI_NODES(non_Dirichlet_nodes_indices,:) = partial_PHI_NODES;
% now PHI_NODES contains the values of the full mesh
EX_CELLS_MATRIX = Phi2Ex_c * PHI_NODES;
EY_CELLS_MATRIX = Phi2Ey_c * PHI_NODES;
% keep PHI_NODES only at air nodes
PHI_NODES = PHI_NODES(inv_mapping,:);

% geometry
link_cell_to_nodes = out.msh.ns_from_c;
x_faces = out.msh.xf;
y_faces = out.msh.yf;
x_cells = out.msh.xc;
y_cells = out.msh.yc;
x_nodes = out.msh.xn;
y_nodes = out.msh.yn;

% Compute Sato current
I_SATO = I + I_s(1:nt);

% Applied voltage
for i = 1:nt
    V(i) = out.p.V_APPLIED(out.tout(i));
end

S_NAMES = out.s_names;

if type == "full"
    nx_matrix = spdiags(repmat(msh.sn(:,1),ns), 0, ns*Nf, ns*Nf);
    ny_matrix = spdiags(repmat(msh.sn(:,2),ns), 0, ns*Nf, ns*Nf); 
    GAMMA_DOT_N_MATRIX = nx_matrix*GAMMA_X_MATRIX + ny_matrix*GAMMA_Y_MATRIX;
    
    % Number density and rho at nodes
    N_NODES = A*N_CELLS + B*BFVAL_MATRIX; 
    NN_2_RHO_N = e * sparse(repmat(1:Nn,1,ns), 1:Nn*ns, repelem(qs,Nn), Nn, Nn*ns);
    RHO_NODES = NN_2_RHO_N * N_NODES;
    
    % Electric field at nodes
    EX_NODES_MATRIX = msh.Face2Node * EX_MATRIX;
    EY_NODES_MATRIX = msh.Face2Node * EY_MATRIX;
    
    % compute current (ID, time, species)
    J_faces = zeros(Nf,nt,ns);
    I_bID = zeros(msh.dim_bID,nt,ns);
    J_faces_temp = e * reshape(GAMMA_DOT_N_MATRIX, Nf, ns, nt) .* qs;
    for i_s = 1:ns
        J_faces(:,:,i_s) = reshape(J_faces_temp(:,i_s,:), Nf, nt);
    end
    for i = 1:msh.dim_bID
     indices = msh.f_from_b(msh.bs_from_bID{i});
     I_bID(i,:,:) = sum(J_faces(indices,:,:) .* msh.areaf(indices),1);
    end
end

% Creating a struct with solver statistics
stats.wall_clock_time = SecondsToString(out.wall_clock_time);
stats.successful_steps = out.statsout(1);
stats.failed_attempts = out.statsout(2);
stats.function_evaluations = out.statsout(3);
stats.partial_derivatives = out.statsout(4);
stats.LU_decompositions = out.statsout(5);
stats.solutions_of_linear_systems = out.statsout(6);

% Creating output structure
out_pp.tout = out.tout;
out_pp.N_CELLS = N_CELLS;
out_pp.SIGMA = SIGMA;
out_pp.PHI_NODES = PHI_NODES; 
out_pp.EX_CELLS_MATRIX = EX_CELLS_MATRIX;
out_pp.EY_CELLS_MATRIX = EY_CELLS_MATRIX;
out_pp.RHO_CELLS = RHO_CELLS;
out_pp.I_SATO = I_SATO;
out_pp.V = V;
out_pp.link_cell_to_nodes = link_cell_to_nodes;
out_pp.x_cells = x_cells;
out_pp.x_faces = x_faces;
out_pp.x_nodes = x_nodes;
out_pp.y_cells = y_cells;
out_pp.y_faces = y_faces;
out_pp.y_nodes = y_nodes;
out_pp.Nb = Nb;
out_pp.Nc = Nc;
out_pp.Nd = Nd;
out_pp.Nf = Nf;
out_pp.Nn = Nn;
out_pp.ns = ns;
out_pp.nt = nt;
out_pp.qs = qs;
out_pp.S_NAMES = S_NAMES;
out_pp.msh = out.msh;
out_pp.stats = stats;
if type == "full"
    out_pp.EX_MATRIX = EX_MATRIX;
    out_pp.EY_MATRIX = EY_MATRIX;
    out_pp.OMEGA_MATRIX = OMEGA_MATRIX;
    out_pp.GAMMA_X_MATRIX = GAMMA_X_MATRIX;
    out_pp.GAMMA_Y_MATRIX = GAMMA_Y_MATRIX;
    out_pp.N_NODES = N_NODES;
    out_pp.RHO_NODES = RHO_NODES;
    out_pp.EX_NODES_MATRIX = EX_NODES_MATRIX;
    out_pp.EY_NODES_MATRIX = EY_NODES_MATRIX;
    out_pp.I_bID = I_bID;
end

% adding a field to know what was the input
out_pp.input.geo_file_content = out.geo_file_content;
out_pp.input.p = out.p;
% replacing function handles with strings
out_pp.input.p.V_APPLIED = func2str(out.p.V_APPLIED);

% removing the .m mesh file
mat_mesh_file = GetPath("geo") + "/" + out.p.MSH + ".m";
if isfile(mat_mesh_file)
    delete(mat_mesh_file)
    fprintf("%s\n","Deleted " + out.p.MSH + ".m");
end

end
