function [I,V,VEXT] = GetAllTimeInstants(out)

nt = numel(out.tout);
V = zeros(1,nt);
VEXT = zeros(1,nt);
I = zeros(1,nt);

for k = 1:nt
    out_pp_k = ProcessInstant(out,k);
    I(k) = out_pp_k.I_TOT;
    V(k) = out_pp_k.V;
    VEXT(k) = out_pp_k.VEXT;
end

end