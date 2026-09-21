function [dv] = DLinRampExt(t,t_ramp,v0,v_end)
t_start = 10*1e-10;
dv = v0 * ((1/1e-10) * exp(-t/1e-10)) + (v_end-v0)*(1/t_ramp .* (t>t_start & t<t_start+t_ramp));
end