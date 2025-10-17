opts.MSH = "WireCyl_50u_5m_30m";
opts.BCEL_FLAG = [0; 0; 1; 1; 1; 1];
opts.BCEL_VAL = [1; 0; 0; 0; 0; 0];
[tx,vx,time_instants] = StairRamp(1e-3,1e-4,(7:2:21)*1e3);
opts.V_APPLIED = @(t) interp1(tx,vx,t);
opts.BC_FLAG = ["GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux";
                "GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"];
opts.BC_VAL = @(t) [NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, 0, 0, 0, 0;
                    NaN, NaN, 0, 0, 0, 0];
opts.TIME_INSTANTS = [0, time_instants];
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

out = Merlino2D(opts,"ODE_TYPE","idas");
out_pp = PostProcessing(out);
Save(out_pp,"CoronaWireCyl_50u_5m_30m.mat")

%%
out_pp = Load("CoronaWireCyl_50u_5m_30m.mat");

VIexp = load(GetPath("data")+"/Experimental_Results_50u_5m_30m.csv");
Vexperiment = VIexp(:,1)*1e3; % from kilovolt to volt 
Iexperiment = VIexp(:,2)/1e3; % from mA to Ampere

ax = Plot(out_pp,"type","v-i","flip_y",1);
hold on
plot(ax,Vexperiment,Iexperiment,".","MarkerSize",10)
