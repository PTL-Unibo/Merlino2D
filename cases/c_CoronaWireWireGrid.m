opts.MSH = "WireWireGrid";
opts.MSH_PARAMETERS.k = 1;
opts.BCEL_FLAG = [0; 0; 0; 0; 0; 1; 1; 1; 1];
opts.BCEL_VAL = [1; 0; 0; 0; 0; 0; 0; 0; 0];
opts.V_APPLIED = @(t) LinRamp(t,1e-4,7e3,20e3);
opts.BC_FLAG = ["GorinLike", "GorinLike", "GorinLike", "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "GorinLike", "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "GorinLike", "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "GorinLike", "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"];
opts.BC_VAL = @(t) [NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0];
opts.TIME_INSTANTS = logspace(-12,-3,100);
opts.INITIAL_CONDITION = [0.001e13, 0.8e13, 0.2e13, 0.999e13];
opts.S_NAMES = ["e","N2+","O2+","O2-"];
opts.NS = 4;
opts.QS = [-1,+1,+1,-1];
opts.MASS = [me, 0.028/Na-me, 0.032/Na-me, 0.032/Na+me];
opts.MU = {
    "(1/Ngas) * 3.74e19 * exp(33.5 * (log(Te*11600))^(-0.5))";         
    "(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    "(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    "(1/Ngas) * min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1))"
    };
opts.D = {
    "mu1*Te";
    "mu2*T/11600";
    "mu3*T/11600";
    "mu4*T/11600";
    };
opts.V_TH_COEFF = [1, 1, 1, 1];
opts.CONST_OMEGA = [1e15,0.5e15,0.5e15,1e5];
opts.CHEMICAL_MODEL = "s_ParentConst";
opts.ELECTRON_TEMPERATURE = "Te_Air";
opts.GAMMA_II = 1e-2;

out = Merlino2D(opts,"OUTPUT_FUNCTION","bar","BAR_SCALE","log");
out_pp = PostProcessing(out,"full");
Save(out_pp,"CoronaWireWireGrid.mat")

%%
out_pp = Load("CoronaWireWireGrid.mat");
Plot(out_pp,"type","nn","species_index",1,"flip_y",1);
Plot(out_pp,"type","rhon_log","flip_y",1,"log10_zero_val",-4);
