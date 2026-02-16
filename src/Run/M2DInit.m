function [odefun,msh,A,B,inv_mapping,I_s,ns,qs,Dirichlet_nodes_indices,non_Dirichlet_nodes_indices,species,Phi2Ex_c,Phi2Ey_c,...
    odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo] = M2DInit(p)

global BentoCaraca %#ok<GVMIS>

p.SPECIES_NO_CHEM = strtrim(string(p.SPECIES_NO_CHEM(:))); % convert to column string array

% Generating Mesh ---------------------------------------------------------
geo_file = GetPath("geo") + "/" + p.MSH + ".geo";
cmd_arguments = CreateCmdMshParameters(p.MSH_PARAMETERS);
if BentoCaraca
   fprintf("%s\n",GetPath("gmsh") + " " + geo_file + cmd_arguments + " -parse_and_exit");
else
    if p.OPEN_GMSH == 1
        system(GetPath("gmsh") + " " + geo_file + cmd_arguments);
    elseif p.OPEN_GMSH == 0
        [~,~] = system(GetPath("gmsh") + " " + geo_file + cmd_arguments + " -parse_and_exit");
    end
    fprintf("%s\n","Generated Mesh");
end
msh = PreProcessing(GetPath("geo") + "/" + p.MSH, "cartesian", "remove_dielectric","yes");
% geo_file_content = readlines(geo_file);

% Compute Ngas ------------------------------------------------------------
Ngas = p.PRESSURE/(p.TEMPERATURE*kB); % p V = m * R * T

% Setting Chemical Model --------------------------------------------------
if upper(p.CHEMICAL_MODEL) == "OFF"
    M = zeros(2,msh.Nc);
    Mindices = [];
    Nindices = [];
    reactions = {"","-1"};
    species = string(p.SPECIES_NO_CHEM(:));
    ns = numel(species);
    stoichiometric_matrix = zeros(1,ns);
else
    const_species = GetConstSpecies(p.CONST_SPECIES, Ngas);
    run(GetPath("kin")+"/"+p.CHEMICAL_MODEL+".m")
    [species,reactants,products,indices_const_species] = GetReactantsProducts(string(vertcat(reactions(:,1))), string(vertcat(const_species(:,1)))); %#ok<NODEF>
    ns = numel(species);
    [M, Mindices, Nindices, stoichiometric_matrix] = MatrixChemistry(reactants, products, indices_const_species, vertcat(const_species{:,2}), msh.Nc); 
end

% Ordering input parameters to match the order of "species" ---------------
Ordered_bc_flag = OrderVariable(p.BC_FLAG,species,ns,"BC_FLAG",2);
temp_ordered_bc_val = OrderVariable(p.BC_VAL,species,ns,"BC_VAL",0);
Ordered_bc_val = eval(GetBCvalFuncStr(temp_ordered_bc_val));
Ordered_v_th_coeff = OrderVariable(p.V_TH_COEFF,species,ns,"V_TH_COEFF",0)';
if isempty(p.CONST_OMEGA)
    Ordered_const_omega = 0;
else
    Ordered_const_omega = OrderVariable(p.CONST_OMEGA,species,ns,"CONST_OMEGA",0)';
end
Ordered_mu = OrderVariable(p.MU,species,ns,"MU",1);
Ordered_d = OrderVariable(p.D,species,ns,"D",1);

% Getting species info ----------------------------------------------------
species_info_table = readtable(GetPath("data")+"/species_database.csv");
[~,indices_table] = ismember(species,table2array(species_info_table(:,1)));
ms = table2array(species_info_table(indices_table,2))';
qs = table2array(species_info_table(indices_table,3))';

Loki = GetLoki(p.LOKI_INPUT,reactions);

% Setting Electron Temperature --------------------------------------------
% ELECTRON_TEMPERATURE can be se to
% a look up table
% a uniform and costant value (in eV)
if isstring(p.ELECTRON_TEMPERATURE) | ischar(p.ELECTRON_TEMPERATURE)
    if upper(p.ELECTRON_TEMPERATURE) == "LOKI"
        if isempty(Loki)
            error("You need to provide a LOKI_INPUT if you set ELECTRON_TEMPERATURE to LoKI")
        end
        fTe = griddedInterpolant(Loki.E,2/3*Loki.swarmParam.meanEnergy,'pchip','nearest');
    else
        LUT_Te = load(GetPath("data")+"/"+p.ELECTRON_TEMPERATURE+".csv");
        fTe = griddedInterpolant(LUT_Te(:,1),LUT_Te(:,2),"pchip","nearest");
    end
