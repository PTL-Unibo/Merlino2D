opts.MSH = "DBD";
opts.MSH_PARAMETERS.k = 1;
opts.EPSR_VAL = [1; 3.2];
opts.BCEL_FLAG = [0; 0; 0; 1; 1; 1; 1];
opts.BCEL_VAL = [1; 1; 0; 0; 0; 0; 0];
opts.V_APPLIED = @(t) 15e3*sin(2*pi*100e3*t);
opts.BC_FLAG = ["FreeDriftFlow", "GorinLike", "Flux", "Flux", "Flux";
                "GorinLike",     "GorinLike", "Flux", "Flux", "Flux";
                "GorinLike",     "GorinLike", "Flux", "Flux", "Flux"];
opts.BC_VAL = @(t) [NaN, NaN, 0, 0, 0;
                    NaN, NaN, 0, 0, 0;
                    NaN, NaN, 0, 0, 0];
opts.TIME_INSTANTS = linspace(0,0.25/100e3,2501);
opts.INITIAL_CONDITION = [0.001e13, 1e13, 0.999e13];
opts.INPUT_SPECIES_ORDER = ['e','I+','I-'];
opts.MU = {
    "mu_Air(E)/Ngas";
    "(1/Ngas) * (min(0.84e23 * (T)^(-0.5), 2.35e12 * (E/1e21)^(-0.5)))";
    "(1/Ngas) * (min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1)))"};
opts.D = {
    "D_Air(E)/Ngas";
    "mu2*T/11600";
    "mu3*T/11600"};
opts.V_TH_COEFF = [0,1,1];
opts.CONST_OMEGA = [1e15, 1e15, 1e5];
opts.CHEMICAL_MODEL = "s_LokiTownsend";
opts.LOKI_INPUT = "Air_saved.mat";
opts.SAVE_LOKI = "Air_saved";
opts.ELECTRON_TEMPERATURE = "Te_Air";
opts.GAMMA_II = 5e-2;
opts.SURF_CHARGE_COEFF = [0.1, 0.1, 0.1];
opts.GAMMA_II_DIEL = 1e-2;

out = Merlino2D(opts,"ODE_TYPE","idas");
out_pp = PostProcessing(out);
% Save(out_pp,"DBD.mat")

%%
% out_pp = Load("DBD.mat");
Plot(out_pp,"type","t-iv");
% ExportVTU(out_pp,"DBD")
