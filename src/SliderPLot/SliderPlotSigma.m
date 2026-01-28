function sld = SliderPlotSigma(out_pp)

fig = figure("WindowStyle","normal");
ax = axes(fig);

top_lim = max(out_pp.SIGMA,[],"all");
bottom_lim = min(out_pp.SIGMA,[],"all");

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',out_pp.nt, 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ...
    'Callback', @(src,~) PlotSigma(round(src.Value)));

btn = uicontrol(fig, ...
    'Style','togglebutton', ...
    'String','global', ...
    'Units','normalized', ... 
    'Value', 1,...
    'Position',[0.93 0.95 0.06 0.04], ...
    'Callback',@(src,~) PlotSigma(round(sld.Value)));

sigmak = out_pp.SIGMA(:,1);
x = out_pp.msh.xf(out_pp.msh.f_from_d);
pl = plot(ax, x, sigmak);
ylabel("surface charge density $(\mathrm{C}\mathrm{m}^{-2})$", "Interpreter","latex")
xlim([min(x), max(x)])
xlabel("x $(\mathrm{m})$", "Interpreter","latex")
grid on
ax.TickLabelInterpreter = "latex";
ax.FontSize = 15;

function PlotSigma(k)
    s_k = out_pp.SIGMA(:,k);
    pl.YData = s_k;
    if btn.Value == 1
        ylim(ax,[bottom_lim, top_lim])
        btn.String = "global";
    else
        if max(s_k) ~= min(s_k)
            ylim(ax,[min(s_k), max(s_k)])
        end
        btn.String = "auto";
    end
end

end