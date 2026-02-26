function [out] = Merlino2D(input_script,flag)
%Merlino2D solves time-dependent drift-diffusion-reaction equations
%   on a 2D unstructured triangular mesh

arguments
    input_script (1,:) char
    flag (1,:) char {mustBeMember(flag,{'run','init'})}
end

[p,processed_input] = ProcessInput(input_script,flag);
geo_file_content = readlines(GetPath("geo") + "/" + p.MSH + ".geo");

if isa(p.ELECTRIC_FIELD_0D,"function_handle")
    flag = "init";
    fprintf("Running 0D mode\n")
else
    if flag == "run"
        % print input on screen
        fprintf("Running input:\n")
        fprintf("%s\n",processed_input)
        fprintf("\n")
    end
end

% Initialization-----------------------------------------------------------
[odefun,msh,A,B,inv_mapping,I_s,ns,qs,Dirichlet_nodes_indices,non_Dirichlet_nodes_indices,species,Phi2Ex_c,Phi2Ey_c,reactions,...
    stoichiometric_matrix,odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo] = M2DInit(p,flag);

% Creating Output Structure -----------------------------------------------
out.p = p;
out.odefun = odefun;
out.msh = msh;
out.A = A;
out.B = B;
out.inv_mapping = inv_mapping;
out.I_s = I_s;
out.ns = ns;
out.qs = qs;
out.Dirichlet_nodes_indices = Dirichlet_nodes_indices;
out.non_Dirichlet_nodes_indices = non_Dirichlet_nodes_indices;
out.s_names = species;
out.Phi2Ex_c = Phi2Ex_c(1:msh.Nc,:);
out.Phi2Ey_c = Phi2Ey_c(1:msh.Nc,:);
out.reactions = string(vertcat(reactions(:,1)));
out.stoichiometric_matrix = stoichiometric_matrix;
    
% Run----------------------------------------------------------------------
if flag == "run"
    [tout,yout,wall_clock_time,statsout,Sph_nodes] = M2DRun(p,odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo);
    % Creating a struct with solver statistics
    stats.wall_clock_time = SecondsToString(wall_clock_time);
    stats.successful_steps = statsout(1);
    stats.failed_attempts = statsout(2);
    stats.function_evaluations = statsout(3);
    stats.partial_derivatives = statsout(4);
    stats.LU_decompositions = statsout(5);
    stats.solutions_of_linear_systems = statsout(6);
    % Appending to Output Structure
    out.temp_geo_file_content = geo_file_content;
    out.temp_input = processed_input;
    out.tout = tout;
    out.yout = yout;
    out.stats = stats;
    out.Sph = Sph_nodes;
end

if isa(p.ELECTRIC_FIELD_0D,"function_handle")
    % 0D case
    ode15s(odefun_mixed,[p.TIME_INSTANTS(1),p.TIME_INSTANTS(end)],y0)
    legend(species)
    yscale("log")
    grid on
end


end