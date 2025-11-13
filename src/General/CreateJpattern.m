function [Jpattern] = CreateJpattern(msh, qs, Kelet, Flux2N, phi2En, rho2RHS)

ns = numel(qs);
Nc = msh.Nc;
Nd = msh.Nd;

% P_full
I = [];
J = [];
for ic = 1:Nc
    jj = unique(vertcat(msh.cs_from_n{msh.ns_from_c(ic,:)}));
    J = [J; jj];
    I = [I; ic*ones(size(jj))];
end
P = sparse(I,J,ones(size(I)),Nc,Nc);

% P_sigma_n
P_sigma_n = sparse(1:Nd, ...
                   msh.cs_from_f(msh.f_from_d,1), ...
                   ones(1,Nd), ...
                   Nd, Nc);


M = spdiags(ones(Nc*ns,2*(ns-1)),[-(ns-1)*Nc:Nc:-Nc,Nc:Nc:(ns-1)*Nc],Nc*ns,Nc*ns);
for is = 1:ns
    M(1+(is-1)*Nc:is*Nc,1+(is-1)*Nc:is*Nc) = P;
end

S = repmat(P_sigma_n,1,ns);
for is = 1:ns
    if qs(is) == 0
        S(:,1+(is-1)*Nc:is*Nc) = 0;
    end
end

M = [M; S];

DnsDns = [M, zeros(ns*Nc+Nd,Nd)];

DnDphi = Flux2N*repmat(phi2En,ns,1);

DsDphi = phi2En(msh.f_from_d,:);

R = [];
for i = 1:ns
    R = [R, speye(Nc)*qs(i)]; %#ok<AGROW>
end
RS = [[R, zeros(Nc,Nd)]; [zeros(Nd,Nc*ns), speye(Nd)]];

DAE = [rho2RHS * RS, Kelet];

Jpattern = [[DnsDns,[DnDphi;DsDphi]] ; DAE];

end