else
    fTe = @(E_Td) ones(size(E_Td)) * p.ELECTRON_TEMPERATURE;
end

[fMu,fD,fKr] = GetFcomputeMuDKr(Ordered_mu,Ordered_d,reactions(:,2),msh.Nc,msh.Nf,Loki,species);

BCval2Bfval = sparse(1:msh.Nb, msh.bID_from_b, ones(1,msh.Nb), msh.Nb, msh.dim_bID);
fBfval = @(t) reshape(BCval2Bfval * Ordered_bc_val(t)',[],1);

full_msh = PreProcessing(GetPath("geo") + "/" + p.MSH, "cartesian", "remove_dielectric","no");
[Kelet, rho2RHS, M_get_aux_BC_el, aux2RHS, ...
 phi2Ex, phi2Ey, aux2Ex, aux2Ey, phi2En, ~, ...
 inv_mapping, Dirichlet_nodes_indices, non_Dirichlet_nodes_indices] = EletStatFEM(msh, full_msh, p.BCEL_FLAG, p.EPSR_VAL, "cartesian");

Kelet_d = decomposition(Kelet);

dNdz = [1,0;0,1;-1,-1]; % 2D triangles 1st order shape functions
[Phi2Ex_c, Phi2Ey_c] = CreateEMatricesFEM(full_msh.ns_from_c, full_msh.xn, full_msh.yn, full_msh.Nc, full_msh.Nn, dNdz);

weights = 1./sqrt((msh.xf(msh.fs_from_c) - msh.xc).^2 + (msh.yf(msh.fs_from_c) - msh.yc).^2);
normalized_weights = weights ./ sum(weights,2);
Eint2Ec = sparse(repmat(1:msh.Nc,1,3), msh.fs_from_c(:), normalized_weights(:), msh.Nc, msh.Nf);

[I_s, Ex_1, Ey_1, g2Is] = ComputeStaticSato(p.TIME_INSTANTS(1), p.TIME_INSTANTS(end), p.BCEL_VAL, p.V_APPLIED, p.EPSR_VAL,...
    M_get_aux_BC_el, Kelet_d, aux2RHS,...
    Dirichlet_nodes_indices, non_Dirichlet_nodes_indices, Phi2Ex_c, Phi2Ey_c,...
    phi2Ex, phi2Ey, aux2Ex, aux2Ey, full_msh.cID_from_c, full_msh.vol, eps0, e, Eint2Ec, msh.vol);

Flux2N = CreateMultiFlux2N(msh, ns);

[i_upwind,i_n_left,i_n_right] = CreateMultiUpwind(msh,ns);

indices = CreateIndicesBCspecies(msh, Ordered_bc_flag', ns);

[A,B] = CreateMultiInterpToNodes(msh, indices, ns);

nx_matrix = spdiags(repmat(msh.sn(:,1),ns), 0, ns*msh.Nf, ns*msh.Nf);
ny_matrix = spdiags(repmat(msh.sn(:,2),ns), 0, ns*msh.Nf, ns*msh.Nf);

[Gx, Gy] = CreateGradNoTang(msh, ns);

[Xmu] = CreateMultiXmu(msh, indices, ns); % for drift in Dirichlet BC
[XF] = CreateMultiXF(msh, indices, ns); % for flux BC

XFx = nx_matrix * XF;
XFy = ny_matrix * XF;

[multi_indices_diel_interfaces, multi_indices_diel_cells, sum_diel_interfaces_fluxes_matrix, surf_charge_accum_flux_coeff] ...
    = BuildUpSurfaceCharge(msh, p.SURF_CHARGE_COEFF, ns, qs, e, p.GAMMA_II_DIEL);

% Other BC ----------------------------------------------------------------
v_th_single = sqrt(8*kB*p.TEMPERATURE./(pi*ms)); % single row, with as many elements as species
v_th_single(1) = v_th_single(1) * sqrt(11600/p.TEMPERATURE);
v_th_single = v_th_single .* Ordered_v_th_coeff;

[GetBfaces, GetBcells] = CreateGetBfacesBcells(msh);

[indices_faces_Gorin, indices_cells_Gorin,...
    indices_faces_Gorin_electrons, indices_faces_Gorin_positive_ions,...
    v_th_x, v_th_y] = GorinBC(GetBfaces, GetBcells, Ordered_bc_flag', qs, v_th_single, msh.sn);

[indices_faces_Absorbent, indices_cells_Absorbent] = AbsorbentBC(GetBfaces, GetBcells, Ordered_bc_flag');

% Setting Initial Condition -----------------------------------------------
% InitialCondition can be a string, a struct or an array
if isstring(p.INITIAL_CONDITION)
    % string - loading previous result
    load(p.INITIAL_CONDITION,"y_end","Nc","Nd");
    if Nc ~= msh.Nc
        % different mesh, interpolation needed
        load(p.INITIAL_CONDITION,"x_cells","y_cells");
        N0 = InterpInitialCondition(x_cells,y_cells,...
            y_end(1:ns*Nc),msh.xc,msh.yc,ns,msh.Nc);
        sigma0 = zeros(0,1);
        if Nd ~= msh.Nd
            load(p.INITIAL_CONDITION,"input");
            old_msh = GetMesh(input.geo_file_content, "cartesian", input.p.MSH_PARAMETERS);
            sigma0 = InterpInitialConditionSigma(old_msh.xf(old_msh.f_from_d),old_msh.yf(old_msh.f_from_d),y_end(ns*Nc+1:ns*Nc+Nd),msh.xf(msh.f_from_d),msh.yf(msh.f_from_d),msh.Nd);
        end
        fprintf("%s\n","Interpolated to new mesh");
    else
        N0 = y_end(1:ns*msh.Nc);
        sigma0 = y_end(ns*msh.Nc+1:ns*msh.Nc+msh.Nd);
    end
    fprintf("%s\n","Loaded from previous save: "+p.INITIAL_CONDITION);
elseif isstruct(p.INITIAL_CONDITION)
    if upper(p.CHEMICAL_MODEL) == "OFF"
        % struct - generating a Gaussian
        N0 = p.INITIAL_CONDITION.A .* exp(-(...
            ((msh.xc - p.INITIAL_CONDITION.x0).^2)/(p.INITIAL_CONDITION.sigma_x)^2 + ((msh.yc - p.INITIAL_CONDITION.y0).^2)/(p.INITIAL_CONDITION.sigma_y)^2 ...
            )) + p.INITIAL_CONDITION.B;
        sigma0 = zeros(msh.Nd,1);
    else
        error("INITIAL_CONDITION can not be a structure if CHEMICAL_MODEL is not set to ""Off""")
    end
else
    % array - setting uniform number density
    Ordered_initial_condition = OrderVariable(p.INITIAL_CONDITION,species,ns,"INITIAL_CONDITION",0)';
    N0 = ones(msh.Nc,ns) .* Ordered_initial_condition;
    sigma0 = zeros(msh.Nd,1);
end

% Compute consistent initial condition ------------------------------------
n_matrix = reshape(N0,[],ns);
rho0 = e * sum(n_matrix.*qs, 2);
rho_sigma_eps = [rho0; sigma0] / eps0;
aux_BC_el = M_get_aux_BC_el * p.BCEL_VAL * p.V_APPLIED(p.TIME_INSTANTS(1));
phi0 = Kelet_d \ (rho2RHS * rho_sigma_eps + aux2RHS * aux_BC_el);
y0 = [N0(:); sigma0; phi0]; % initial condition

% Create Jacobian sparsity pattern ----------------------------------------
JPattern = CreateJpattern(msh, qs, Kelet, Flux2N, phi2En, rho2RHS);
[i,j,s] = find(JPattern);
JPattern = sparse(i,j,ones(size(s)),size(JPattern,1),size(JPattern,2)); % replace each number with a 1
dim_Jac = size(JPattern,1);

% Setting Mass Matrix -----------------------------------------------------
Nphi = size(non_Dirichlet_nodes_indices,1);
ode_dim = ns*msh.Nc+msh.Nd;
dae_dim = Nphi;
ode_options = odeset();
ode_options.MassSingular = "yes";
ode_options.Mass = sparse(1:ode_dim, 1:ode_dim, ones(1,ode_dim), ode_dim+dae_dim, ode_dim+dae_dim);

% Reordering --------------------------------------------------------------
if p.REORDERING == 1
    % create permutation to make Jacobian close to diagonal
    ppp = symrcm(JPattern)';
    inv_ppp = InversePermutation(ppp);
elseif p.REORDERING == 0
    ppp = (1:dim_Jac)';
    inv_ppp = (1:dim_Jac)';
end
ode_options.JPattern = JPattern(ppp,ppp);
ode_options.Mass = ode_options.Mass(ppp,ppp);
y0 = y0(ppp);

% Photoionization --------------------------------------------------------
ph_is_on = (upper(p.CHEMICAL_MODEL)~="OFF") & (~isempty(fieldnames(p.PHOTOIONIZATION)));
offon = ["OFF", "ON"]; fprintf("Photoionization is %s\n",offon(ph_is_on+1)) % give feedback about photoionization
if ph_is_on
    [Ks,Si2RHS,ph_coeff,indices_src_reactions_ph,CellFromNodesPh] = ...
        CreatePh(3,p.PRESSURE,"cartesian",msh.Nc,msh.Nn,msh.xn,msh.yn,msh.ns_from_c,msh.ns_from_b,msh.bs_from_bID,...
        p.PHOTOIONIZATION.BC,p.PHOTOIONIZATION.SPECIES_COEFF,p.PHOTOIONIZATION.REACTIONS,species,reactions);
    photo_update_frequency = p.PHOTOIONIZATION.UPDATE_FREQUENCY;
    input_photo.inv_ppp = inv_ppp;      
    input_photo.Nc = msh.Nc;
    input_photo.Nn = msh.Nn;
    input_photo.ns = ns;
    input_photo.Nd = msh.Nd;
    input_photo.M_get_aux_BC_el = M_get_aux_BC_el;
    input_photo.BCEL_VAL = p.BCEL_VAL;
    input_photo.V_APPLIED = p.V_APPLIED;
    input_photo.Eint2Ec = Eint2Ec;
    input_photo.phi2Ex = phi2Ex;
    input_photo.aux2Ex = aux2Ex;
    input_photo.phi2Ey = phi2Ey;
    input_photo.aux2Ey = aux2Ey;
    input_photo.Ngas = Ngas;
    input_photo.fTe = fTe;       
    input_photo.fKr = fKr;
    input_photo.T = p.TEMPERATURE;
    input_photo.M = M;
    input_photo.Mindices = Mindices;
    input_photo.Nindices = Nindices;
    input_photo.indices_src_reactions_ph = indices_src_reactions_ph;
    input_photo.CellFromNodesPh = CellFromNodesPh;
    input_photo.Ks = Ks;
    input_photo.Si2RHS = Si2RHS;
else
    ph_coeff = 0;
    photo_update_frequency = -1;
    input_photo = -1;
end
InitializePhoto(y0,p.TIME_INSTANTS(1),input_photo,ph_is_on);

% Creating Ode Function ---------------------------------------------------
odefun_perm = @(t,y,perm,inv_perm) DaeFunc2D(t,y,msh.Nf,msh.Nc,msh.Nd, ...
    multi_indices_diel_interfaces,multi_indices_diel_cells,sum_diel_interfaces_fluxes_matrix, ...
    Kelet,rho2RHS,aux2RHS,Flux2N,M_get_aux_BC_el,fBfval,i_upwind,i_n_left,i_n_right,Xmu,XFx,XFy,...
    phi2Ex,phi2Ey,aux2Ex,aux2Ey,Eint2Ec,Ngas,p.TEMPERATURE,qs,p.BCEL_VAL,p.V_APPLIED,...
    fTe,fMu,fD,fKr,M,Mindices,Nindices,stoichiometric_matrix,Ordered_const_omega,ns,...
    indices_faces_Absorbent,indices_cells_Absorbent,...
    indices_faces_Gorin,indices_cells_Gorin,v_th_x,v_th_y,indices_faces_Gorin_electrons,indices_faces_Gorin_positive_ions,p.GAMMA_II,...
    surf_charge_accum_flux_coeff, perm, inv_perm,...
    Gx, Gy, nx_matrix, ny_matrix,...
    Ex_1, Ey_1, g2Is, p.ELECTRON_REF_COEFF, zeros(msh.Nf*ns,1), zeros(msh.Nf*ns,1), ph_coeff);
odefun_mixed = @(t,y) odefun_perm(t,y,ppp,inv_ppp); % this is the one considering reordering
odefun = @(t,y) odefun_perm(t,y,(1:dim_Jac)',(1:dim_Jac)'); % this is the one using "normal" ordering, to give as output

% Setting Output Function -------------------------------------------------
if p.OUTPUT_FUNCTION == "none"
    % no output function
else
    clear GeneralOutputFunction
    sporadic_save_is_on = p.SAVE_EACH_K_TIMESTEPS < Inf;
    ode_options.OutputFcn = @(t,y,flag)GeneralOutputFunction(t,y,flag,...
        p.OUTPUT_FUNCTION,p.BAR_SCALE,...
        ph_is_on,photo_update_frequency,input_photo,...
        sporadic_save_is_on,p.SAVE_EACH_K_TIMESTEPS);
end

fprintf("%s\n","Initialization finished");

end

