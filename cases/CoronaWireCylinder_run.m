clearvars, close, clc
out = Merlino2D("CoronaWireCylinder_i","run");

%%
fig = figure();
ax = axes(fig);
my_font_size = 30;

VIexp = load(GetPath("data")+"/Experimental_Results_50u_5m_30m.csv");
Vexperiment = VIexp(:,1)*1e3; % from kilovolt to volt 
Iexperiment = VIexp(:,2)/1e3; % from mA to Ampere

[I,V] = GetAllTimeInstants(out);

plot(V*1e-3,I*2*1e6,"LineWidth",2,"DisplayName","Merlino2D")
hold on
plot(Vexperiment*1e-3,Iexperiment*1e6,".","MarkerSize",20,"DisplayName","exp")
legend("Location","northwest","Interpreter","latex")
xlabel("voltage $(\mathrm{kV})$","Interpreter","latex")
ylabel("current $(\mathrm{\mu A})$","Interpreter","latex")
ax.TickLabelInterpreter = "latex";
ax.FontSize = my_font_size;
xlim([6.5,21.5])
grid on
