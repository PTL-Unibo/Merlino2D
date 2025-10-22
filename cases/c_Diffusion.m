opts.MSH = "SquareCenterRefined";
opts.BCEL_FLAG = 0;
opts.BCEL_VAL = 0;
opts.V_APPLIED = @(t) 0;
opts.BC_FLAG = "Flux";
opts.BC_VAL = @(t) 0;
opts.TIME_INSTANTS = linspace(0,2e-3,201);
opts.INITIAL_CONDITION.A = 1;
opts.INITIAL_CONDITION.B = 0;
opts.INITIAL_CONDITION.x0 = 0;
opts.INITIAL_CONDITION.y0 = 0;
opts.INITIAL_CONDITION.sigma_x = 1e-2;
opts.INITIAL_CONDITION.sigma_y = 1e-2;
opts.INPUT_SPECIES_ORDER = "N";
opts.MU = {0};
opts.D = {2};
opts.V_TH_COEFF = 1;

out = Merlino2D(opts);
out_pp = PostProcessing(out);

cells = out_pp.msh.cs_from_f(out_pp.msh.xf == 0,:);
cells = cells(:);

cells = cells(out_pp.msh.xc(cells) < 0);

temp = sortrows([out_pp.msh.yc(cells), cells]);

ii = temp(:,2);
ii = ii(1:7:end);

x = out_pp.msh.xc(ii);
y = out_pp.msh.yc(ii);

s0 = 1e-2;
A0 = 1;
D = 2;

A = @(t) A0*s0./(4*D*t + s0);
s = @(t) 4*D*t + s0;
y_exact = linspace(-0.6,0.6,1e4);
n = @(t) A(t) .* exp(-(y_exact.^2)./s(t));

indices_time = [1, 101, 201];

figure
colors = get(gca, 'ColorOrder');
hold on
for i = 1:numel(indices_time)
    Nexact = n(out_pp.tout(indices_time(i)));
    plot(y, out_pp.N_CELLS(ii,indices_time(i)), ".", "MarkerSize",12, "Color",colors(i,:), "HandleVisibility","off")
    plot(y_exact, Nexact, "-", "Color",colors(i,:), "HandleVisibility","off")
end

% only for legend
plot(-100,-100,"k.","MarkerSize",12,"DisplayName","numerical")
plot([-100,-90],[-100,-90],"k-","DisplayName","analytical")

grid on
xlim([-0.34,0.34])
ylim([0,1.1])
legend("Interpreter","latex")

xlabel("y $(\mathrm{m})$", "Interpreter","latex")
ylabel("normalized number density $()$", "Interpreter","latex")

set(gca, "FontSize", 15);
set(gca, 'TickLabelInterpreter', 'latex');

annotation('textbox', [0.45 0.8 0.15 0.15], ...
           'String', '$t = 0 \; \mathrm{s}$', ...
           'Interpreter', 'latex', ...
           'EdgeColor', "none", ...
           "Color",colors(1,:),...
           "HorizontalAlignment","center",...
           "VerticalAlignment","middle",...
           'FontSize', 15);

annotation('textbox', [0.45 0.49 0.15 0.15], ...
           'String', '$t = 1 \; \mathrm{ms}$', ...
           'Interpreter', 'latex', ...
           'EdgeColor', "none", ...
           "Color",colors(2,:),...
           "HorizontalAlignment","center",...
           "VerticalAlignment","middle",...
           'FontSize', 15);

annotation('textbox', [0.45 0.275 0.15 0.15], ...
           'String', '$t = 2 \; \mathrm{ms}$', ...
           'Interpreter', 'latex', ...
           'EdgeColor', "none", ...
           "Color",colors(3,:),...
           "HorizontalAlignment","center",...
           "VerticalAlignment","middle",...
           'FontSize', 15);
