opts.MSH = 'WireWireGrid';
opts.MSH_PARAMETERS.k = 1;
opts.BCEL_FLAG = [0; 0; 0; 0; 0; 1; 1; 1; 1];
opts.BCEL_VAL = [1; 0; 0; 0; 0; 0; 0; 0; 0];
opts.V_APPLIED = @(t) LinRamp(t,1e-4,7e3,20e3);
opts.BC_FLAG = {
    "N2+", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "e",   {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "O2+", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "O2-", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'}};
opts.BC_VAL = {
    'e',   {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'O2+', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'O2-', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'N2+', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0}};
opts.TIME_INSTANTS = logspace(-12,-3,100);
opts.INITIAL_CONDITION = {
    'N2+',0.8e13;
    'O2-',0.999e13;
    "O2+",0.2e13;
    'e',  0.001e13;};
opts.MU = {
    'e',   'Loki_mu(E)/Ngas';
    "N2+", "(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    'O2+', "(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    'O2-', "(1/Ngas) * min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1))"};
opts.D = {
    "O2+", '(muO2+)*T/11600';
    "e",   "Loki_D(E)/Ngas";
    "N2+", '(muN2+)*T/11600';
    "O2-", "(muO2-)*T/11600"};
opts.V_TH_COEFF = {
    "N2+", 1;
    "e",   1;
    "O2+", 1;
    "O2-", 1};
opts.CONST_OMEGA = {
    "e",   1e15;
    'N2+', 0.5e15;
    "O2+", 0.5e15;
    "O2-", 1e5};
opts.CHEMICAL_MODEL = 's_Parent';
opts.CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel"};
opts.LOKI_INPUT = "Air";
opts.ELECTRON_TEMPERATURE = 'LoKI';
opts.GAMMA_II = 1e-2;

out = Merlino2D(opts,"OUTPUT_FUNCTION",'bar',"BAR_SCALE","log");
out_pp = PostProcessing(out,'full');
Save(out_pp,"CoronaWireWireGrid.mat")

%%
out_pp = Load('CoronaWireWireGrid.mat');
Plot(out_pp,"type","nn","species_index",1,"flip_y",1);
Plot(out_pp,"type","rhon_log","flip_y",1,"log10_zero_val",-4);
