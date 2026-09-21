function [Get_rho_sigma_eps] = CreateGetRhoSigmaEps(qs,Nc,Nd)

ns = numel(qs);
Sum_N = [];
for i = 1:ns
    Sum_N = [Sum_N, speye(Nc)*qs(i)]; %#ok<AGROW>
end
Get_rho_sigma_eps = [[e*Sum_N, zeros(Nc,Nd)]; [zeros(Nd,Nc*ns), speye(Nd)]] / eps0;

end