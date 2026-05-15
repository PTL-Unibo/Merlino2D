function [tout,yout,wall_clock_time,statsout,Sph_nodes] = M2DRun(p,odefun_mixed,y0,ode_options,inv_ppp,sporadic_save_is_on,ph_is_on,input_photo)
global tout_sparse yout_sparse %#ok<GVMIS>
global BentoCaraca %#ok<GVMIS>

statsout = [-1,-1,-1,-1,-1,-1];
% Solving with DAE --------------------------------------------------------
clear DaeFunc2D % clear persistent variables (Sph)
if p.ODE_TYPE == "idas"
    F = ode;
    F.InitialValue = y0;
    F.ODEFcn = odefun_mixed;
    F.MassMatrix = odeMassMatrix(MassMatrix=ode_options.Mass,Singular="yes");
    F.Jacobian = odeJacobian(SparsityPattern=ode_options.JPattern); 
    F.Solver = "idas";
    F.AbsoluteTolerance = p.ABS_TOL;
    F.RelativeTolerance = p.REL_TOL;
    if ~isempty(p.MAX_STEP)
        F.SolverOptions.MaxStep = p.MAX_STEP;
    end
    if ~isempty(p.INITIAL_STEP)
        F.SolverOptions.InitialStep = p.INITIAL_STEP;
    end
    start_time_computation = tic();
    if numel(p.TIME_INSTANTS) > 2
        S = solve(F,p.TIME_INSTANTS);
    else
        S = solve(F,p.TIME_INSTANTS(1),p.TIME_INSTANTS(2));
    end
    wall_clock_time = toc(start_time_computation);
    tout = S.Time;
    yout = S.Solution;
elseif p.ODE_TYPE == "ode15s"
    ode_options.AbsTol = p.ABS_TOL;
    ode_options.RelTol = p.REL_TOL;
    if ~isempty(p.MAX_STEP)
        ode_options.MaxStep = p.MAX_STEP;
    end
    if ~isempty(p.INITIAL_STEP)
        ode_options.InitialStep = p.INITIAL_STEP;
    end
    start_time_computation = tic();
    if sporadic_save_is_on
        ode15s(odefun_mixed,[p.TIME_INSTANTS(1),p.TIME_INSTANTS(end)],y0,ode_options);
        tout = tout_sparse;
        yout = yout_sparse;
    else
        [tout,yout,statsout] = ode15s(odefun_mixed,p.TIME_INSTANTS,y0,ode_options);
    end
    wall_clock_time = toc(start_time_computation);
    tout = tout';
    yout = yout';
end

if ph_is_on
    Sph_nodes = UpdatePhoto(yout(:,end),tout(end),input_photo);
else
    Sph_nodes = 0;
end

yout = yout(inv_ppp,:);

fprintf("%s\n","Simulation finished");

if isfolder(GetPath("data")+"/"+"func")
    rmpath(GetPath("data")+"/"+"func")
end

if BentoCaraca
    % do nothing
else
    % removing the .m mesh file
    mat_mesh_file = GetPath("geo") + "/" + p.MSH + ".m";
    if isfile(mat_mesh_file)
        delete(mat_mesh_file)
        fprintf("%s\n","Deleted " + p.MSH + ".m");
    end
end

end

