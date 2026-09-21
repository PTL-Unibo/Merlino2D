function [dv] = DTanhShortRamp(t,v0,v_end,p)

a = 2.09987170807013;
b = -782.592873036466e-3;

t_star = 2.2*t/p - 1.1;

if t_star < -1
    dv = a*2*(t_star+1.1)*(v0-v_end)/(2*b);
elseif t_star >= -1 && t_star <= 1
    dv = (sech(t_star)^2)*(v0-v_end)/(2*b);
elseif t_star > 1 && t_star < 1.1
    dv = -2*a*(t_star-1.1)*(v0-v_end)/(2*b);
elseif t_star >= 1.1
    dv = 0;
end

dv = dv * 2.2/p;

end