function [beta] = beta_Benilov(E,Te,T)
T_O2p = T + 0.054*E.^2;
T_O4p = T + 0.037*E.^2;
z = 3.9286e-8*(T_O4p.^4)./(T_O2p.^3.2).*exp(5030./T_O4p);
beta = (2e-13*(300./(Te*11600)).^0.7 + 4e-12*z.*(300./(Te*11600)).^0.5)./(1+z);
end
