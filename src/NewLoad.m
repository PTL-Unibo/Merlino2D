function [out] = NewLoad()

origianl_path = GetPath("src");

rmpath(genpath(origianl_path))

folder_name = uigetdir("",'Select the folder');

sep_folder_name = split(folder_name,filesep);

out = load(folder_name+"/"+sep_folder_name(end)+".mat");

out.p.V_APPLIED = str2func(out.p.V_APPLIED);

addpath(genpath(folder_name+"/src"))

out.p.OPEN_GMSH = 0; % not opening gmsh
[odefun,msh,A,B,inv_mapping,I_s,ns,qs,...
    Dirichlet_nodes_indices,non_Dirichlet_nodes_indices,species,Phi2Ex_c,Phi2Ey_c] = M2DInit(out.p);

if isfolder(GetPath("data")+"/"+"func")
    rmpath(GetPath("data")+"/"+"func")
end

rmpath(genpath(folder_name+"/src"))

addpath(genpath(origianl_path))

out.odefun = odefun;
out.msh = msh;
out.A = A;
out.B = B;
out.inv_mapping = inv_mapping;
out.I_s = I_s(out.tout);
out.ns = ns;
out.qs = qs;
out.Dirichlet_nodes_indices = Dirichlet_nodes_indices;
out.non_Dirichlet_nodes_indices = non_Dirichlet_nodes_indices;
out.s_names = species;
out.Phi2Ex_c = Phi2Ex_c(1:msh.Nc,:);
out.Phi2Ey_c = Phi2Ey_c(1:msh.Nc,:);

end
