function sld = SliderPlotRho(out_pp)

fig = figure("WindowStyle","normal");
ax = axes(fig);

FLIP_Y = 0;

top_lim = max(out_pp.RHO_CELLS,[],"all");
bottom_lim = min(out_pp.RHO_CELLS,[],"all");

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',out_pp.nt, 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ...
    'Callback', @(src,~) PlotRho(round(src.Value),FLIP_Y));

btn = uicontrol(fig, ...
    'Style','togglebutton', ...
    'String','GLOBAL', ...
    'Units','normalized', ... 
    'Value', 1,...
    'Position',[0.94 0.95 0.05 0.04], ...
    'Callback',@(src,~) PlotRho(round(sld.Value),FLIP_Y));

count = 1;

function PlotRho(k,flip_y)

    axes(ax)
    rhok = out_pp.RHO_CELLS(:,k);
    patch( ...
        out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
        out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
        rhok, ...
        "EdgeColor","none");
    if count == 1
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
    end
    if flip_y
        hold on
        patch( ...
            out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
            -out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
            rhok, ...
            "EdgeColor","none");
        hold off
        if count == 1
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
    end
    if count == 1
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.TickLabelInterpreter = "latex";
        ax.ColorScale = "log";
        ax.FontSize = 15;
        cb = colorbar(ax,"TickLabelInterpreter","latex");
        cb.Label.Interpreter = "latex";
        cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
    end
    if btn.Value == 1
        clim([bottom_lim, top_lim]);
        btn.String = "GLOBAL";
    else
        if max(rhok) ~= min(rhok)
            clim([min(rhok), max(rhok)])
        end
        btn.String = "Instant";
    end
    ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];

    count = count + 1;
end

end