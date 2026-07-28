MSH = 'PointPlaneParabolic';
BCEL_FLAG = [0; 0; 1; 1; 1];
BCEL_VAL = [-1; 0; 0; 0; 0];
V_APPLIED = @(t) 5.5e3;
DV_APPLIED = @(t) 0;
R = 0;
ANODE_IDS = 1;
BC_FLAG = {
    "I+", {'FreeDriftFlow', "Dirichlet",     'Flux', 'FreeDriftFlow', 'FreeDriftFlow'};
    "e",  {'GorinLike',     "FreeDriftFlow", 'Flux', 'FreeDriftFlow', 'FreeDriftFlow'};
    "I-", {'Dirichlet',     "FreeDriftFlow", 'Flux', 'FreeDriftFlow', 'FreeDriftFlow'}};
BC_VAL = {
    'e',  {NaN, NaN, 0, NaN, NaN};
    'I+', {NaN, 1e8, 0, NaN, NaN};
    'I-', {1e8, NaN, 0, NaN, NaN}};
TIME_INSTANTS = [0, 30e-6];
INITIAL_CONDITION = {
    'I+', 2e8;
    'I-', 1e8;
    "e",  1e8;};
MU = {
    'e',   'mob_el(E*Ngas/1e21)';
    "I+",  'mob_pos(E*Ngas/1e21)';
    'I-',  'mob_neg(E*Ngas/1e21)'};
D = {
    'e',   0.18;
    "I+",  0.01;
    'I-',  0.01};
V_TH_COEFF = {
    'e',   1;
    "I+",  1;
    'I-',  1};
CONST_OMEGA = {
    'e',   0;
    "I+",  0;
    'I-',  1e5};
CHEMICAL_MODEL = 's_TownsendKang';
CONST_SPECIES = {"M", 1, "rel"};
ELECTRON_TEMPERATURE = 'Te_Air';
GAMMA_II = 4e-3;
COORDINATES = "cylindrical";
OUTPUT_FUNCTION = "i";
BAR_SCALE = "lin";
SAVE_EACH_K_TIMESTEPS = 5;
