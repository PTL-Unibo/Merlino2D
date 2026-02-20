clearvars, close, clc
%<<<<<
opts.MSH = 'PointPlane';

opts.BCEL_FLAG = [0; 0; 1; 1];
opts.BCEL_VAL = [1; 0; 0; 0];

% [tx,vx,time_instants] = StairRamp(1e-2,1e-2,(4.2:0.2:10)*1e3);
opts.V_APPLIED = @(t) 500;%interp1(tx,vx,t); 

opts.BC_FLAG = {
    "e",         {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "He(gnd)",   {'Flux',      "Flux",      'Flux', 'Flux'};
    "He(+,gnd)", {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "He(*)",     {'Flux',      "Flux",      'Flux', 'Flux'};
    "He2(+,X)",  {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "He2(*)",    {'Flux',      "Flux",      'Flux', 'Flux'}};
opts.BC_VAL = {
    "e",         {NaN, NaN, 0, 0};
    "He(gnd)",   {0,   0,   0, 0};
    "He(+,gnd)", {NaN, NaN, 0, 0};
    "He(*)",     {0,   0,   0, 0};
    "He2(+,X)",  {NaN, NaN, 0, 0};
    "He2(*)",    {0,   0,   0, 0}};
opts.TIME_INSTANTS = linspace(0,1e-6,101);
% opts.INITIAL_CONDITION = "CoronaPointPlane_He_500V_5deg_Tok.mat";
opts.INITIAL_CONDITION = {
    "e",         1e13;
    "He(gnd)",   2.45e25;
    "He(+,gnd)", 1e13/2;
    "He(*)",     1e10;
    "He2(+,X)",  1e13/2;
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
% opts.CONST_OMEGA = {
%     "e",         -1e20;
%     "He(gnd)",   0;
%     "He(+,gnd)", -1e20/2;
%     "He(*)",     0;
%     "He2(+,X)",  -1e20/2;
%     "He2(*)",    0};
opts.CHEMICAL_MODEL = 's_Helium';
opts.LOKI_INPUT = "Hel";
opts.ELECTRON_TEMPERATURE = 'LoKI';
opts.GAMMA_II = 1e-2;
opts.TEMPERATURE = 293;

p = M2DInput(opts,"OUTPUT_FUNCTION",'bar',"BAR_SCALE","lin","COORDINATES","cylindrical","ELECTRIC_FIELD_0D",@(t)20);
%>>>>>

out = Merlino2D(matlab.desktop.editor.getActiveFilename,"run");
% Save(out,"PointPlaneHelium")
% out = Merlino2D(opts,"OUTPUT_FUNCTION",'bar',"BAR_SCALE","lin","COORDINATES","cylindrical");
% out_pp = PostProcessing(out);
% Save(out_pp,"CoronaPointPlane_4kV.mat")