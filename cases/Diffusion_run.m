clearvars, close, clc
out = Merlino2D("i_Diffusion","run");

%%
cells = out.msh.cs_from_f(out.msh.xf == 0,:);
cells = cells(:);

cells = cells(out.msh.xc(cells) < 0);

temp = sortrows([out.msh.yc(cells), cells]);

ii = temp(:,2);
ii = ii(1:7:end);

x = out.msh.xc(ii);
y = out.msh.yc(ii);

s0 = 1e-1;
A0 = 1;
D = 2;

A = @(t) A0*s0^2./(4*D*t + s0^2);
s = @(t) sqrt(4*D*t + s0^2);
y_exact = linspace(-0.6,0.6,1e4);
n = @(t) A(t) .* exp(-(y_exact.^2)./(s(t).^2));

indices_time = [1, 101, 201];

figure
colors = get(gca, 'ColorOrder');
hold on
for i = 1:numel(indices_time)
    Nexact = n(out.tout(indices_time(i)));
    out_pp_k = ProcessInstant(out,indices_time(i));
    plot(y, out_pp_k.N_CELLS(ii), ".", "MarkerSize",12, "Color",colors(i,:), "HandleVisibility","off")
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
