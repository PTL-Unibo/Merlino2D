function [out] = Merlino2D(p)
%Merlino2D solves time-dependent drift-diffusion-reaction equations
%   on a 2D unstructured triangular mesh

% p = M2DInput(opts,extra);

% Initialization------------------------------------------------------------------------------------
[odefun,msh,A,B,inv_mapping,I_s,ns,qs,Dirichlet_nodes_indices,non_Dirichlet_nodes_indices,species,Phi2Ex_c,Phi2Ey_c,reactions,...
    odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo] = M2DInit(p);

% Run-----------------------------------------------------------------------------------------------
[tout,yout,wall_clock_time,statsout,Sph_nodes] = M2DRun(p,odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo);

% Creating Output Structure ------------------------------------------------------------------------
out.p = p;
out.tout = tout;
out.yout = yout;
out.wall_clock_time = wall_clock_time;
out.statsout = statsout;
out.Sph = Sph_nodes;

out.odefun = odefun;
out.msh = msh;
out.A = A;
out.B = B;
out.inv_mapping = inv_mapping;
out.I_s = I_s(tout);
out.ns = ns;
out.qs = qs;
out.Dirichlet_nodes_indices = Dirichlet_nodes_indices;
out.non_Dirichlet_nodes_indices = non_Dirichlet_nodes_indices;
out.s_names = species;
out.Phi2Ex_c = Phi2Ex_c(1:msh.Nc,:);
out.Phi2Ey_c = Phi2Ey_c(1:msh.Nc,:);
out.reactions = string(vertcat(reactions(:,1)));

end
