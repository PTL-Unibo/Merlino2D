function [I,V] = GetAllTimeInstants(out)

nt = numel(out.tout);
V = zeros(1,nt);
I = zeros(1,nt);

for k = 1:nt
    out_pp_k = ProcessInstant(out,k);
    I(k) = out_pp_k.I_SATO;
    V(k) = out_pp_k.VAPP;
end

end