function [] = DrawMesh(msh, OD)
% OD is a vector that contains Ox, Oy, Rx, Ry

if ~exist('OD', 'var')
    max_x = max(msh.xn);
    min_x = min(msh.xn);
    dx = max_x - min_x;
    xlimits = [min_x-0.05*dx, max_x+0.05*dx];
    max_y = max(msh.yn);
    min_y = min(msh.yn);
    dy = max_y - min_y;
    ylimits = [min_y-0.05*dy, max_y+0.05*dy];
else
    xlimits = [OD(1)-OD(3), OD(1)+OD(3)];
    ylimits = [OD(2)-OD(4), OD(2)+OD(4)];
end

figure
trisurf(msh.ns_from_c, msh.xn, msh.yn, zeros(size(msh.xn)),'FaceColor','w')
view([0,90])
hold on

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

axis equal
xlim(xlimits)
ylim(ylimits)

end
