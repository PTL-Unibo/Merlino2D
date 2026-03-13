function [sld, ax] = SliderPlot2D(out)

fig = figure("WindowStyle","normal");
ax = axes(fig);
cb = colorbar(ax);

global_colormap_resolution = 10;

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

species_global_max = zeros(1,out.ns);
species_global_min = zeros(1,out.ns);
for species_index = 1:out.ns
    all_s = out.yout((species_index-1)*out.msh.Nc+1:species_index*out.msh.Nc,:);
    species_global_max(species_index) = max(all_s,[],"all");
    species_global_min(species_index) = min(all_s(all_s>0),[],"all");
end

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
    'Min',1, 'Max',numel(out.tout), 'Value',1, 'SliderStep',[1/(numel(out.tout)-1),max(0.05,1/(numel(out.tout)-1))],...
    'Units','normalized', ...
    'Visible','on',...
    'Position',[0.2, 0.005, 0.6, 0.03], ...
    'Callback', @(src,~)UpdateTimeInstant(round(src.Value)));

lbl_indices = annotation(fig, 'textbox', ...
    [0.005 0.005, 0.19, 0.03], ...   
    'String','', ...
    'FitBoxToText','on', ...
    'EdgeColor','k', ...
    'Interpreter','latex', ...
    "HorizontalAlignment","right",...
    "VerticalAlignment","middle",...
    'FontSize',12);

lbl_time_instant = annotation(fig, 'textbox', ...
    [0.81 0.005, 0.19, 0.03], ...   
    'String','', ...
    'FitBoxToText','on', ...
    'EdgeColor','none', ...
    'Interpreter','latex', ...
    "HorizontalAlignment","left",...
    "VerticalAlignment","bottom",...
    'FontSize',12);

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

m_edit = uicontrol(fig, ...
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
    'Position',[0.96 0.9 0.03 0.04], ...
    'Callback',@(src,~)tgl_btn_mesh_pressed(src));

