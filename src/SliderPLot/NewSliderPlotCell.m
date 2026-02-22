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

cmbbox_names_list = cell(1,out.ns+numel(out.reactions)+2);
for j = 1:out.ns
    cmbbox_names_list{j} = char(out.s_names(j));
end
jj = 1;
for j = (out.ns+1):(out.ns+numel(out.reactions))
    cmbbox_names_list{j} = char(out.reactions(jj));
    jj = jj + 1;
end
cmbbox_names_list{out.ns+numel(out.reactions)+1} = 'E';
cmbbox_names_list{out.ns+numel(out.reactions)+2} = 'Rho';

Ngas = out.p.PRESSURE/(out.p.TEMPERATURE*kB);
i_specific_cell = -1;
out_pp_k = struct;
patch_handle = gobjects(1,1);

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
    'String',cmbbox_names_list, ...
    'Units','normalized', ...
    'Position',[0.3 0.95 0.4 0.04], ...
    'Value',1,...
    'Callback',@(src,~)PlotCell);

popmen_specific = uicontrol(fig, ...
    'Style','popupmenu', ...
    'String',{"cell","nodes","omega"}, ...
    'Units','normalized', ...
    'Position',[0.75 0.95 0.2 0.04], ...
    'Value',1,...
    'Callback',@(src,~)PlotCell);

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
        out_pp_k = ProcessInstant(out,k);
        PlotCell()
        if ishandle(fig2) && i_specific_cell > 0
            UpdateSpecificCell()
        end
    end

    function PlotCell()
        axes(ax)
        previous_xlim = ax.XLim;
        previous_ylim = ax.YLim;

        PlotSelected(popmen.Value)
        % [Uk,cb.Label.String] = SelectWhatPlot(popmen.Value);
        % ax.ColorScale = tgl_btn_scale.String;
        % patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,"EdgeColor",tgl_btn_mesh.UserData,"PickableParts","none");
        % SetColorBarLimits(Uk)

        if i_specific_cell > 0
            DrawSelectedCell()
        end
        xlim(ax,previous_xlim)
        ylim(ax,previous_ylim)
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
        patch_handle = patch(out.msh.xn(out.msh.ns_from_c(i_specific_cell,:)), out.msh.yn(out.msh.ns_from_c(i_specific_cell,:)), [1 0 0], "FaceAlpha",0.5, "PickableParts","none");
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

    % function [Uk,label_string] = SelectWhatPlot(i)
    %     if i <= out.ns
    %         Uk = out_pp_k.N_CELLS((i-1)*out.msh.Nc+1:i*out.msh.Nc);
    %         label_string = out.s_names(i) + " number density $(\mathrm{m}^{-3})$";
    %     elseif (i > out.ns) && (i <= out.ns+numel(out.reactions))
    %         Uk = out_pp_k.RATES(:,i-out.ns);
    %         label_string = "reaction rate $(\mathrm{m}^{-3}\mathrm{s}^{-1})$";
    %     else
    %         if i == out.ns+numel(out.reactions)+1
    %             Uk = sqrt(out_pp_k.EX_CELLS.^2 + out_pp_k.EY_CELLS.^2);
    %             Uk = Uk * 1e21 / Ngas;
    %             label_string = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
    %         elseif i == out.ns+numel(out.reactions)+2
    %             Uk = out_pp_k.RHO_CELLS;
    %             label_string = "charge density $(\mathrm{C}\mathrm{m}^{-3})$"; 
    %         end
    %     end
    % end

    function [] = PlotSelected(id)
        if id <= out.ns % species-------------------------------------------------------------------
            is = id;
            if popmen_specific.Value == 1 || popmen_specific.Value == 2
                delete(main_plot)
                if popmen_specific.Value == 1
                    Uk = out_pp_k.N_CELLS((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                    main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                        "PickableParts","none",...
                        "EdgeColor",tgl_btn_mesh.UserData);
                elseif popmen_specific.Value == 2
                    Uk = out_pp_k.N_NODES((is-1)*out.msh.Nn+1:is*out.msh.Nn);
                    main_plot = trisurf(out.msh.ns_from_c,out.msh.xn,out.msh.yn,Uk,...
                        "PickableParts","none");
                    shading interp
                    main_plot.EdgeColor = tgl_btn_mesh.UserData;
                    view(2)
                end
                AxCbProperties()
                ax.ColorScale = tgl_btn_scale.String;
                cb.Label.String = out.s_names(is) + " number density $(\mathrm{m}^{-3})$";
                cb.TicksMode = 'auto';
                cb.TickLabelsMode = 'auto';
                SetColorBarLimits(Uk)
                if tgl_btn_scale.String == "lin"
                    colormap("parula")
                elseif tgl_btn_scale.String == "log"
                    colormap("turbo")
                end
            elseif popmen_specific.Value == 3
                Uk = out_pp_k.OMEGA((is-1)*out.msh.Nc+1:is*out.msh.Nc);
                [Uk,ticks,ticklabels,ax_clim] = CreateNegativeLogPlot(Uk,10);
                delete(main_plot)
                main_plot = patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,...
                    "PickableParts","none",...
                    "EdgeColor",tgl_btn_mesh.UserData);
                AxCbProperties()
                ax.ColorScale = "log";
                ax.CLim = ax_clim;
                cb.Label.String = out.s_names(is) + " source term $(\mathrm{m^{-3}s^{-1}})$";
                cb.Ticks = ticks;
                cb.TickLabels = ticklabels;
                colormap(mapCBKRY)
            end
        elseif id == out.ns + 1 % rho---------------------------------------------------------------
        elseif id == out.ns + 2 % phi---------------------------------------------------------------
        elseif id == out.ns + 3 % E-----------------------------------------------------------------
        elseif id == out.ns + 4 % f-----------------------------------------------------------------
        elseif id == out.ns + 5 % msh---------------------------------------------------------------
        else % reactions----------------------------------------------------------------------------
        end
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