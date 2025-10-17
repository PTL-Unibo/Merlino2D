opts.MSH = "Square";
opts.BCEL_FLAG = [0;0;0;0];
opts.BCEL_VAL = [0;0;0;0];
opts.V_APPLIED = @(t) 0;
opts.BC_FLAG = ["FreeDriftFlow","FreeDriftFlow","FreeDriftFlow","FreeDriftFlow"];
opts.BC_VAL = @(t) [0, 0, 0, 0];
opts.TIME_INSTANTS = linspace(0,6e-3,601);
opts.INITIAL_CONDITION.A = 1e10;
opts.INITIAL_CONDITION.B = 0;
opts.INITIAL_CONDITION.x0 = 0;
opts.INITIAL_CONDITION.y0 = -900*6e-3/(2*pi);
opts.INITIAL_CONDITION.sigma_x = 5e-3;
opts.INITIAL_CONDITION.sigma_y = 5e-3;
opts.S_NAMES = [];
opts.NS = 1;
opts.QS = 0;
opts.MASS = 1;
opts.MU = {0};
opts.D = {0};
opts.V_TH_COEFF = 1;

% Uncomment lines 62 and 63 in DaeFunc2D.m:
% ux = ones(size(ux)) * 900*cos(2*pi*(1/6e-3)*t);
% uy = ones(size(uy)) * 900*sin(2*pi*(1/6e-3)*t);
% BE CAREFUL!! COMMENT THEM AGAIN AFTER!!
out = Merlino2D(opts);
out_pp = PostProcessing(out,"full");

fig = figure();
ax = axes(fig);
trisurf(out_pp.link_cell_to_nodes, out_pp.x_nodes, out_pp.y_nodes, sum(out_pp.N_NODES(:,(1:100:501))/1e10,2), "EdgeColor","none");
shading interp
colormap(jet);
cb = colorbar("TickLabelInterpreter","latex","Location","northoutside");
cb.Label.String = "normalized number density $()$";
cb.Label.FontSize = 15;
cb.Label.Interpreter = "latex";
cb.TickLabels = {"$10^{-1}$","$1$"};
cb.TickLength = cb.TickLength * 4; 
clim([5e-2,1])
view([0,90])
ax.ColorScale="log";
ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
xlabel("x $(\mathrm{m})$", "Interpreter","latex")
ylabel("y $(\mathrm{m})$", "Interpreter","latex")
set(ax, 'TickLabelInterpreter', 'latex');
set(ax, "FontSize", 15)
xlim([-1.1,1.1])
ylim([-1.1,1.1])
hold on

Z_VAL = 6e-2;

alpha = linspace(0,2*pi,1e4);
R = 900*6e-3/(2*pi);
x = R*cos(alpha);
y = R*sin(alpha);
z = Z_VAL*ones(size(x));
plot3(x,y,z,"w");

RR = R * 1.05;
da = 0.08;
ds = 0.05;
for a = (pi/6+ds):pi/3:2*pi
    xp = R*cos(-pi/2+a);
    yp = R*sin(-pi/2+a);
    x1 = RR*cos(-pi/2+a-da);
    y1 = RR*sin(-pi/2+a-da);
    m = tan(a);
    q = yp-m*xp;
    m1 = -1/m;
    q1 = y1-m1*x1;
    O = [m, -1; m1, -1] \ [-q; -q1];
    plot3([xp,x1],[yp,y1],[Z_VAL,Z_VAL],"w")
    plot3([xp,2*O(1)-x1],[yp,2*O(2)-y1],[Z_VAL,Z_VAL],"w")
end

bottomleft = [0.2810    0.1397];
topright = [0.7548    0.7683];

x = [0.04, 0.7, 0.68, 0.1, -0.55, -0.58] * 6/5;
y = [-0.68, -0.25, 0.5, 0.78, 0.4, -0.3] * 6/5;
for k = 1:numel(x)
    [norm_x, norm_y] = CoordToNormal(ax, bottomleft, topright, x(k), y(k));
    annotation('textbox', [norm_x, norm_y, 0.05, 0.05], ...
               'HorizontalAlignment','left',...
               'String', "$t_" + num2str(k) + "$", ...
               'Interpreter', 'latex', ...
               'EdgeColor', "none", ...
               "Color","white",...
               "VerticalAlignment","middle",...
               'FontSize', 15);
end

function [norm_x, norm_y] = CoordToNormal(axes_in, bottomleft, topright, x, y)
%CoordToNormal converts a point to normalized coordinates
% INPUT
% axes_in -> handle to axes object
% x -> x coordinate
% y -> y coordinate
% OUTPUT
% norm_x -> normalized x coordinate with respect to figure
% norm_y -> normalized y coordinate with respect to figure
XLIM = axes_in.XLim;
YLIM = axes_in.YLim;
if axes_in.XScale == "log"
    perc_x = (log(x) - log(XLIM(1))) / (log(XLIM(2)) - log(XLIM(1)));
else
    perc_x = (x - XLIM(1)) / (XLIM(2) - XLIM(1));
end
if axes_in.YScale == "log"
    perc_y = (log(y) - log(YLIM(1))) / (log(YLIM(2)) - log(YLIM(1)));
else
    perc_y = (y - YLIM(1)) / (YLIM(2) - YLIM(1));
end
norm_x = (topright(1)-bottomleft(1)) * perc_x + bottomleft(1); 
norm_y = (topright(2)-bottomleft(2)) * perc_y + bottomleft(2); 
end