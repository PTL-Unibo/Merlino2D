MSH = 'WireCyl_50u_5m_30m';
BCEL_FLAG = [0; 0; 1; 1; 1; 1];
BCEL_VAL = [1; 0; 0; 0; 0; 0];
[tx,vx,time_instants] = StairRamp(1e-3,1e-4,(7:2:21)*1e3);
V_APPLIED = @(t) interp1(tx,vx,t);
R = 1e-3;
ANODE_IDS = 1;
BC_FLAG = {"e",   {"GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"};
           "N2+", {"GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"};
           "O2+", {"GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"};
           "O2-", {"GorinLike", "GorinLike", "Flux", "Flux", "Flux", "Flux"}};
BC_VAL = {
    "e",  {NaN, NaN, 0, 0, 0, 0};
    "N2+",{NaN, NaN, 0, 0, 0, 0};
    "O2+",{NaN, NaN, 0, 0, 0, 0};
    "O2-",{NaN, NaN, 0, 0, 0, 0}};
TIME_INSTANTS = [0, time_instants];
INITIAL_CONDITION = {
    "e",  0.001e13;
    "N2+",0.8e13;
    "O2+",0.2e13;
    "O2-",0.999e13};
MU = {
    "e",  "(1/Ngas) * 3.74e19 * exp(33.5 * (log(Te*11600))^(-0.5))";         
    "N2+","(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    "O2+","(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    "O2-","(1/Ngas) * min(0.97e23 * (T)^(-0.5), 3.56e19 * (E/1e21)^(-0.1))"
    };
D = {
    "e",  "<<mue>>*Te";
    "N2+","<<muN2+>>*T/11600";
    "O2+","<<muO2+>>*T/11600";
    "O2-","<<muO2->>*T/11600";
    };
V_TH_COEFF = {
    "e",  1;
    "N2+",1;
    "O2+",1;
    "O2-",1};
CONST_OMEGA = {
    "e",  1e15;
    "N2+",0.5e15;
    "O2+",0.5e15;
    "O2-",1e5};
CHEMICAL_MODEL = "s_Parent";
CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel"};
ELECTRON_TEMPERATURE = "Te_Air";
GAMMA_II = 1e-2;
ODE_TYPE = "idas";
