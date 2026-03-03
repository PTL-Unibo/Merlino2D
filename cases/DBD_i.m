MSH = "DBD";
MSH_PARAMETERS.k = 1;
EPSR_VAL = [1; 3.2];
BCEL_FLAG = [0; 0; 0; 1; 1; 1; 1];
BCEL_VAL = [1; 1; 0; 0; 0; 0; 0];
V_APPLIED = @(t) 15e3*sin(2*pi*100e3*t);
BC_FLAG = {
    'I-',{"GorinLike",     "GorinLike", 'Flux', "Flux", "Flux"};
    'e', {'FreeDriftFlow', 'GorinLike', "Flux", 'Flux', 'Flux'};
    "I+",{"GorinLike",     "GorinLike", "Flux", 'Flux', "Flux"}};
BC_VAL = {
    "I+",{NaN, NaN, 0, 0, 0};
    "e", {NaN, NaN, 0, 0, 0};
    'I-',{NaN, NaN, 0, 0, 0}};
TIME_INSTANTS = linspace(0,0.25/100e3,2501);
% TIME_INSTANTS = linspace(0,1e-12,11);
INITIAL_CONDITION = {
    "I+",1e13;
    "I-",0.999e13;
    "e", 0.001e13;};
MU = {
    "I+",'(1/Ngas) * (min(0.84e23 * (T)^(-0.5), 2.35e12 * (E/1e21)^(-0.5)))';
    "e", "mu_Air(E)/Ngas";
    'I-',"(1/Ngas) * (min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1)))"};
D = {
    "I+","<<muI+>>*T/11600";
    "e", 'D_Air(E)/Ngas';
    "I-","<<muI->>*T/11600"};
V_TH_COEFF = {
    'e', 0;
    "I+",1;
    'I-',1};
CONST_OMEGA = {
    'I-',1e5
    'e', 1e15;
    "I+",1e15};
CHEMICAL_MODEL = 's_TownsendLoki';
CONST_SPECIES = {"M", 1, "rel"};
LOKI_INPUT = 'Air';
ELECTRON_TEMPERATURE = "Te_Air";
GAMMA_II = 5e-2;
SURF_CHARGE_COEFF = [0.1, 0.1, 0.1];
GAMMA_II_DIEL = 1e-2;
ODE_TYPE = "idas";
