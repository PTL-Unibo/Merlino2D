MSH = 'PointPlaneExp';
BCEL_FLAG = [0; 0; 1; 1; 1];
BCEL_VAL = [1; 0; 0; 0; 0];
V_APPLIED = @(t) TanhRamp(t,4e3,10e3,2);
DV_APPLIED = @(t) DTanhRamp(t,4e3,10e3,2);
R = 0;
ANODE_IDS = 1;
BC_FLAG = {
    "N2+", {'GorinLike', "GorinLike", 'Flux', 'Flux', 'Flux'};
    "e",   {'GorinLike', "GorinLike", 'Flux', 'Flux', 'Flux'};
    "O2+", {'GorinLike', "GorinLike", 'Flux', 'Flux', 'Flux'};
    "O2-", {'GorinLike', "GorinLike", 'Flux', 'Flux', 'Flux'}};
BC_VAL = {
    'e',   {NaN, NaN, 0, 0, 0};
    'O2+', {NaN, NaN, 0, 0, 0};
    'O2-', {NaN, NaN, 0, 0, 0};
    'N2+', {NaN, NaN, 0, 0, 0}};
TIME_INSTANTS = [0, 2];
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
CONST_OMEGA = {
    "N2+", 0.8e15;
    "O2+", 0.2e15;
    "e", 1e15;
    "O2-", 1e5};
CHEMICAL_MODEL = 's_Parent';
CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel"};
LOKI_INPUT = "Air";
ELECTRON_TEMPERATURE = 'LoKI';
GAMMA_II = 1e-2;
COORDINATES = "cylindrical";
SAVE_EACH_K_TIMESTEPS = 5;
