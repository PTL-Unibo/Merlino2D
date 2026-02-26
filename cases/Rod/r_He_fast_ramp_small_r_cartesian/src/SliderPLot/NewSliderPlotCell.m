function [sld, ed_xlim_inf, ed_xlim_sup, ed_ylim_inf, ed_ylim_sup] = NewSliderPlotCell(out)

fig = figure("WindowStyle","normal");
ax = axes(fig);
cb = colorbar(ax);

fig.WindowKeyPressFcn  = @(~,event)KeyPressed(event);

ax.XLim = [min(out.msh.xn),max(out.msh.xn)];
ax.YLim = [min(out.msh.yn),max(out.msh.yn)];
addlistener(ax, 'XLim', 'PostSet', @(src, event) AxisEqual3D(ax));
addlistener(ax, 'YLim', 'PostSet', @(src, event) AxisEqual3D(ax));

AxCbProperties()

global_m_value = 0;
global_max_Uk_val = 0;
Ngas = out.p.PRESSURE/(out.p.TEMPERATURE*kB);
i_specific_cell = -1;
out_pp_k = struct;
patch_handle = gobjects(1,1);

quiver_trisurf = gobjects(1,1);
main_plot = gobjects(1,1);

fig2 = gobjects(1,1);
cell_txt = gobjects(1,1);
E_txt = gobjects(1,1);
Rho_txt = gobjects(1,1);
N_txt = gobjects(1,1);
O_txt = gobjects(1,1);
K_txt = gobjects(1,1);
R_txt = gobjects(1,1);
popmen_species = gobjects(1,1);
popmen_reactions = gobjects(1,1);

popmen = uicontrol(fig, ...
    'Style','popupmenu', ...
    'String',InitializeCmbboxList(out), ...
    'Units','normalized', ...
    'Position',[0.3 0.95 0.4 0.04], ...
    'Value',1,...
    'Callback',@(src,~)UpdatedMainCmbbox(src));

[init_visible,init_list] = InitializeSpecificCmbboxList(popmen.Value,out.ns);
popmen_specific = uicontrol(fig, ...
    'Style','popupmenu', ...
    'String',init_list, ...
    'Units','normalized', ...
    'Position',[0.705 0.95 0.15 0.04], ...
    'Visible',init_visible,...
    'Callback',@(src,~)UpdatedSpecificCmbbox);

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',numel(out.tout), 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ...
    'Callback', @(src,~)UpdateTimeInstant(round(src.Value)));

tgl_btn_scale = uicontrol(fig, ...
    'Style','togglebutton', ...
    'String','lin', ...
    'Units','normalized', ... 
    'Value',0,...
    'Position',[0.01 0.95 0.03 0.04], ...
    'Callback',@(src,~)tgl_btn_pressed(src));

uicontrol(fig, ...
    'Style','pushbutton', ...
    'String','<|>', ...
    'Units','normalized', ... 
    'Position',[0.01 0.905 0.03 0.04], ...
    'Callback',@(src,~)restore_full_view);

uicontrol(fig, ...
    'Style','edit', ...
    'String',0,...
    'Units','normalized', ... 
    'Position',[0.05 0.95 0.04 0.04],...
    'Callback',@(src,~)UpdatedMvalue(src));

tgl_btn_mesh = uicontrol(fig,'Style','togglebutton', ...
    'String','off', ...
    'Units','normalized', ... 
    'Value',0,...
    'UserData','none',...
    'Position',[0.96 0.95 0.03 0.04], ...
    'Callback',@(src,~)tgl_btn_mesh_pressed(src));

