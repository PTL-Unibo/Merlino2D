function [v] = DLinRamp(t,t_ramp,v0,v_end,t_start)
% t_start is set to 0 as default
if nargin < 5
    t_start = 0;
end
v = 0.*(t<t_start) + ((v_end-v0)/t_ramp) .* (t>t_start & t<t_start+t_ramp) + 0.*(t>=t_start+t_ramp);
end