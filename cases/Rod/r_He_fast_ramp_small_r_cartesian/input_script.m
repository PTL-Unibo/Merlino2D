opts.MSH = 'mesh_rods_half';
opts.BCEL_FLAG = [0; 0; 1];
opts.BCEL_VAL = [1; 0; 0];
opts.V_APPLIED = @(t) LinRamp(t,1e-4,2.4e3,3e3);
opts.BC_FLAG = {
    "e",         {'GorinLike', "GorinLike", 'Flux'};
    "He(gnd)",   {'Flux',      "Flux",      'Flux'};
    "He(+,gnd)", {'GorinLike', "GorinLike", 'Flux'};
    "He(*)",     {'Flux',      "Flux",      'Flux'};
    "He2(+,X)",  {'GorinLike', "GorinLike", 'Flux'};
    "He2(*)",    {'Flux',      "Flux",      'Flux'}};
opts.BC_VAL = {
    "e",         {NaN, NaN, 0};
    "He(gnd)",   {0,   0,   0};
    "He(+,gnd)", {NaN, NaN, 0};
    "He(*)",     {0,   0,   0};
    "He2(+,X)",  {NaN, NaN, 0};
    "He2(*)",    {0,   0,   0}};
opts.TIME_INSTANTS = [0, 1e-4];%linspace(0,1e-4,1001);
opts.INITIAL_CONDITION = {
    "e",         1e11;
    "He(gnd)",   2.69e25;
    "He(+,gnd)", 1e11/2;
    "He(*)",     1e10;
    "He2(+,X)",  1e11/2;
    "He2(*)",    1e10;};
opts.MU = {
    "e",         'Loki_mu(E)/Ngas';
    "He(gnd)",   0;
    "He(+,gnd)", 2e-3;
    "He(*)",     0;
    "He2(+,X)",  2e-3;
    "He2(*)",    0};
opts.D = {
    "e",         'Loki_D(E)/Ngas';
    "He(gnd)",   "<<muHe(+,gnd)>>*T/11600";
    "He(+,gnd)", '<<muHe(+,gnd)>>*T/11600';
    "He(*)",     '<<muHe(+,gnd)>>*T/11600';
    "He2(+,X)",  '<<muHe2(+,X)>>*T/11600';
    "He2(*)",    "<<muHe2(+,X)>>*T/11600"};
opts.V_TH_COEFF = {
    "e",         1;
    "He(gnd)",   0;
    "He(+,gnd)", 1;
    "He(*)",     0;
    "He2(+,X)",  1;
    "He2(*)",    0};
opts.CONST_OMEGA = {
    "e",         0;
    "He(gnd)",   0;
    "He(+,gnd)", 0;
    "He(*)",     0;
    "He2(+,X)",  0;
    "He2(*)",    0};
opts.CHEMICAL_MODEL = 's_Helium';
opts.LOKI_INPUT = "Hel";
opts.ELECTRON_TEMPERATURE = 'LoKI';
opts.GAMMA_II = 1e-2;
opts.SAVE_EACH_K_TIMESTEPS = 5;
p = M2DInput(opts,"OUTPUT_FUNCTION",'bar',"BAR_SCALE","lin","COORDINATES","cartesian");
