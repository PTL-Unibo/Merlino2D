MSH = "FerreiraSpicchioCoarse";
p = 0.5;
v_start = 15e3;
v_end = 25e3;
BCEL_FLAG = [0; 0; 1];
BCEL_VAL = [1; 0; 0];
V_APPLIED = @(t) TanhShortRamp(t,v_start,v_end,0.5);
DV_APPLIED = @(t) DTanhShortRamp(t,v_start,v_end,0.5);
R = 0;
ANODE_IDS = 1;
BC_FLAG = {
    "e",  {"GorinLike", "GorinLike", "Flux"};
    "N2+",{"GorinLike", "GorinLike", "Flux"};
    "O2+",{"GorinLike", "GorinLike", "Flux"};
    "O-", {"GorinLike", "GorinLike", "Flux"};
    "O2-",{"GorinLike", "GorinLike", "Flux"};
    "O3-",{"GorinLike", "GorinLike", "Flux"}};
BC_VAL = {
    'e',  {NaN, NaN, 0};
    'N2+',{NaN, NaN, 0};
    'O2+',{NaN, NaN, 0};
    'O-', {NaN, NaN, 0};
    'O2-',{NaN, NaN, 0};
    'O3-',{NaN, NaN, 0}};
TIME_INSTANTS = linspace(0,0.8,601);
MU = {
    'e',  "Loki_mu(E)/Ngas";
    'N2+',"(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    'O2+',"(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    'O-', "1.2e22/Ngas";
    'O2-',"7.1e21/Ngas";
    'O3-',"7.6e21/Ngas"};
D = {
    'e',  "Loki_D(E)/Ngas";
    'N2+',"<<muN2+>>*T/11600";
    'O2+',"<<muO2+>>*T/11600";
    'O-', "<<muO->>*T/11600";
    'O2-',"<<muO2->>*T/11600";
    'O3-',"<<muO3->>*T/11600"};
V_TH_COEFF = {
    'e',  1; 
    'N2+',1;
    'O2+',1;
    'O-', 1;
    'O2-',1;
    'O3-',1};
CONST_OMEGA = {
    "e",  0; 
    "N2+",0;
    "O2+",0;
    "O-", 1e5;
    "O2-",1e5;
    "O3-",1e5;};
CHEMICAL_MODEL = "s_Ferreira";
CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel";
    "O", 1, "abs";
    "N2O", 1, "abs"};
% PHOTOIONIZATION.REACTIONS = {
%     'e + N2 -> 2e + N2+';
%     "e + O2 -> 2e + O2+"};
% PHOTOIONIZATION.SPECIES_COEFF = {
%     'N2+',0.8;
%     'O2+',0.2};
% PHOTOIONIZATION.BC = [0, 0, 1];
% PHOTOIONIZATION.UPDATE_FREQUENCY = 1;
LOKI_INPUT = "Air";
ELECTRON_TEMPERATURE = "LoKI";
GAMMA_II = 1e-6;
INITIAL_CONDITION = {
    "e",  1e11; 
    "N2+",2e11;
    "O2+",2e11;
    "O-", 1e11;
    "O2-",1e11;
    "O3-",1e11};
OUTPUT_FUNCTION = "bar";
BAR_SCALE = "lin";
PRESSURE = 101325 * p; 
