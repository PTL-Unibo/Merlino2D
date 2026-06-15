MSH = "GlowCOMSOL";
EPSR_VAL = 1;
BCEL_FLAG = [0; 0; 1];
BCEL_VAL = [1; 0; 0];
ANODE_IDS = 1;
R = 1e3;
BC_FLAG = {
    'e',   {"GorinLike", "GorinLike", 'Flux'};
    "Ars", {"GorinLike", "GorinLike", "Flux"};
    "Arp", {"GorinLike", "GorinLike", "Flux"}};
BC_VAL = {
    "e",   {NaN, NaN, 0};
    'Ars', {NaN, NaN, 0};
    'Arp', {NaN, NaN, 0}};
% BC_FLAG = {
%     'e',   {"Flux", "Flux", 'Flux'};
%     "Ars", {"Flux", "Flux", "Flux"};
%     "Arp", {"Flux", "Flux", "Flux"}};
% BC_VAL = {
%     "e",   {0, 0, 0};
%     'Ars', {0, 0, 0};
%     'Arp', {0, 0, 0}};
MU = {
    "e",   "1e25/Ngas";
    'Ars', 0;
    'Arp', 0.25};
D = {
    "e",   "<<mue>>*Te";
    'Ars', 0.01;
    'Arp', "<<muArp>>*T/11600"};
V_TH_COEFF = {
    "e",   0;
    'Ars', 0;
    'Arp', 1};
CONST_OMEGA = {
    "e",   1e10;
    'Ars', 0;
    'Arp', -1e10};
CHEMICAL_MODEL = 's_Argon';
CONST_SPECIES = {"Ar", 1, "rel"};
ELECTRON_TEMPERATURE = "Te_Ar";
V_APPLIED = @(t) 125;
GAMMA_II = 0.25;
TIME_INSTANTS = [1e-12, 1e-2];
INITIAL_CONDITION = {
    "e",   1e10;
    'Ars', 1e10;
    'Arp', 1e10};
ODE_TYPE = "ode15s";
OUTPUT_FUNCTION = "bar";
BAR_SCALE = "log";
COORDINATES = "cylindrical";
PRESSURE = 67;
ELECTRON_REF_COEFF = 0.3;