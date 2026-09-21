function [alpha] = reduced_alpha_Benilov(E)
alpha = 1.64e-20*exp(-680./E).*(E<186) + (1+6e6./E.^3)*5e-20.*exp(-1010./E).*(E>=186);
end
