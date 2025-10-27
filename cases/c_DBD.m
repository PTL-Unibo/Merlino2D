opts.MSH = "DBD";
opts.MSH_PARAMETERS.k = 1;
opts.EPSR_VAL = [1; 3.2];
opts.BCEL_FLAG = [0; 0; 0; 1; 1; 1; 1];
opts.BCEL_VAL = [1; 1; 0; 0; 0; 0; 0];
opts.V_APPLIED = @(t) 15e3*sin(2*pi*100e3*t);
opts.BC_FLAG = {
    'I-',{"GorinLike",     "GorinLike", 'Flux', "Flux", "Flux"};
    'e', {'FreeDriftFlow', 'GorinLike', "Flux", 'Flux', 'Flux'};
    "I+",{"GorinLike",     "GorinLike", "Flux", 'Flux', "Flux"}};
opts.BC_VAL = {
    "I+",{NaN, NaN, 0, 0, 0};
    "e", {NaN, NaN, 0, 0, 0};
    'I-',{NaN, NaN, 0, 0, 0}};
opts.TIME_INSTANTS = linspace(0,0.25/100e3,2501);
opts.INITIAL_CONDITION = {
    "I+",1e13;
    "I-",0.999e13;
    "e", 0.001e13;};
opts.MU = {
    "I+",'(1/Ngas) * (min(0.84e23 * (T)^(-0.5), 2.35e12 * (E/1e21)^(-0.5)))';
    "e", "mu_Air(E)/Ngas";
    'I-',"(1/Ngas) * (min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1)))"};
opts.D = {
    "I+","(muI+)*T/11600";
    "e", 'D_Air(E)/Ngas';
    "I-","(muI-)*T/11600"};
opts.V_TH_COEFF = {
    'e', 0;
    "I+",1;
    'I-',1};
opts.CONST_OMEGA = {
    'I-',1e5
    'e', 1e15;
    "I+",1e15};
opts.CHEMICAL_MODEL = 's_LokiTownsend';
opts.LOKI_INPUT = "Air_saved.mat";
opts.ELECTRON_TEMPERATURE = "Te_Air";
opts.GAMMA_II = 5e-2;
opts.SURF_CHARGE_COEFF = [0.1, 0.1, 0.1];
opts.GAMMA_II_DIEL = 1e-2;

out = Merlino2D(opts,"ODE_TYPE","idas");
out_pp = PostProcessing(out);
Save(out_pp,"DBD.mat")

%%
% out_pp = Load("DBD.mat");
Plot(out_pp,"type","t-iv");
ExportVTU(out_pp,"DBD")
