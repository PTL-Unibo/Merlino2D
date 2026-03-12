MSH = 'mesh_rods_half_rsmall';
PPP_const = 1/10;
BCEL_FLAG = [0; 0; 1];
BCEL_VAL = [1; 0; 0];
V_APPLIED = @(t) 625;%LinRamp(t,2,2e3,4e3);
BC_FLAG = {
    "e",         {'GorinLike', "GorinLike", 'Flux'};
    "He(gnd)",   {'Flux',      "Flux",      'Flux'};
    "He(+,gnd)", {'GorinLike', "GorinLike", 'Flux'};
    "He(*)",     {'Flux',      "Flux",      'Flux'};
    "He2(+,X)",  {'GorinLike', "GorinLike", 'Flux'};
    "He2(*)",    {'Flux',      "Flux",      'Flux'}};
BC_VAL = {
    "e",         {NaN, NaN, 0};
    "He(gnd)",   {0,   0,   0};
    "He(+,gnd)", {NaN, NaN, 0};
    "He(*)",     {0,   0,   0};
    "He2(+,X)",  {NaN, NaN, 0};
    "He2(*)",    {0,   0,   0}};
TIME_INSTANTS = [0,1e-3];%linspace(0,100,1001);
INITIAL_CONDITION = {
    "e",         1e10;
    "He(gnd)",   "Ngas";
    "He(+,gnd)", 1e10/2;
    "He(*)",     1e10;
    "He2(+,X)",  1e10/2;
    "He2(*)",    1e10;};
MU = {
    "e",         'Loki_mu(E)/Ngas';
    "He(gnd)",   0;
    "He(+,gnd)", 2e-3/PPP_const;
    "He(*)",     0;
    "He2(+,X)",  2e-3/PPP_const;
    "He2(*)",    0};
D = {
    "e",         'Loki_D(E)/Ngas';
    "He(gnd)",   "<<muHe(+,gnd)>>*T/11600";
    "He(+,gnd)", '<<muHe(+,gnd)>>*T/11600';
    "He(*)",     '<<muHe(+,gnd)>>*T/11600';
    "He2(+,X)",  '<<muHe2(+,X)>>*T/11600';
    "He2(*)",    "<<muHe2(+,X)>>*T/11600"};
V_TH_COEFF = {
    "e",         1;
    "He(gnd)",   0;
    "He(+,gnd)", 1;
    "He(*)",     0;
    "He2(+,X)",  1;
    "He2(*)",    0};
CONST_OMEGA = {
    "e",         0;
    "He(gnd)",   0;
    "He(+,gnd)", 0;
    "He(*)",     0;
    "He2(+,X)",  0;
    "He2(*)",    0};
CHEMICAL_MODEL = 's_Helium';
LOKI_INPUT = "Hel";
ELECTRON_TEMPERATURE = 'LoKI';
GAMMA_II = 1e-2;
SAVE_EACH_K_TIMESTEPS = 5;
PRESSURE = 101325*PPP_const;
OUTPUT_FUNCTION = "bar";
BAR_SCALE = "lin";
COORDINATES = "cartesian";
