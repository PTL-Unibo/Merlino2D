function [] = AxisEqual3D(ax)
    if nargin < 1
        ax = gca();
    end
    ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
end