tgl_btn_limits = uicontrol(fig,'Style','togglebutton', ...
    'String','auto', ...
    'Units','normalized', ... 
    'Value',0,...
    'UserData','none',...
    'Position',[0.95 0.95 0.04 0.04], ...
    'Callback',@(src,~)tgl_btn_limits_pressed(src));
    
    function UpdateTimeInstant(k)
        % Call this function every time the slider is moved
        sld.Value = k;
        lbl_indices.String = num2str(k) + " / " + numel(out.tout);
        lbl_time_instant.String = sprintf("t = %.5e s", out.tout(k));
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

    function tgl_btn_pressed(src)
        if src.Value == 1
            src.String = "log";
        else
            src.String = "lin";
        end
        PlotCell()
    end

    function tgl_btn_limits_pressed(src)
        if src.Value == 1
            src.String = "global";
        else
            src.String = "auto";
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
        m_edit.String = "0";
        [visible,list] = InitializeSpecificCmbboxList(src.Value, out.ns);
        popmen_specific.Visible = visible;
        popmen_specific.String = list;
        popmen_specific.Value = 1;
        PlotCell
    end

    function UpdatedSpecificCmbbox()
        PlotCell
    end

    function SetColorBar(ax_clim,ticks,ticklabels,map_name)
        if isnan(ax_clim)
            ax.CLimMode = "auto";
        else
            ax.CLim = ax_clim;
        end
        if isnan(ticks)
            cb.TicksMode = "auto";
        else
            cb.Ticks = ticks;
        end
        if isnan(ticks)
            cb.TickLabelsMode = "auto";
        else
            cb.TickLabels = ticklabels;
        end
        if nargin > 3
            if map_name == "CBKRY"
                colormap(mapCBKRY(global_colormap_resolution))
            else
                colormap(mapAddK(map_name,global_colormap_resolution))
            end
        else
            colormap(parula(global_colormap_resolution*20))
        end
    end

    function AxCbProperties()
        AxProperties()
        CbProperties()
    end

    function AxProperties()
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        xlabel(ax,"x $(\mathrm{m})$", "Interpreter","latex")
        ylabel(ax,"y $(\mathrm{m})$", "Interpreter","latex")
    end

    function CbProperties()
        cb = colorbar(ax);
        cb.TickLabelInterpreter = "latex";
        cb.Label.Interpreter = "latex";
        cb.Label.FontSize = 15;
    end

    function MainPlot(Uk,flag)
        delete(main_plot)
        if flag == "patch"
            main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk);
            CbProperties()
        elseif flag == "trisurf"
            main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk);
            shading interp
            view(2)
            AxCbProperties()
        end
        main_plot.EdgeColor = tgl_btn_mesh.UserData;
        main_plot.PickableParts = "none";
    end

    function bool = CheckIsUniform(Uk)
        if min(Uk) == 0
            if max(Uk) == 0
                bool = true;
            else
                bool = false; 
            end
        else
            bool = abs((max(Uk)-min(Uk))/min(Uk)) < 1e-10;
        end
    end

    function LinLog(is_uniform,ax_clim,ticks,ticklabels,map_name)
        ax.ColorScale = "lin";
        if tgl_btn_scale.String == "log"
            if ~is_uniform
                SetColorBar(ax_clim,ticks,ticklabels,map_name)
            else
                SetColorBar(NaN,NaN,NaN,map_name)
            end
        else
            if tgl_btn_limits.String == "global" && popmen.Value<=out.ns && popmen_specific.Value<=2
                SetColorBar([species_global_min(popmen.Value),species_global_max(popmen.Value)],NaN,NaN)
            else
                SetColorBar(NaN,NaN,NaN)
            end
        end
    end

    function [] = PlotSelected(id)
        ax_clim = [];
        ticks = [];
        ticklabels = {};
        axes(ax)
        previous_xlim = ax.XLim;
        previous_ylim = ax.YLim;
        if id <= out.ns %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SPECIES
            is = id;
            if popmen_specific.Value == 1 || popmen_specific.Value == 2 % species cells/nodes-------
                if popmen_specific.Value == 1 
                    Uk = out_pp_k.N_CELLS((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                elseif popmen_specific.Value == 2 
                    Uk = out_pp_k.N_NODES((is-1)*out.msh.Nn+1:is*out.msh.Nn);
                end
                is_uniform = CheckIsUniform(Uk);
                if ~is_uniform && tgl_btn_scale.String == "log"
                    if tgl_btn_limits.String == "global"
                        [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value,species_global_max(is),species_global_min(is));
                    elseif tgl_btn_limits.String == "auto"
                        [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value);
                    end
                end
                if popmen_specific.Value == 1 
                    MainPlot(Uk,"patch")
                elseif popmen_specific.Value == 2 
                    MainPlot(Uk,"trisurf")
                end
                cb.Label.String = out.s_names(is) + " number density $(\mathrm{m}^{-3})$";
                LinLog(is_uniform,ax_clim,ticks,ticklabels,"turbo")
            elseif popmen_specific.Value == 3 % species omega --------------------------------------
                Uk = out_pp_k.OMEGA((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                is_uniform = CheckIsUniform(Uk);
                if ~is_uniform && tgl_btn_scale.String == "log"
                    [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
                end
                MainPlot(Uk,"patch")
                cb.Label.String = out.s_names(is) + " source term $(\mathrm{m^{-3}s^{-1}})$";
                LinLog(is_uniform,ax_clim,ticks,ticklabels,"CBKRY")
            end
        elseif id == out.ns + 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RHO
            if popmen_specific.Value == 1 % rho cells/nodes ----------------------------------------
                Uk = out_pp_k.RHO_CELLS;
            elseif popmen_specific.Value == 2 
                Uk = out_pp_k.RHO_NODES;
            end
            is_uniform = CheckIsUniform(Uk);
            if ~is_uniform && tgl_btn_scale.String == "log"
                [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
            end
            if popmen_specific.Value == 1 
                MainPlot(Uk,"patch")
            elseif popmen_specific.Value == 2 
                MainPlot(Uk,"trisurf")
            end
            cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
            LinLog(is_uniform,ax_clim,ticks,ticklabels,"CBKRY")
        elseif id == out.ns + 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PHI
            Uk = out_pp_k.PHI_NODES;
            MainPlot(Uk,"trisurf")
            cb.Label.String = "electric potential $(\mathrm{V})$";
            ax.ColorScale = "lin";
            SetColorBar(NaN,NaN,NaN)
        elseif id == out.ns + 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% E
            if popmen_specific.Value == 1 || popmen_specific.Value == 2 % E cells/nodes ------------
                if popmen_specific.Value == 1
                    Uk = sqrt(out_pp_k.EX_CELLS.^2 + out_pp_k.EY_CELLS.^2);
                    MainPlot(Uk,"patch")
                elseif popmen_specific.Value == 2
                    Uk = sqrt(out_pp_k.EX_NODES.^2 + out_pp_k.EY_NODES.^2);
                    MainPlot(Uk,"trisurf")
                end
                cb.Label.String = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
                ax.ColorScale = tgl_btn_scale.String;
                SetColorBar(NaN,NaN,NaN)
            elseif popmen_specific.Value == 3 % E quiver -------------------------------------------
                Uk = 1;
                if tgl_btn_mesh.Value == 1
                    delete(quiver_trisurf)
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
                delete(main_plot)
                main_plot = quiver(out.msh.xf(ii), out.msh.yf(ii), out_pp_k.EX(ii), out_pp_k.EY(ii), "Color",[13,69,26]/255);
                main_plot.PickableParts = "none";
                AxProperties()
                hold off
            end
        elseif id == out.ns + 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FX
            if popmen_specific.Value == 1 % fx cells/nodes -----------------------------------------
                Uk = out_pp_k.RHO_CELLS .* out_pp_k.EX_CELLS;
            elseif popmen_specific.Value == 2 
                Uk = out_pp_k.RHO_NODES .* out_pp_k.EX_NODES;
            end
            is_uniform = CheckIsUniform(Uk);
            if ~is_uniform && tgl_btn_scale.String == "log"
                [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,global_m_value);
            end
            if popmen_specific.Value == 1 
                MainPlot(Uk,"patch")
            elseif popmen_specific.Value == 2 
                MainPlot(Uk,"trisurf")
            end
            cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
            LinLog(is_uniform,ax_clim,ticks,ticklabels,"CBKRY")
        else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REACTIONS
            ir = id - out.ns - 4;
            Uk = out_pp_k.RATES(:,ir);
            is_uniform = CheckIsUniform(Uk);
            if ~is_uniform && tgl_btn_scale.String == "log"
                [Uk,ticks,ticklabels,ax_clim] = CreateLogPlot(Uk,global_m_value);
            end
            MainPlot(Uk,"patch")
            cb.Label.String = "reaction rate $(\mathrm{m}^{-3}\mathrm{s}^{-1})$";
            LinLog(is_uniform,ax_clim,ticks,ticklabels,"turbo")
        end
        global_max_Uk_val = max(Uk);
        xlim(ax,previous_xlim)
        ylim(ax,previous_ylim)
    end
       
end