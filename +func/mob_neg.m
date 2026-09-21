function [mu] = mob_neg(E)
    mu = 2.7*0.01*((0.01*E).^1)./E;
end