function [mu] = mob_el(E)
    mu = 6060*0.01*((0.01*E).^0.75)./E;
end