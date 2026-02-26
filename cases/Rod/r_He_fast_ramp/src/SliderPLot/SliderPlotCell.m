function [sld, ed_xlim_inf, ed_xlim_sup, ed_ylim_inf, ed_ylim_sup] = SliderPlotCell(out_pp)

fig = figure("WindowStyle","normal");
ax = axes(fig);
cb = colorbar(ax);

% Setting properties that will not be changed in the future
ax.TickLabelInterpreter = "latex";
ax.FontSize = 15;
cb.TickLabelInterpreter = "latex";
cb.Label.Interpreter = "latex";
cb.Label.FontSize = 15;
xlabel(ax,"x $(\mathrm{m})$", "Interpreter","latex")
ylabel(ax,"y $(\mathrm{m})$", "Interpreter","latex")

z = zoom(fig);
z.Enable = 'on';
z.ActionPostCallback = @myZoomCallback;

cmbbox_names_list = cell(1,out_pp.ns+2);
for j = 1:out_pp.ns
    cmbbox_names_list{j} = char(out_pp.S_NAMES(j));
end
cmbbox_names_list{out_pp.ns+1} = 'E';
cmbbox_names_list{out_pp.ns+2} = 'Rho';

U = sqrt(out_pp.EX_CELLS_MATRIX.^2 + out_pp.EY_CELLS_MATRIX.^2);
label_string = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
top_lim = max(U,[],"all");
bottom_lim = min(U,[],"all");

uicontrol(fig, ...
    'Style','listbox', ...
    'String',cmbbox_names_list, ...
    'Units','normalized', ...
    'Position',[0.005 0.895 0.05 0.1], ...
    'Value',out_pp.ns+1,...
    'Callback',@(src,~)cmbbox_updated(src));

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',out_pp.nt, 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ......
    'Callback', @(src,~) PlotCell(round(src.Value)));

tgl_btn = uicontrol(fig, ...
    'Style','togglebutton', ...
    'String','lin', ...
    'Units','normalized', ... 
    'Value',0,...
    'Position',[0.96 0.81 0.03 0.04], ...
    'Callback',@(src,~)tgl_btn_pressed);

btn = uicontrol(fig, ...
    'Style','pushbutton', ...
    'String','global', ...
    'Units','normalized', ... 
    'UserData',0,...
    'Position',[0.93 0.95 0.06 0.04], ...
    'Callback',@(src,~)btn_pressed);

ed_clim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.86,0.05,0.04]);
ed_clim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.9,0.05,0.04]);

ed_xlim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.89,0.01,0.05,0.04],"String",sprintf("%.2e",min(out_pp.x_nodes)));
ed_xlim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.01,0.05,0.04],"String",sprintf("%.2e",max(out_pp.x_nodes)));

ed_ylim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.005,0.81,0.05,0.04],"String",sprintf("%.2e",min(out_pp.y_nodes)));
ed_ylim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.005,0.85,0.05,0.04],"String",sprintf("%.2e",max(out_pp.y_nodes)));

    
    function PlotCell(k)

        axes(ax)
        u_k = U(:,k);
        patch( ...
            out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
            out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
            u_k, ...
            "EdgeColor","none");
        inf_x = str2double(ed_xlim_inf.String);
        sup_x = str2double(ed_xlim_sup.String);
        if ~(isnan(inf_x) || isnan(sup_x))
            xlim(ax,[inf_x, sup_x])
        else
            xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        end
        inf_y = str2double(ed_ylim_inf.String);
        sup_y = str2double(ed_ylim_sup.String);
        if ~(isnan(inf_y) || isnan(sup_y))
            ylim(ax,[inf_y, sup_y])
        else
            ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        end
        
        cb.Label.String = label_string;
        ax.ColorScale = tgl_btn.String;
        if btn.String == "global"
            clim([bottom_lim, top_lim]);
            ed_clim_inf.String = sprintf("%.2e",bottom_lim);
            ed_clim_sup.String = sprintf("%.2e",top_lim);
        elseif btn.String == "auto"
            if max(u_k) ~= min(u_k)
                clim([min(u_k), max(u_k)])
                ed_clim_inf.String = sprintf("%.2e",min(u_k));
                ed_clim_sup.String = sprintf("%.2e",max(u_k));
            end
        elseif btn.String == "manual"
            inf = str2double(ed_clim_inf.String);
            sup = str2double(ed_clim_sup.String);
            if ~(isnan(inf) || isnan(sup))
                clim([inf, sup])
            end
        end
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
    end


    function btn_pressed()
        btn.UserData = btn.UserData + 1;
        btn.UserData = mod(btn.UserData,3); 
        switch btn.UserData
            case 0
                btn.String = "global";
            case 1
                btn.String = "auto";
            case 2
                btn.String = "manual";
        end
        PlotCell(round(sld.Value))
    end


    function cmbbox_updated(src)
        if src.Value <= out_pp.ns
            U = out_pp.N_CELLS((src.Value-1)*out_pp.Nc+1:src.Value*out_pp.Nc,:);
            label_string = out_pp.S_NAMES(src.Value) + " number density $(\mathrm{m}^{-3})$";
        else
            if src.Value == out_pp.ns + 1
                U = sqrt(out_pp.EX_CELLS_MATRIX.^2 + out_pp.EY_CELLS_MATRIX.^2);
                label_string = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
            elseif src.Value == out_pp.ns + 2
                U = out_pp.RHO_CELLS;
                label_string = "charge density $(\mathrm{C}\mathrm{m}^{-3})$"; 
            end
        end
        top_lim = max(U,[],"all");
        bottom_lim = min(U,[],"all");
        PlotCell(round(sld.Value))
    end


    function tgl_btn_pressed()
        if tgl_btn.Value == 1
            tgl_btn.String = "log";
        else
            tgl_btn.String = "lin";
        end
        PlotCell(round(sld.Value))
    end


    function myZoomCallback(~, ~)
        newXLimits = ax.XLim;
        newYLimits = ax.YLim;
        
        ed_xlim_inf.String = sprintf("%.2e",newXLimits(1));
        ed_xlim_sup.String = sprintf("%.2e",newXLimits(2));
        
        ed_ylim_inf.String = sprintf("%.2e",newYLimits(1));
        ed_ylim_sup.String = sprintf("%.2e",newYLimits(2));
    end


end