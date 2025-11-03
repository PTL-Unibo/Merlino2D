function [] = AxisEqual3D()
    ax = gca();
    ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
end

