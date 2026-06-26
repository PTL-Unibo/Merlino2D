function [v] = TanhRamp(t,v0,v_end,p)
v = v0 + ((v_end-v0)/1.999329299739067)*(0.999329299739067+tanh((t-4*(p/8))/(p/8)));
end