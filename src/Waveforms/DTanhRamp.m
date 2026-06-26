function [dv] = DTanhRamp(t,v0,v_end,p)
dv = ((v_end-v0)/1.999329299739067) * (sech((t-4*(p/8))/(p/8))).^2 / (p/8);
end