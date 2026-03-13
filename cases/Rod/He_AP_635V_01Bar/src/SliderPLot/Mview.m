function Mview(out,types_array)

num_figs = numel(types_array);

axes_array = gobjects(1, sum(ismember(types_array,"2"),2));
axes_array_sigma = gobjects(1, sum(ismember(types_array,"s"),2));
sld_array = gobjects(1, num_figs);
old_cb_cell = cell(1, num_figs);

cont_2 = 1;
cont_s = 1;
for k = 1:num_figs    
    if types_array(k) == "2"
        [sld_array(k), axes_array(cont_2)] = SliderPlot2D(out);
        cont_2 = cont_2 + 1;
    elseif types_array(k) == "s"
        [sld_array(k), axes_array_sigma(cont_s)] = SliderPlotSigma(out);
        cont_s = cont_s + 1;
    end
    sld_array(k).UserData = k;
    old_cb_cell{k} = sld_array(k).Callback;
    sld_array(k).Callback = @(src,~) MasterSliderCallBack(src);
end
if numel(axes_array) > 0
    linkaxes(axes_array,"xy")
    if numel(axes_array_sigma) > 0
        linkaxes([axes_array_sigma, axes_array(1)],"x")
    end
end
MasterSliderCallBack(sld_array(1));

    function MasterSliderCallBack(sld)
        feval(old_cb_cell{sld.UserData}, sld, [])
        for i = 1:numel(sld_array)
            if i ~= sld.UserData
                sld_array(i).Value = sld.Value; 
                feval(old_cb_cell{i}, sld_array(i), [])
            end
        end
    end

end
