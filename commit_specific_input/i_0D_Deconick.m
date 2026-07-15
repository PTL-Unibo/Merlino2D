MSH = "GlowCOMSOL";
EPSR_VAL = 1;
BCEL_FLAG = [0; 0; 1];
BCEL_VAL = [1; 0; 0];
ANODE_IDS = 1;
R = 1e3;
BC_FLAG = {
    "e",         {"GorinLike", "GorinLike", 'Flux'};
    "Ar(gnd)",   {'GorinLike', 'GorinLike', "Flux"};
    "Ar(*)",     {"GorinLike", "GorinLike", "Flux"};
    "Ar(+,gnd)", {"GorinLike", "GorinLike", "Flux"};
    "Ar2(+,X)",  {"GorinLike", "GorinLike", "Flux"};
    "Ar2(*)",    {"GorinLike", "GorinLike", "Flux"}};
BC_VAL = {
    "e",         {NaN, NaN, 0};
    "Ar(gnd)",   {NaN, NaN, 0};
    "Ar(*)",     {NaN, NaN, 0};
    "Ar(+,gnd)", {NaN, NaN, 0};
    "Ar2(+,X)",  {NaN, NaN, 0};
    "Ar2(*)",    {NaN, NaN, 0}};
MU = {
    "e",         0;
    "Ar(gnd)",   0;
    "Ar(*)",     0;
    "Ar(+,gnd)", 0;
    "Ar2(+,X)",  0;
    "Ar2(*)",    0};
D = {
    "e",         0;
    "Ar(gnd)",   0;
    "Ar(*)",     0;
    "Ar(+,gnd)", 0;
    "Ar2(+,X)",  0;
    "Ar2(*)",    0};
V_TH_COEFF = {
    "e",         0;
    "Ar(gnd)",   0;
    "Ar(*)",     0;
    "Ar(+,gnd)", 0;
    "Ar2(+,X)",  0;
    "Ar2(*)",    0};
CONST_OMEGA = {
    "e",         0;
    "Ar(gnd)",   0;
    "Ar(*)",     0;
    "Ar(+,gnd)", 0;
    "Ar2(+,X)",  0;
    "Ar2(*)",    0};
CHEMICAL_MODEL = 's_ArgonDeconick';
ELECTRON_TEMPERATURE = 4;
V_APPLIED = @(t) 4e3*sin(2*pi*16e3*t);
GAMMA_II = 5e-2;
SURF_CHARGE_COEFF = [1, 1, 1];
GAMMA_II_DIEL = 1e-2;
TIME_INSTANTS = [0, 2e-7];
INITIAL_CONDITION = {
    "e",         1e10;
    "Ar(gnd)",   "Ngas";
    "Ar(*)",     1e10;
    "Ar(+,gnd)", 1e10;
    "Ar2(+,X)",  1e10;
    "Ar2(*)",    1e10};
SAVE_EACH_K_TIMESTEPS = 15;
ODE_TYPE = "ode15s";
OUTPUT_FUNCTION = "i";

ELECTRIC_FIELD_0D = @(t) 50;