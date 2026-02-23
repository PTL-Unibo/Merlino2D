clearvars, close, clc
%<<<<<
opts.MSH = 'PointPlaneExp';
[tx,vx,time_instants] = StairRamp(1e-2,1e-2,(5:0.2:9.4)*1e3);

opts.BCEL_FLAG = [0; 0; 1; 1];
opts.BCEL_VAL = [1; 0; 0; 0];
opts.V_APPLIED = @(t) interp1(tx,vx,t);
% opts.V_APPLIED = @(t) LinRamp(t,1e-4,3e3,5e3);
opts.BC_FLAG = {
    "N2+", {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "e",   {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "O2+", {'GorinLike', "GorinLike", 'Flux', 'Flux'};
    "O2-", {'GorinLike', "GorinLike", 'Flux', 'Flux'}};
opts.BC_VAL = {
    'e',   {NaN, NaN, 0, 0};
    'O2+', {NaN, NaN, 0, 0};
    'O2-', {NaN, NaN, 0, 0};
    'N2+', {NaN, NaN, 0, 0}};
% opts.TIME_INSTANTS = linspace(0,1e-3,101);
opts.TIME_INSTANTS = time_instants;
opts.INITIAL_CONDITION = "cases/PointPlane/r_AirExp_5kV";
% opts.INITIAL_CONDITION = {
%     'N2+',0.8e13;
%     'O2-',0.999e13;
%     "O2+",0.2e13;
%     'e',  0.001e13;};
opts.MU = {
    'e',   'Loki_mu(E)/Ngas';
    "N2+", "(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    'O2+', "(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    'O2-', "(1/Ngas) * min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1))"};
opts.D = {
    "O2+", '<<muO2+>>*T/11600';
    "e",   "Loki_D(E)/Ngas";
    "N2+", '<<muN2+>>*T/11600';
    "O2-", "<<muO2->>*T/11600"};
opts.V_TH_COEFF = {
    "N2+", 1;
    "e",   1;
    "O2+", 1;
    "O2-", 1};
opts.CONST_OMEGA = {
    "N2+", 0.8e15;
    "O2+", 0.2e15;
    "e", 1e15;
    "O2-", 1e5};
opts.CHEMICAL_MODEL = 's_Parent';
opts.CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel"};
opts.LOKI_INPUT = "Air";
opts.ELECTRON_TEMPERATURE = 'LoKI';
opts.GAMMA_II = 1e-2;

p = M2DInput(opts,"OUTPUT_FUNCTION",'bar',"BAR_SCALE","lin","COORDINATES","cylindrical");

%>>>>>
out = Merlino2D(matlab.desktop.editor.getActiveFilename,"run");