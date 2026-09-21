function [eta] = reduced_eta_Benilov(E)
eta = 3.44e-23*exp(-1.05*(abs(5.3-log(E))).^3);
end
