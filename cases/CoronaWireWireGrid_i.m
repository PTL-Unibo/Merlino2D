MSH = 'WireWireGrid';
MSH_PARAMETERS.k = 1;
BCEL_FLAG = [0; 0; 0; 0; 0; 1; 1; 1; 1];
BCEL_VAL = [1; 0; 0; 0; 0; 0; 0; 0; 0];
V_APPLIED = @(t) LinRamp(t,1e-4,7e3,20e3);
ANODE_IDS = 1;
R = 1e3;
LENGTH = 0.2;
BC_FLAG = {
    "N2+", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "e",   {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "O2+", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'};
    "O2-", {'GorinLike', "GorinLike", 'GorinLike', 'GorinLike', 'GorinLike', 'Flux', 'Flux', 'Flux', 'Flux'}};
BC_VAL = {
    'e',   {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'O2+', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'O2-', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0};
    'N2+', {NaN, NaN, NaN, NaN, NaN, 0, 0, 0, 0}};
TIME_INSTANTS = [1e-12, 1e-2];
INITIAL_CONDITION = {
    'N2+',0.8e13;
    'O2-',0.999e13;
    "O2+",0.2e13;
    'e',  0.001e13;};
MU = {
    'e',   'Loki_mu(E)/Ngas';
    "N2+", "(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    'O2+', "(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    'O2-', "(1/Ngas) * min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1))"};
D = {
    "O2+", '<<muO2+>>*T/11600';
    "e",   "Loki_D(E)/Ngas";
    "N2+", '<<muN2+>>*T/11600';
    "O2-", "<<muO2->>*T/11600"};
V_TH_COEFF = {
    "N2+", 1;
    "e",   1;
    "O2+", 1;
    "O2-", 1};
% PHOTOIONIZATION.REACTIONS = {
%     'e + N2 -> 2e + N2+';
%     "e + O2 -> 2e + O2+"};
% PHOTOIONIZATION.SPECIES_COEFF = {
%     'N2+',0.8;
%     'O2+',0.2};
% PHOTOIONIZATION.BC = [1, 1, 1, 1, 1, 1, 0, 1, 1];
% PHOTOIONIZATION.UPDATE_FREQUENCY = 5;
CHEMICAL_MODEL = 's_Parent';
CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel"};
LOKI_INPUT = "Air";
ELECTRON_TEMPERATURE = 'LoKI';
GAMMA_II = 1e-2;
% SAVE_EACH_K_TIMESTEPS = 10;

OUTPUT_FUNCTION = "i";
BAR_SCALE = "log";