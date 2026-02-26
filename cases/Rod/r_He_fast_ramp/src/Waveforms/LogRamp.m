function [v] = LogRamp(t,t_ramp,v0,v_end,t_start)
% t_start is set to 0 as default
if nargin < 5
    t_start = 0;
end
m = 1 / (log(t_start+t_ramp+1e-18)-log(t_start+1e-18));
q = -m * log(t_start+1e-18);
v = v0 + (v_end-v0)*((m*log(t+1e-18)+q).*(t>t_start & t<t_start+t_ramp) + (t>=t_start+t_ramp));
end
