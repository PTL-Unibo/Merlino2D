function Mview(out,num_figs)
arguments
    out 
    num_figs (1,1) = 1
end

if num_figs == 1
    single_slider = MviewCore(out);
    feval(single_slider.Callback, single_slider, [])
else
    axes_array = gobjects(1, num_figs);
    sld_array = gobjects(1, num_figs);
    old_cb_cell = cell(1, num_figs);
    
    for k = 1:num_figs
        [sld_array(k), axes_array(k)] = MviewCore(out);
        sld_array(k).UserData = k;
        old_cb_cell{k} = sld_array(k).Callback;
        sld_array(k).Callback = @(src,~) MasterSliderCallBack(src);
    end
    linkaxes(axes_array,"xy")
    MasterSliderCallBack(sld_array(1));
end

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
