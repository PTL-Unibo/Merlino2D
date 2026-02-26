function sld = SliderPlotIV(out_pp)

fig = figure("WindowStyle","normal");
ax = axes(fig);

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',out_pp.nt, 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ...
    'Callback', @(src,~) PlotTime(round(src.Value)));

Plot(out_pp,"ax",ax,"type","t-iv");
hold on
pl_line = plot(ax,[1,1]*out_pp.tout(1),[-1e6,1e6],"g","LineStyle","-");

function PlotTime(k)
    pl_line.XData = [1,1].*out_pp.tout(k);
end

end