ed_xlim_inf = [];
ed_xlim_sup = [];
ed_ylim_inf = [];
ed_ylim_sup = [];
    
    function UpdateTimeInstant(k)
        % Call this function every time the slider is moved
        global_m_value = 0;
        out_pp_k = ProcessInstant(out,k);
        PlotCell()
        if ishandle(fig2) && i_specific_cell > 0
            UpdateSpecificCell()
        end
    end

    function PlotCell()
        PlotSelected(popmen.Value)
        if i_specific_cell > 0
            DrawSelectedCell()
        end
    end

    function SetColorBarLimits(Uk)
        if max(Uk) ~= min(Uk)
            clim(ax,[min(Uk), max(Uk)])
        else
            if max(Uk) ~= 0
                clim(ax,min(Uk)+[-1,1]*1e-3*abs(max(Uk)))
            else
                clim(ax,[-1,1])
            end
        end
    end

    function tgl_btn_pressed(src)
        if src.Value == 1
            src.String = "log";
        else
            src.String = "lin";
        end
        PlotCell()
    end

    function tgl_btn_mesh_pressed(src)
        if src.Value == 1
            src.String = "on";
            src.UserData = 'k';
        else
            src.String = "off";
            src.UserData = 'none';
        end
        PlotCell()
    end

    function restore_full_view
        ax.XLim = [min(out.msh.xn),max(out.msh.xn)];
        ax.YLim = [min(out.msh.yn),max(out.msh.yn)];
    end

    function KeyPressed(event)
        if event.Key == "i"
            pt = ax.CurrentPoint;
            [~,i_specific_cell] = min((out.msh.xc - pt(1,1)).^2 + (out.msh.yc - pt(1,2)).^2);
            DrawSelectedCell()
            if ~ishandle(fig2)
                [fig2,cell_txt,E_txt,Rho_txt,N_txt,O_txt,K_txt,R_txt,popmen_species,popmen_reactions] = InitializeCellInspector(out.s_names, out.reactions);
                popmen_species.Callback = @(src,~)UpdateSpecificCell;
                popmen_reactions.Callback = @(src,~)UpdateSpecificCell;
            end
            UpdateSpecificCell()
        elseif event.Key == "x"
            i_specific_cell = -1;
            delete(patch_handle)
        end
    end

    function DrawSelectedCell()
        delete(patch_handle)
        patch_handle = patch('XData',out.msh.xn(out.msh.ns_from_c(i_specific_cell,:)),...
            'YData', out.msh.yn(out.msh.ns_from_c(i_specific_cell,:)),...
            'ZData', [1,1,1]*(global_max_Uk_val+(1e-10)*abs(global_max_Uk_val)), "FaceAlpha",0.4, "PickableParts","none");
    end

    function UpdateSpecificCell()
        is = popmen_species.Value;
        ir = popmen_reactions.Value;
        cell_txt.String = sprintf("%d",i_specific_cell);
        E_txt.String = sprintf("%.3e, %.2f", ...
            sqrt(out_pp_k.EX_CELLS(i_specific_cell).^2 + out_pp_k.EY_CELLS(i_specific_cell).^2),...
            sqrt(out_pp_k.EX_CELLS(i_specific_cell).^2 + out_pp_k.EY_CELLS(i_specific_cell).^2)*1e21/Ngas);
        Rho_txt.String = sprintf("%.3e",out_pp_k.RHO_CELLS(i_specific_cell));
        N_txt.String = sprintf("%.3e",out_pp_k.N_CELLS(i_specific_cell+(is-1)*out.msh.Nc));
        O_txt.String = sprintf("%.3e",out_pp_k.OMEGA(i_specific_cell+(is-1)*out.msh.Nc));
        K_txt.String = sprintf("%.3e",out_pp_k.RATE_COEFF(i_specific_cell,ir));
        R_txt.String = sprintf("%.3e",out_pp_k.RATES(i_specific_cell,ir));
    end

    function UpdatedMvalue(src)
        m = round(str2double(src.String));
        if m >= 0
            global_m_value = m;
            PlotCell
        end
    end

    function UpdatedMainCmbbox(src)
        global_m_value = 0;
        [visible,list] = InitializeSpecificCmbboxList(src.Value, out.ns);
        popmen_specific.Visible = visible;
        popmen_specific.String = list;
        popmen_specific.Value = 1;
        PlotCell
    end

    function UpdatedSpecificCmbbox()
        global_m_value = 0;
        PlotCell
    end

    function [] = PlotSelected(id)
        axes(ax)
        previous_xlim = ax.XLim;
        previous_ylim = ax.YLim;
        delete(main_plot)
        delete(quiver_trisurf)
        if id <= out.ns %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SPECIES
            is = id;
            if popmen_specific.Value == 1 % species cells ------------------------------------------
                Uk = out_pp_k.N_CELLS((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value);
                end
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                cb.Label.String = out.s_names(is) + " number density $(\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapTurboK)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
               
            elseif popmen_specific.Value == 2 % species nodes --------------------------------------
                Uk = out_pp_k.N_NODES((is-1)*out.msh.Nn+1:is*out.msh.Nn);
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value);
                end
                main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                    "PickableParts","none");
                shading interp
                main_plot.EdgeColor = tgl_btn_mesh.UserData;
                view(2)
                AxCbProperties()
                cb.Label.String = out.s_names(is) + " number density $(\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapTurboK)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
            elseif popmen_specific.Value == 3 % species omega --------------------------------------
                Uk = out_pp_k.OMEGA((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                cb.Label.String = out.s_names(is) + " source term $(\mathrm{m^{-3}s^{-1}})$";
                ax.ColorScale = "lin";
                ax.CLim = ax_clim;
                cb.Ticks = ticks;
                cb.TickLabels = ticklabels;
                colormap(mapCBKRY)
            end
        elseif id == out.ns + 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RHO
            if popmen_specific.Value == 1 % rho cells ----------------------------------------------
                Uk = out_pp_k.RHO_CELLS;
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                end
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapCBKRY)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
            elseif popmen_specific.Value == 2 % rho nodes ------------------------------------------
                Uk = out_pp_k.RHO_NODES;
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                end
                main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                    "PickableParts","none");
                shading interp
                main_plot.EdgeColor = tgl_btn_mesh.UserData;
                view(2)
                AxCbProperties()
                cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapCBKRY)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
            end
        elseif id == out.ns + 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PHI
            Uk = out_pp_k.PHI_NODES;
            main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                "PickableParts","none");
            shading interp
            main_plot.EdgeColor = tgl_btn_mesh.UserData;
            view(2)
            AxCbProperties()
            cb.Label.String = "electric potential $(\mathrm{V})$";
            ax.ColorScale = "lin";
            cb.TicksMode = 'auto';
            cb.TickLabelsMode = 'auto';
            SetColorBarLimits(Uk)
            colormap("parula")
        elseif id == out.ns + 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% E
            if popmen_specific.Value == 1 % E cells ------------------------------------------------
                Uk = sqrt(out_pp_k.EX_CELLS.^2 + out_pp_k.EY_CELLS.^2);
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                cb.Label.String = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
                ax.ColorScale = tgl_btn_scale.String;
                SetColorBarLimits(Uk)
                cb.TicksMode = 'auto';
                cb.TickLabelsMode = 'auto';
                colormap("parula")
            elseif popmen_specific.Value == 2 % E nodes --------------------------------------------
                Uk = sqrt(out_pp_k.EX_NODES.^2 + out_pp_k.EY_NODES.^2);
                main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                    "PickableParts","none");
                shading interp
                main_plot.EdgeColor = tgl_btn_mesh.UserData;
                view(2)
                AxCbProperties()
                cb.Label.String = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
                ax.ColorScale = tgl_btn_scale.String;
                SetColorBarLimits(Uk)
                cb.TicksMode = 'auto';
                cb.TickLabelsMode = 'auto';
                colormap("parula")
            elseif popmen_specific.Value == 3 % E quiver -------------------------------------------
                Uk = 1;
                if tgl_btn_mesh.Value == 1
                    quiver_trisurf = trisurf(out.msh.ns_from_c, out.msh.xn, out.msh.yn, zeros(size(out.msh.yn)),...
                        "FaceColor","w",...
                        "EdgeColor",[0.7 0.7 0.7],...
                        "LineWidth",0.25,...
                        "EdgeAlpha",0.2,...
                        "PickableParts","none");
                    view(2)
                    hold on
                end
                ii = (out.msh.xf > previous_xlim(1) & out.msh.xf < previous_xlim(2)) & ...
                    (out.msh.yf > previous_ylim(1) & out.msh.yf < previous_ylim(2));
                main_plot = quiver(out.msh.xf(ii), out.msh.yf(ii), out_pp_k.EX(ii), out_pp_k.EY(ii), "Color",[13,69,26]/255);
                main_plot.PickableParts = "none";
                hold off
            end
        elseif id == out.ns + 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FX
            if popmen_specific.Value == 1 % fx cells -----------------------------------------------
                Uk = out_pp_k.RHO_CELLS .* out_pp_k.EX_CELLS;
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                end
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapCBKRY)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
            elseif popmen_specific.Value == 2 % fx nodes -------------------------------------------
                Uk = out_pp_k.RHO_NODES .* out_pp_k.EX_NODES;
                if tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                end
                main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                    "PickableParts","none");
                shading interp
                main_plot.EdgeColor = tgl_btn_mesh.UserData;
                view(2)
                AxCbProperties()
                cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
                ax.ColorScale = "lin";
                if tgl_btn_scale.String == "log"
                    ax.CLim = ax_clim;
                    cb.Ticks = ticks;
                    cb.TickLabels = ticklabels;
                    colormap(mapCBKRY)
                elseif tgl_btn_scale.String == "lin"
                    SetColorBarLimits(Uk)
                    cb.TicksMode = 'auto';
                    cb.TickLabelsMode = 'auto';
                    colormap("parula")
                end
            end
        else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REACTIONS
            ir = id - out.ns - 4;
            Uk = out_pp_k.RATES(:,ir);
            if tgl_btn_scale.String == "log"
                [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value);
            end
            main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                "PickableParts","none",...
                "EdgeColor",tgl_btn_mesh.UserData);
            AxCbProperties()
            cb.Label.String = "reaction rate $(\mathrm{m}^{-3}\mathrm{s}^{-1})$";
            ax.ColorScale = "lin";
            if tgl_btn_scale.String == "log"
                ax.CLim = ax_clim;
                cb.Ticks = ticks;
                cb.TickLabels = ticklabels;
                colormap(mapTurboK)
            elseif tgl_btn_scale.String == "lin"
                SetColorBarLimits(Uk)
                cb.TicksMode = 'auto';
                cb.TickLabelsMode = 'auto';
                colormap("parula")
            end
        end
        global_max_Uk_val = max(Uk);
        xlim(ax,previous_xlim)
        ylim(ax,previous_ylim)
    end

    function AxCbProperties()
        % Setting properties
        cb = colorbar(ax);
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb.TickLabelInterpreter = "latex";
        cb.Label.Interpreter = "latex";
        cb.Label.FontSize = 15;
        xlabel(ax,"x $(\mathrm{m})$", "Interpreter","latex")
        ylabel(ax,"y $(\mathrm{m})$", "Interpreter","latex")
    end
       
end