clearvars, close all, clc %#ok<DUALC>
opts.MSH = "FerreiraSpicchio";
opts.BCEL_FLAG = [0; 0; 1];
opts.BCEL_VAL = [1; 0; 0];
opts.BC_FLAG = {
    "e",  {"GorinLike", "GorinLike", "Flux"};
    "N2+",{"GorinLike", "GorinLike", "Flux"};
    "O2+",{"GorinLike", "GorinLike", "Flux"};
    "O-", {"GorinLike", "GorinLike", "Flux"};
    "O2-",{"GorinLike", "GorinLike", "Flux"};
    "O3-",{"GorinLike", "GorinLike", "Flux"}};
opts.BC_VAL = {
    'e',  {NaN, NaN, 0};
    'N2+',{NaN, NaN, 0};
    'O2+',{NaN, NaN, 0};
    'O-', {NaN, NaN, 0};
    'O2-',{NaN, NaN, 0};
    'O3-',{NaN, NaN, 0}};
opts.MU = {
    'e',  "Loki_mu(E)/Ngas";
    'N2+',"(1/Ngas) * min(0.75e23 * (T)^(-0.5), 2.03e12 * (E/1e21)^(-0.5))";
    'O2+',"(1/Ngas) * min(1.18e23 * (T)^(-0.5), 3.61e12 * (E/1e21)^(-0.5))";
    'O-', "1.2e22/Ngas";
    'O2-',"7.1e21/Ngas";
    'O3-',"7.6e21/Ngas"};
opts.D = {
    'e',  "Loki_D(E)/Ngas";
    'N2+',"(muN2+)*T/11600";
    'O2+',"(muO2+)*T/11600";
    'O-', "(muO-)*T/11600";
    'O2-',"(muO2-)*T/11600";
    'O3-',"(muO3-)*T/11600"};
opts.V_TH_COEFF = {
    'e',  1; 
    'N2+',1;
    'O2+',1;
    'O-', 1;
    'O2-',1;
    'O3-',1};
opts.CONST_OMEGA = {
    "e",  0; 
    "N2+",0;
    "O2+",0;
    "O-", 1e5;
    "O2-",1e5;
    "O3-",1e5;};
opts.CHEMICAL_MODEL = "s_Ferreira";
opts.CONST_SPECIES = {
    "N2", 0.7884, "rel";
    "O2", 0.2116, "rel";
    "O", 1, "abs";
    "N2O", 1, "abs"
    };
% opts.PHOTOIONIZATION.REACTIONS = {
%     'e + N2 -> 2e + N2+';
%     "e + O2 -> 2e + O2+"};
% opts.PHOTOIONIZATION.SPECIES_COEFF = {
%     'N2+',0.8;
%     'O2+',0.2};
% opts.PHOTOIONIZATION.BC = [0, 0, 1];
% opts.PHOTOIONIZATION.UPDATE_FREQUENCY = 1;
opts.LOKI_INPUT = "Air";
opts.ELECTRON_TEMPERATURE = "LoKI";
opts.GAMMA_II = 1e-6;

opts.INITIAL_CONDITION = {
    "e",  1e11; 
    "N2+",2e11;
    "O2+",2e11;
    "O-", 1e11;
    "O2-",1e11;
    "O3-",1e11};
% opts.INITIAL_CONDITION = "FerreiraSpicchio_1.19_35kV_long_photo_001.mat";
opts.MSH_PARAMETERS.r = 1e-2;
opts.V_APPLIED = @(t) 35e3; 
opts.TIME_INSTANTS = logspace(-12,-1,100);

out = Merlino2D(opts,"OUTPUT_FUNCTION","bar","BAR_SCALE","log");
out_pp = PostProcessing(out,"full");
Save(out_pp,"FerreiraSpicchio.mat")