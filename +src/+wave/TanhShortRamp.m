function [v] = TanhShortRamp(t,v0,v_end,p)

a = 2.09987170807013;
b = -782.592873036466e-3;

t_star = 2.2*t/p - 1.1;

if t_star < -1
    v = v0 + (a*(t_star + 1.1).^2)*(v0-v_end)/(2*b);
elseif t_star >= -1 && t_star <= 1
    v = v0 + (tanh(t_star)-b)*(v0 - v_end)/(2*b);
elseif t_star > 1 && t_star < 1.1
    v = v0 + (-a*(t_star - 1.1).^2 - 2*b)*(v0-v_end)/(2*b);
elseif t_star >= 1.1
    v = v_end;
end

end