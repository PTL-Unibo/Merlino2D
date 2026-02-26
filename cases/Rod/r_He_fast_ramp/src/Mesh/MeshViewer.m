function [] = MeshViewer(msh)

fig = figure();
ax = axes(fig);

addlistener(ax, 'XLim', 'PostSet', @(src, event) AxisEqual3D(ax));
addlistener(ax, 'YLim', 'PostSet', @(src, event) AxisEqual3D(ax));

flag_first = 1;

clear_pressed

uicontrol(fig, ...
    'Style','pushbutton', ...
    'String','Clear', ...
    'Units','normalized', ... 
    'Position',[0.91 0.9 0.08 0.04], ...
    'Callback',@(src,~)clear_pressed);

uicontrol(fig, ...
    'Style','pushbutton', ...
    'String','Draw mesh', ...
    'Units','normalized', ... 
    'Position',[0.91 0.95 0.08 0.04], ...
    'Callback',@(src,~)draw_mesh);

    function clear_pressed
        hold off
        if ~flag_first
            saved_lims_x = ax.XLim;
            saved_lims_y = ax.YLim;
        end
        trisurf(msh.ns_from_c, msh.xn, msh.yn, zeros(size(msh.xn)),'FaceColor','w')
        view([0,90])
        AxisEqual3D(ax)
        if ~flag_first
            xlim(saved_lims_x)
            ylim(saved_lims_y)
        end
        flag_first = 0;
    end

    function draw_mesh()
        hold on

        xlimits = ax.XLim;
        ylimits = ax.YLim;
        
        % cells
        li_c = (msh.xc<=xlimits(2) & msh.xc>=xlimits(1)) & (msh.yc<=ylimits(2) & msh.yc>=ylimits(1));
        plot(msh.xc(li_c),msh.yc(li_c),'MarkerSize',16,'Marker','square','LineStyle','none','Color',[1,0,0])
        
        % nodes
        li_n = (msh.xn<=xlimits(2) & msh.xn>=xlimits(1)) & (msh.yn<=ylimits(2) & msh.yn>=ylimits(1));
        plot(msh.xn(li_n),msh.yn(li_n),'MarkerSize',15,'Marker','.','LineStyle','none','Color',[0,0,1])
        
        % print numbers cells
        for ic = find(li_c)'
            text(msh.xc(ic), msh.yc(ic), num2str(ic))
        end
        
        d = min(diff(xlimits),diff(ylimits)) / 1e5;
        % print numbers nodes
        for in = find(li_n)'
            text(msh.xn(in)+d, msh.yn(in)+d, num2str(in))
        end
        
        % print numbers faces
        li_f = (msh.xf<=xlimits(2) & msh.xf>=xlimits(1)) & (msh.yf<=ylimits(2) & msh.yf>=ylimits(1));
        for i_f = setdiff(find(li_f)',[find(msh.cs_from_f(:,2) == 0); msh.f_from_d])'
            text(msh.xf(i_f)+d, msh.yf(i_f)+d, num2str(i_f))
        end
        
        % print numbers b
        k = 0;
        for i_f = msh.f_from_b'
            k = k + 1;
            if li_f(i_f)
                text(msh.xf(i_f)+d, msh.yf(i_f)+d, num2str(i_f)+"("+num2str(k)+")")
            end
        end
        
        % print numbers d
        k = 0;
        for i_f = msh.f_from_d'
            k = k + 1;
            if li_f(i_f)
                text(msh.xf(i_f)+d, msh.yf(i_f)+d, num2str(i_f)+"["+num2str(k)+"]")
            end
        end
        
        % disp normal to surfaces
        scale = min(diff(xlimits),diff(ylimits)) / 100;
        quiver(msh.xf(li_f), msh.yf(li_f), msh.sn(li_f,1)*scale, msh.sn(li_f,2)*scale, 0)
    
    end

end