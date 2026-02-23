function [u,tck_val,tck_lbl,scale_lim] = CreateLogPlot(u,m)

ii_zero = (u == 0);
ii_non_zero = ~ii_zero;

u = log10(u);
original_down_lim_val = min(u(ii_non_zero));
original_int_top_lim_val = floor(max(u));
if original_down_lim_val + m >= original_int_top_lim_val
    m = 0;
end

log10_zero_val = original_down_lim_val + m;

u(u>(-Inf) & u<=log10_zero_val) = log10_zero_val;

max_val = max(u);
min_val = min(u(ii_non_zero));

int_top_lim_val = floor(max_val);
int_down_lim_val = ceil(min_val);

zero_val = min_val - (max_val - min_val)*0.05;

original_tck = int_down_lim_val:int_top_lim_val;
original_dim = numel(original_tck);

% if too many ticks
max_allowed_dim = 20;
halve_times = floor(log(original_dim/max_allowed_dim)/log(2)+1);
skip_step = max(2^halve_times,1);
indices_1 = 1:skip_step:((original_dim+1)/2);
indices_2 = flip(original_dim:(-skip_step):((original_dim+1)/2));

i1 = indices_1(end);
i2 = indices_2(1);
if (i2-i1)>0 && (i2-i1)<skip_step/2
    indices_1(end) = [];
    indices_2(1) = [];
end

keep_indices = [indices_1,indices_2];
final_tck = unique(original_tck(keep_indices));

tck_val = [zero_val, final_tck];
dim = numel(tck_val);
tck_lbl = cell(dim,1);
tck_lbl{1} = "0";
for i = 2:dim
    tck_lbl{i} = "$10^{" + tck_val(i) + "}$";
end
scale_lim = [zero_val, max_val];

u(ii_zero) = zero_val;

end