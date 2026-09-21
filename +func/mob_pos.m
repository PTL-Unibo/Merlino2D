function [mu] = mob_pos(E)
    mu = 2.34*0.01*((0.01*E).^1)./E;
end