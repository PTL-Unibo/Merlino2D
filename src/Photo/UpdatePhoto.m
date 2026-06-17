function [Sph_nodes] = UpdatePhoto(y,t,p)
global Sph %#ok<GVMIS>

y = y(p.inv_ppp); % converts y into normal ordering
n_c = y(1:p.ns*p.Nc);
phi = y(p.ns*p.Nc+p.Nd+1:end-2);

% Compute electric field in Td
Ecx = p.phi2Ex * phi;
Ecy = p.phi2Ey * phi;
E_c_Td = sqrt(Ecx.^2 + Ecy.^2)/p.Ngas*1e21;

Te_c = p.fTe(E_c_Td);
kr = p.fKr(E_c_Td,Te_c,ones(p.Nc,1)*p.T,ones(p.Nc,1)*p.Ngas);

% Compute reaction rates with matrix form 
p.M(1,:) = kr(:);
p.M(p.Mindices) = n_c(p.Nindices);
reaction_rates = reshape(prod(p.M),p.Nc,[]);
E_c_Td(E_c_Td == 0) = 1e-3;
Si = (0.03 + 15.7./E_c_Td) .* sum(reaction_rates(:,p.indices_src_reactions_ph),2);
Sph_nodes = p.Ks \ (p.Si2RHS*(Si+1e5));
Sph = p.CellFromNodesPh * Sph_nodes;
Sph_nodes = sum(reshape(Sph_nodes,p.Nn,3),2);

end