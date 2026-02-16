function [sld, ed_xlim_inf, ed_xlim_sup, ed_ylim_inf, ed_ylim_sup] = NewSliderPlotCell(out)

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

N_CELLS = [];
REACTION_RATES = [];
E = [];

popmen = uicontrol(fig, ...
    'Style','popupmenu', ...
    'String',cmbbox_names_list, ...
    'Units','normalized', ...
    'Position',[0.3 0.95 0.4 0.04], ...
    'Value',1,...
    'Callback',@(src,~)PlotCell(round(src.Value)));

sld = uicontrol(fig, ...
    'Style','slider', ...
    'Min',1, 'Max',numel(out.tout), 'Value',1,...
    'Units','normalized', ...
    'Visible','off',...
    'Position',[0, 1, 1, 0], ......
    'Callback', @(src,~)UpdateTimeInstant(round(src.Value)));

tgl_btn = uicontrol(fig, ...
    'Style','togglebutton', ...
    'String','lin', ...
    'Units','normalized', ... 
    'Value',0,...
    'Position',[0.96 0.81 0.03 0.04], ...
    'Callback',@(src,~)tgl_btn_pressed);

% btn = uicontrol(fig, ...
%     'Style','pushbutton', ...
%     'String','global', ...
%     'Units','normalized', ... 
%     'UserData',0,...
%     'Position',[0.93 0.95 0.06 0.04], ...
%     'Callback',@(src,~)btn_pressed);
% 

% ed_clim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.86,0.05,0.04]);
% ed_clim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.9,0.05,0.04]);

ed_xlim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.89,0.01,0.05,0.04],"String",sprintf("%.2e",min(out.msh.xn)));
ed_xlim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.94,0.01,0.05,0.04],"String",sprintf("%.2e",max(out.msh.xn)));

ed_ylim_inf = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.005,0.91,0.05,0.04],"String",sprintf("%.2e",min(out.msh.yn)));
ed_ylim_sup = uicontrol(fig,"Style","edit","Units","normalized","Position",[0.005,0.95,0.05,0.04],"String",sprintf("%.2e",max(out.msh.yn)));

    
    % function PlotCell(k)
    %     UpdateTimeInstant
    %     axes(ax)
    %     patch( ...
    %         out.msh.xn(out.ns_from_c'), ...
    %         out.msh.yn(out.ns_from_c'), ...
    %         GetUk(k), ...
    %         "EdgeColor","none");
    %     inf_x = str2double(ed_xlim_inf.String);
    %     sup_x = str2double(ed_xlim_sup.String);
    %     if ~(isnan(inf_x) || isnan(sup_x))
    %         xlim(ax,[inf_x, sup_x])
    %     else
    %         xlim(ax,[min(out.msh.xn),max(out.msh.xn)])
    %     end
    %     inf_y = str2double(ed_ylim_inf.String);
    %     sup_y = str2double(ed_ylim_sup.String);
    %     if ~(isnan(inf_y) || isnan(sup_y))
    %         ylim(ax,[inf_y, sup_y])
    %     else
    %         ylim(ax,[min(out.msh.yn),max(out.msh.yn)])
    %     end
    % 
    %     cb.Label.String = label_string;
    %     ax.ColorScale = tgl_btn.String;
    %     if btn.String == "global"
    %         clim([bottom_lim, top_lim]);
    %         ed_clim_inf.String = sprintf("%.2e",bottom_lim);
    %         ed_clim_sup.String = sprintf("%.2e",top_lim);
    %     elseif btn.String == "auto"
    %         if max(u_k) ~= min(u_k)
    %             clim([min(u_k), max(u_k)])
    %             ed_clim_inf.String = sprintf("%.2e",min(u_k));
    %             ed_clim_sup.String = sprintf("%.2e",max(u_k));
    %         end
    %     elseif btn.String == "manual"
    %         inf = str2double(ed_clim_inf.String);
    %         sup = str2double(ed_clim_sup.String);
    %         if ~(isnan(inf) || isnan(sup))
    %             clim([inf, sup])
    %         end
    %     end
    %     ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
    % end


    % function btn_pressed()
    %     btn.UserData = btn.UserData + 1;
    %     btn.UserData = mod(btn.UserData,3); 
    %     switch btn.UserData
    %         case 0
    %             btn.String = "global";
    %         case 1
    %             btn.String = "auto";
    %         case 2
    %             btn.String = "manual";
    %     end
    %     PlotCell(round(sld.Value))
    % end


    function PlotCell(i)
        if i <= out.ns
            Uk = N_CELLS((i-1)*out.msh.Nc+1:i*out.msh.Nc);
            label_string = out.s_names(i) + " number density $(\mathrm{m}^{-3})$";
        elseif (i > out.ns) && (i < out.ns+numel(out.reactions))
            Uk = REACTION_RATES(:,i-out.ns);
            label_string = "reaction rate $(\mathrm{m}^{-3}\mathrm{s}^{-1})$";
        else
            if i == out.ns+numel(out.reactions)+1
                Uk = E;
                label_string = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
            elseif i == out.ns+numel(out.reactions)+2
                Uk = e*sum(out.qs.*reshape(N_CELLS,out.msh.Nc,[]),2);
                label_string = "charge density $(\mathrm{C}\mathrm{m}^{-3})$"; 
            end
        end
        axes(ax)
        patch(out.msh.xn(out.msh.ns_from_c'),out.msh.yn(out.msh.ns_from_c'),Uk,"EdgeColor","none");
        cb.Label.String = label_string;
        if max(Uk) ~= min(Uk)
            clim([min(Uk), max(Uk)])
        else
            clim(min(Uk)+[-1,1]*1e-3*abs(max(Uk)))
        end
        ax.ColorScale = tgl_btn.String;
        inf_x = str2double(ed_xlim_inf.String);
        sup_x = str2double(ed_xlim_sup.String);
        if ~(isnan(inf_x) || isnan(sup_x))
            xlim(ax,[inf_x, sup_x])
        else
            xlim(ax,[min(out.msh.xn),max(out.msh.xn)])
        end
        inf_y = str2double(ed_ylim_inf.String);
        sup_y = str2double(ed_ylim_sup.String);
        if ~(isnan(inf_y) || isnan(sup_y))
            ylim(ax,[inf_y, sup_y])
        else
            ylim(ax,[min(out.msh.yn),max(out.msh.yn)])
        end
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
    end

    function UpdateTimeInstant(k)
        [~,aux_BC_el,~,~,~,~,~,~,~,reaction_rates] = out.odefun(out.tout(k),out.yout(:,k));
        N_CELLS = out.yout(:,k);
        REACTION_RATES = reaction_rates;
        PHI_NODES(out.Dirichlet_nodes_indices) = aux_BC_el;
        PHI_NODES(out.non_Dirichlet_nodes_indices) = out.yout(out.ns*out.msh.Nc+out.msh.Nd+1:end,k);
        EX_CELLS_MATRIX = out.Phi2Ex_c * PHI_NODES';
        EY_CELLS_MATRIX = out.Phi2Ey_c * PHI_NODES';
        E = sqrt(EX_CELLS_MATRIX.^2 + EY_CELLS_MATRIX.^2);
        PlotCell(popmen.Value)
    end

    function tgl_btn_pressed()
        if tgl_btn.Value == 1
            tgl_btn.String = "log";
        else
            tgl_btn.String = "lin";
        end
        PlotCell(round(popmen.Value))
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