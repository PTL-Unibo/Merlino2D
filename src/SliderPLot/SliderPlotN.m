function sld = SliderPlotN(out_pp)

fig = figure("WindowStyle","normal");
ax = axes(fig);

FLIP_Y = 0;

s_cell = cell(1,out_pp.ns);
top_lim = zeros(1,out_pp.ns);
bottom_lim = zeros(1,out_pp.ns);
j = 1;
for s_name = out_pp.S_NAMES'
    s_cell{j} = char(s_name);
    top_lim(j) = max(out_pp.N_CELLS((j-1)*out_pp.Nc+1:j*out_pp.Nc,:),[],"all");
    bottom_lim(j) = min(out_pp.N_CELLS((j-1)*out_pp.Nc+1:j*out_pp.Nc,:),[],"all");
    j = j + 1;
end

cmbbox = uicontrol(fig, ...
    'Style','listbox', ...
    'String',s_cell, ...
    'Units','normalized', ...
    'Position',[0.01 0.91 0.2 0.08], ...
    'Value',1);

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',out_pp.nt, 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ...
    'Callback', @(src,~) PlotSpecies(round(src.Value),cmbbox.Value,FLIP_Y));

cmbbox.Callback = @(src,~) PlotSpecies(round(sld.Value),src.Value,FLIP_Y);

count = 1;

function PlotSpecies(k,is,flip_y)
    persistent cb

    axes(ax)
    nk = (out_pp.N_CELLS((is-1)*out_pp.Nc+1:is*out_pp.Nc,k));
    patch( ...
        out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
        out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
        nk, ...
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
            nk, ...
            "EdgeColor","none");
        hold off
        if count==1
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
        % clim([bottom_lim(is), top_lim(is)]);
        cb.Label.Interpreter = "latex";
        % cb.Label.String = out_pp.S_NAMES(is) + " number density $(\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
    end
    clim([bottom_lim(is), top_lim(is)]);
    cb.Label.String = out_pp.S_NAMES(is) + " number density $(\mathrm{m}^{-3})$";
    ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];

    count = count + 1;
end

end