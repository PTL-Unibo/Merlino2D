clearvars, close, clc

% PARAMETERS
MSH = "SquareLineCenter";
MSH_PARAMETERS = struct;
EPSR_VAL = [1; 3.1];
BCEL_FLAG = [1; 0; 1; 0];
BCEL_VAL = [0; 0; 0; 1];
COORDINATES = "cartesian";
V = 100;

geo_file = MSH + ".geo";
cmd_arguments = CreateCmdMshParameters(MSH_PARAMETERS);
system("gmsh " + geo_file + cmd_arguments);

full_msh = PreProcessing(MSH, COORDINATES, "remove_dielectric","no");

[Kelet, rho2RHS, bc2RHS, Dirichlet_nodes_indices, non_Dirichlet_nodes_indices] = ...
    FullMeshEletStat(full_msh, BCEL_FLAG, EPSR_VAL, COORDINATES);

dNdz = [1,0;0,1;-1,-1]; % 2D triangles 1st order shape functions
[phi2Ex, phi2Ey] = CreateEMatricesFEM(full_msh.ns_from_c, full_msh.xn, full_msh.yn, full_msh.Nc, full_msh.Nn, dNdz);

phi = Kelet \ (rho2RHS * zeros(size(rho2RHS,2),1) + bc2RHS * BCEL_VAL * V);

figure
trisurf(full_msh.ns_from_c,full_msh.xn,full_msh.yn,phi)

figure
quiver(full_msh.xc, full_msh.yc, phi2Ex*phi, phi2Ey*phi)