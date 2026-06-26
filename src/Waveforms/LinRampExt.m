function [v] = LinRampExt(t,t_ramp,v0,v_end)
t_start = 10*1e-10;
v = v0 * (1 - exp(-t/1e-10))  + (v_end-v0)*((t-t_start)/t_ramp .* (t>t_start & t<t_start+t_ramp) + (t>=t_start+t_ramp));
end