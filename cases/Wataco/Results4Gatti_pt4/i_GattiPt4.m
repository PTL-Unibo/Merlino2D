MSH = "DBDStruct";
MSH_PARAMETERS.p = 1.0001;
MSH_PARAMETERS.n = 600;
MSH_PARAMETERS.w = 50e-6;
MSH_PARAMETERS.la = 0.5e-3;
MSH_PARAMETERS.lc = 1.5e-3;
MSH_PARAMETERS.k = 1.5e-4;
MSH_PARAMETERS.kd = 1e-5;
MSH_PARAMETERS.h = 1.4e-3;
MSH_PARAMETERS.r = 1e-5;

EPSR_VAL = [1; 3.1];
BCEL_FLAG = [0; 0; 0; 1; 1; 1; 1];
BCEL_VAL = [1; 1; 0; 0; 0; 0; 0];
ANODE_IDS = [1, 2];
R = 1e4;
LENGTH = 0.05;
BC_FLAG = {
    'I-',{"GorinLike", "GorinLike", 'Flux', "Flux", "Flux"};
    'e', {'GorinLike', 'GorinLike', "Flux", 'Flux', 'Flux'};
    "I+",{"GorinLike", "GorinLike", "Flux", 'Flux', "Flux"}};
BC_VAL = {
    "I+",{NaN, NaN, 0, 0, 0};
    "e", {NaN, NaN, 0, 0, 0};
    'I-',{NaN, NaN, 0, 0, 0}};
% MU = {
%     "I+",'(1/Ngas) * (min(0.84e23 * (T)^(-0.5), 2.35e12 * (E/1e21)^(-0.5)))';
%     "e", "mu_Air(E)/Ngas";
%     'I-',"(1/Ngas) * (min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1)))"};
MU = {
    "I+", 1.5e-4;
    "e",  0.08;
    'I-', 1.5e-4};
% D = {
%     "I+","<<muI+>>*T/11600";
%     "e", 'D_Air(E)/Ngas';
%     "I-","<<muI->>*T/11600"};
D = {
    "I+", 4e-6;
    "e",  0.18;
    "I-", 4e-6};
V_TH_COEFF = {
    'e', 1;
    "I+",1;
    'I-',1};
CONST_OMEGA = {
    'I-',1e5;
    'e', 1e15;
    "I+",1e15};
CHEMICAL_MODEL = 's_TownsendLoki';
CONST_SPECIES = {"M", 1, "rel"};
LOKI_INPUT = 'Air';
% ELECTRON_TEMPERATURE = "Te_Air";
ELECTRON_TEMPERATURE = 3;
V_APPLIED = @(t) 4e3*sin(2*pi*16e3*t);
GAMMA_II = 5e-2;
SURF_CHARGE_COEFF = [1, 1, 1];
GAMMA_II_DIEL = 1e-2;
TIME_INSTANTS = [0, 2/16e3];
INITIAL_CONDITION = {
    'I-',1e10;
    'e', 1e10;
    "I+",2e10};
SAVE_EACH_K_TIMESTEPS = 15;
ODE_TYPE = "ode15s";
OUTPUT_FUNCTION = "i";