function [pseudo_log,tck_val,tkz_lbl,scale_lim] = CreateNegativeLogPlot(u,m)
    lim = max(log10(abs(u)));
    int_pos_lim = floor(lim);
    log10_zero_val = int_pos_lim - 1 - m;

    scale_lim = [2*log10_zero_val-lim, lim];

    u(abs(u)<(10^log10_zero_val)) = 10^log10_zero_val;
    lii_neg = u <= 0;
    lii_pos = ~lii_neg;

    tck_val = 2*log10_zero_val-int_pos_lim:int_pos_lim;
    dim = numel(tck_val);
    
    u(abs(u)<(10^log10_zero_val)) = 10^log10_zero_val;
    pseudo_log = zeros(size(u));
    pseudo_log(lii_pos) = log10(u(lii_pos));
    pseudo_log(lii_neg) =  2*log10_zero_val - log10(-u(lii_neg));

    tkz_lbl = cell(dim,1);
    for i = 1:(dim-1)/2
        tkz_lbl{i} = "$-10^{" + tck_val(dim+1-i) + "}$";
        tkz_lbl{dim+1-i} = "$+10^{" + tck_val(dim+1-i) + "}$";
    end
    tkz_lbl{(dim+1)/2} = "$0$";

    pseudo_log = 10.^pseudo_log;
    tck_val = 10.^tck_val;
    scale_lim = 10.^scale_lim;

    % if too many ticks
    max_allowed_dim = 20;
    halve_times = floor(log(dim/max_allowed_dim)/log(2)+1);
    for cont = 1:halve_times
        dim = numel(tck_val);
        i_to_remove = [2:2:((dim-1)/2), flip((dim-1):-2:(1+(dim+1)/2))];
        tkz_lbl(i_to_remove) = [];
        tck_val(i_to_remove) = [];
    end
end