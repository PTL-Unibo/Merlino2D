clearvars, close, clc
out = Merlino2D("CoronaWireCylinder_i","run");

VIexp = load(GetPath("data")+"/Experimental_Results_50u_5m_30m.csv");
Vexperiment = VIexp(:,1)*1e3; % from kilovolt to volt 
Iexperiment = VIexp(:,2)/1e3; % from mA to Ampere

[I,V] = GetAllTimeInstants(out);

plot(V,I*2)
hold on
plot(Vexperiment,Iexperiment,".","MarkerSize",10)
