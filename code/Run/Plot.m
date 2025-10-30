function [ax] = Plot(out_pp,opts)
arguments
    out_pp
    opts.type (1,:) char {mustBeMember(opts.type,{ ...
        'nc', ...
        'nn', ...
        'rhoc', ...
        'rhon', ...
        'phi', ...
        'v-i', ...
        'Ec', ...
        '|Ec|', ...
        '|En|', ...
        't-iv', ...
        't-Fx', ...
        'fxc', ...
        'fxc_log', ...
        'fxn', ...
        'fxn_log', ...
        'rhon_log', ...
        'sigma', ...
        'msh'
        })} = 'nc'
    opts.ax = -1
    opts.species_index = 1;
    opts.k = out_pp.nt
    opts.flip_y (1,1) double {mustBeMember(opts.flip_y,[0,1])} = 0
    opts.log10_zero_val = 2;
end

if opts.ax == -1
    fig = figure;
    ax = axes(fig);
else
    ax = opts.ax;
end

switch opts.type
    case "nc" % cell number density
        nk = (out_pp.N_CELLS((opts.species_index-1)*out_pp.Nc+1:opts.species_index*out_pp.Nc,opts.k));
        patch( ...
            out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
            out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
            nk, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            patch( ...
                out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
                -out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
                nk, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.ColorScale = "log";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(nk), max(nk)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = out_pp.S_NAMES(opts.species_index) + " number density $(\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
    
    case "rhoc" % cell charge density
        rhok = out_pp.RHO_CELLS(:,opts.k);
        patch( ...
            out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
            out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
            rhok, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            patch( ...
                out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
                -out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
                rhok, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(rhok), max(rhok)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;

    case "nn" % nodes number density
        nk = (out_pp.N_NODES((opts.species_index-1)*out_pp.Nn+1:opts.species_index*out_pp.Nn,opts.k));
        trisurf( ...
            out_pp.link_cell_to_nodes, ...
            out_pp.x_nodes, ...
            out_pp.y_nodes, ...
            nk, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf( ...
                out_pp.link_cell_to_nodes, ...
                out_pp.x_nodes, ...
                -out_pp.y_nodes, ...
                nk, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        ax.ColorScale = "log";
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(nk), max(nk)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = out_pp.S_NAMES(opts.species_index) + " number density $(\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
    
    case "rhon" % nodes charge density
        rhok = out_pp.RHO_NODES(:,opts.k);
        trisurf( ...
            out_pp.link_cell_to_nodes, ...
            out_pp.x_nodes, ...
            out_pp.y_nodes, ...
            rhok, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf( ...
                out_pp.link_cell_to_nodes, ...
                out_pp.x_nodes, ...
                -out_pp.y_nodes, ...
                rhok, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(rhok), max(rhok)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;

    case "phi" % electric potential
        phik = out_pp.PHI_NODES(:,opts.k);
        trisurf( ...
            out_pp.link_cell_to_nodes, ...
            out_pp.x_nodes, ...
            out_pp.y_nodes, ...
            phik, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf( ...
                out_pp.link_cell_to_nodes, ...
                out_pp.x_nodes, ...
                -out_pp.y_nodes, ...
                phik, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(phik), max(phik)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "electric potential $(\mathrm{V})$";
        cb.Label.FontSize = 15;

    case "Ec" % cell electric field
        Exk = out_pp.EX_CELLS_MATRIX(:,opts.k);
        Eyk = out_pp.EY_CELLS_MATRIX(:,opts.k);
        quiver(out_pp.x_cells, out_pp.y_cells, Exk, Eyk, "Color",ax.ColorOrder(1,:));
        axis equal
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            quiver(out_pp.x_cells, -out_pp.y_cells, Exk, -Eyk, "Color",ax.ColorOrder(1,:));
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;

    case "|Ec|" % cell electric field module
        Ek = sqrt(out_pp.EX_CELLS_MATRIX(:,opts.k).^2 + out_pp.EY_CELLS_MATRIX(:,opts.k).^2);
        patch( ...
            out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
            out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
            Ek, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            patch( ...
                out_pp.x_nodes(out_pp.link_cell_to_nodes'), ...
                -out_pp.y_nodes(out_pp.link_cell_to_nodes'), ...
                Ek, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(Ek), max(Ek)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
        cb.Label.FontSize = 15;

    case "|En|" % nodes electric field module
        Ek = sqrt(out_pp.EX_NODES_MATRIX(:,opts.k).^2 + out_pp.EY_NODES_MATRIX(:,opts.k).^2);
        trisurf( ...
            out_pp.link_cell_to_nodes, ...
            out_pp.x_nodes, ...
            out_pp.y_nodes, ...
            Ek, ...
            "EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf( ...
                out_pp.link_cell_to_nodes, ...
                out_pp.x_nodes, ...
                -out_pp.y_nodes, ...
                Ek, ...
                "EdgeColor","none");
            hold off
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(Ek), max(Ek)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "electric field $(\mathrm{V}\mathrm{m}^{-1})$";
        cb.Label.FontSize = 15;
        
    case "v-i" % V-I curve
        if opts.flip_y
            plot(ax, out_pp.V(2:end), out_pp.I_SATO(2:end)*2, ".-", "MarkerSize",15, "LineWidth",2)
        else
            plot(ax, out_pp.V(2:end), out_pp.I_SATO(2:end), ".-", "MarkerSize",15, "LineWidth",2)
        end
        xlabel("voltage $(\mathrm{V})$", "Interpreter","latex")
        ylabel("current $(\mathrm{A}\mathrm{m}^{-1})$", "Interpreter","latex")
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        grid on

    case "t-iv"
        yyaxis left
        if opts.flip_y
            plot(out_pp.tout, out_pp.I_SATO*2, ".-")
            ylim([-max(abs(out_pp.I_SATO*2))*1.1,max(abs(out_pp.I_SATO*2))*1.1])
        else
            plot(out_pp.tout, out_pp.I_SATO, ".-")
            ylim([-max(abs(out_pp.I_SATO))*1.1,max(abs(out_pp.I_SATO))*1.1])
        end
        ylabel("current $(\mathrm{A}\mathrm{m}^{-1})$", "Interpreter","latex")
        yyaxis right
        plot(out_pp.tout, out_pp.V)
        ylim([-max(abs(out_pp.V))*1.05,max(abs(out_pp.V))*1.05])
        ylabel("voltage $(\mathrm{V})$", "Interpreter","latex")
        grid on
        xlim([out_pp.tout(1), out_pp.tout(end)])
        xlabel("time $(\mathrm{s})$", "Interpreter","latex")
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;

    case "t-Fx"
        fx = sum(out_pp.msh.vol .* (out_pp.RHO_CELLS .* out_pp.EX_CELLS_MATRIX));
        yyaxis left
        plot(ax,out_pp.tout, fx)
        ylim([-max(abs(fx))*1.1,max(abs(fx))*1.1])
        ylabel("$x$-axis force $(\mathrm{N}\mathrm{m}^{-1})$", "Interpreter","latex")
        yyaxis right
        plot(out_pp.tout, out_pp.V)
        ylabel("voltage $(\mathrm{V})$", "Interpreter","latex")
        grid on
        xlim([out_pp.tout(1), out_pp.tout(end)])
        xlabel("time $(\mathrm{s})$", "Interpreter","latex")
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;

    case "fxc"
        fxk = out_pp.RHO_CELLS(:,opts.k) .* out_pp.EX_CELLS_MATRIX(:,opts.k);
        patch(out_pp.x_nodes(out_pp.link_cell_to_nodes'), out_pp.y_nodes(out_pp.link_cell_to_nodes'), fxk, "EdgeColor","none")
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            patch(out_pp.x_nodes(out_pp.link_cell_to_nodes'), -out_pp.y_nodes(out_pp.link_cell_to_nodes'), fxk, "EdgeColor","none")
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
            hold off
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(fxk), max(fxk)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;

    case "fxc_log"
        fxk = out_pp.RHO_CELLS(:,opts.k) .* out_pp.EX_CELLS_MATRIX(:,opts.k);
        fxk(abs(fxk)<(10^opts.log10_zero_val)) = 10^opts.log10_zero_val;
        lii_neg = fxk <= 0;
        lii_pos = ~lii_neg;
        max_pos = max(log10(fxk(lii_pos)));
        max_neg = max(log10(-fxk(lii_neg)));
        lim = max([max_pos, max_neg]);
        vals = floor(lim):-1:(opts.log10_zero_val+1);
        dim = 2*numel(vals) + 1;
        tkz_lbl = cell(dim,1);
        for i = 1:numel(vals)
            tkz_lbl{i} = "$-10^" + vals(i) + "$";
            tkz_lbl{dim+1-i} = "$+10^" + vals(i) + "$";
        end
        tkz_lbl{numel(vals)+1} = "$0$";
        tkz = (opts.log10_zero_val-(floor(lim)-opts.log10_zero_val)):floor(lim);
        pseudo_log = zeros(size(fxk));
        pseudo_log(lii_pos) = log10(fxk(lii_pos));
        pseudo_log(lii_neg) = opts.log10_zero_val + (opts.log10_zero_val - log10(-fxk(lii_neg)));
        patch(out_pp.x_nodes(out_pp.link_cell_to_nodes'), out_pp.y_nodes(out_pp.link_cell_to_nodes'), pseudo_log, "EdgeColor","none")
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            patch(out_pp.x_nodes(out_pp.link_cell_to_nodes'), -out_pp.y_nodes(out_pp.link_cell_to_nodes'), pseudo_log, "EdgeColor","none")
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
            hold off
        end
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        colormap(mapCBKRY)
        clim([opts.log10_zero_val+(opts.log10_zero_val-lim), lim]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
        cb.Ticks = tkz;
        cb.TickLabels = tkz_lbl;

    case "fxn"
        fxk = out_pp.RHO_NODES(:,opts.k) .* out_pp.EX_NODES_MATRIX(:,opts.k);
        trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,out_pp.y_nodes,fxk,"EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,-out_pp.y_nodes,fxk,"EdgeColor","none");
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
            hold off
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        clim([min(fxk), max(fxk)]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;

    case "fxn_log"
        fxk = out_pp.RHO_NODES(:,opts.k) .* out_pp.EX_NODES_MATRIX(:,opts.k);
        fxk(abs(fxk)<(10^opts.log10_zero_val)) = 10^opts.log10_zero_val;
        lii_neg = fxk <= 0;
        lii_pos = ~lii_neg;
        max_pos = max(log10(fxk(lii_pos)));
        max_neg = max(log10(-fxk(lii_neg)));
        lim = max([max_pos, max_neg]);
        vals = floor(lim):-1:(opts.log10_zero_val+1);
        dim = 2*numel(vals) + 1;
        tkz_lbl = cell(dim,1);
        for i = 1:numel(vals)
            tkz_lbl{i} = "$-10^" + vals(i) + "$";
            tkz_lbl{dim+1-i} = "$+10^" + vals(i) + "$";
        end
        tkz_lbl{numel(vals)+1} = "$0$";
        tkz = (opts.log10_zero_val-(floor(lim)-opts.log10_zero_val)):floor(lim);
        pseudo_log = zeros(size(fxk));
        pseudo_log(lii_pos) = log10(fxk(lii_pos));
        pseudo_log(lii_neg) = opts.log10_zero_val + (opts.log10_zero_val - log10(-fxk(lii_neg)));
        trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,out_pp.y_nodes,pseudo_log,"EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,-out_pp.y_nodes,pseudo_log,"EdgeColor","none");
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
            hold off
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        colormap(mapCBKRY)
        clim([opts.log10_zero_val+(opts.log10_zero_val-lim), lim]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "$x$-axis force density $(\mathrm{N}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
        cb.Ticks = tkz;
        cb.TickLabels = tkz_lbl;

      case "rhon_log"
        rhok = out_pp.RHO_NODES(:,opts.k);
        rhok(abs(rhok)<(10^opts.log10_zero_val)) = 10^opts.log10_zero_val;
        lii_neg = rhok <= 0;
        lii_pos = ~lii_neg;
        max_pos = max(log10(rhok(lii_pos)));
        max_neg = max(log10(-rhok(lii_neg)));
        lim = max([max_pos, max_neg]);
        vals = floor(lim):-1:(opts.log10_zero_val+1);
        dim = 2*numel(vals) + 1;
        tkz_lbl = cell(dim,1);
        for i = 1:numel(vals)
            tkz_lbl{i} = "$-10^{" + vals(i) + "}$";
            tkz_lbl{dim+1-i} = "$+10^{" + vals(i) + "}$";
        end
        tkz_lbl{numel(vals)+1} = "$0$";
        tkz = (opts.log10_zero_val-(floor(lim)-opts.log10_zero_val)):floor(lim);
        pseudo_log = zeros(size(rhok));
        pseudo_log(lii_pos) = log10(rhok(lii_pos));
        pseudo_log(lii_neg) = opts.log10_zero_val + (opts.log10_zero_val - log10(-rhok(lii_neg)));
        trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,out_pp.y_nodes,pseudo_log,"EdgeColor","none");
        xlim(ax,[min(out_pp.x_nodes),max(out_pp.x_nodes)])
        ylim(ax,[min(out_pp.y_nodes),max(out_pp.y_nodes)])
        if opts.flip_y
            hold on
            trisurf(out_pp.link_cell_to_nodes,out_pp.x_nodes,-out_pp.y_nodes,pseudo_log,"EdgeColor","none");
            ylim(ax,[-max(abs(out_pp.y_nodes)),max(abs(out_pp.y_nodes))])
            hold off
        end
        shading interp
        view([0,90])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        ylabel("y $(\mathrm{m})$", "Interpreter","latex")
        ax.PlotBoxAspectRatio = [(ax.XLim(2)-ax.XLim(1))/(ax.YLim(2)-ax.YLim(1)), 1, 1];
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
        cb = colorbar("TickLabelInterpreter","latex");
        colormap(mapCBKRY)
        clim([opts.log10_zero_val+(opts.log10_zero_val-lim), lim]);
        cb.Label.Interpreter = "latex";
        cb.Label.String = "charge density $(\mathrm{C}\mathrm{m}^{-3})$";
        cb.Label.FontSize = 15;
        cb.Ticks = tkz;
        cb.TickLabels = tkz_lbl;

    case "sigma"
        sigmak = out_pp.SIGMA(:,opts.k);
        x = out_pp.msh.xf(out_pp.msh.f_from_d);
        plot(ax,x, sigmak)
        ylim([min(sigmak), max(sigmak)])
        ylabel("surface charge density $(\mathrm{C}\mathrm{m}^{-2})$", "Interpreter","latex")
        xlim([min(x), max(x)])
        xlabel("x $(\mathrm{m})$", "Interpreter","latex")
        grid on
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;

    case "msh"
        trisurf(out_pp.link_cell_to_nodes, out_pp.x_nodes, out_pp.y_nodes, zeros(size(out_pp.x_nodes)))
        view(2)
        AxisEqual3D
       
end
