function [multi_indices_diel_interfaces, multi_indices_diel_cells, sum_diel_interfaces_fluxes_matrix, surf_charge_accum_flux_coeff] ...
    = BuildUpSurfaceCharge(msh, Surf_charge_coeff, ns, qs, e, gammaIIdiel)

coeff = zeros(size(qs));
coeff(qs>0) = Surf_charge_coeff(2); % positive ions
coeff(qs<0) = Surf_charge_coeff(3); % negative ions
coeff(1) = Surf_charge_coeff(1); % electrons

coeff_copy = coeff;
coeff_copy(qs>0) = Surf_charge_coeff(2) + gammaIIdiel;

temp_surf_charge_accum_flux_coeff = reshape((ones(msh.Nd,ns).*min(coeff,1)),[],1);

multi_indices_diel_interfaces = reshape(msh.f_from_d+(0:msh.Nf:(ns-1)*msh.Nf),[],1);
multi_indices_diel_cells = reshape(msh.cs_from_f(msh.f_from_d,1)+(0:msh.Nc:(ns-1)*msh.Nc),[],1);
I = repmat(1:msh.Nd, 1, ns);
J = 1:msh.Nd*ns;
S = e * (repelem(qs.*coeff_copy,msh.Nd));
sum_diel_interfaces_fluxes_matrix = sparse(I,J,S,msh.Nd,msh.Nd*ns);

vals = ones(msh.Nf*ns,1);
vals(multi_indices_diel_interfaces) = temp_surf_charge_accum_flux_coeff;
surf_charge_accum_flux_coeff = sparse(1:msh.Nf*ns, 1:msh.Nf*ns, vals, msh.Nf*ns, msh.Nf*ns);

indices_pos_ions = find(qs > 0);

I = repmat(msh.f_from_d,numel(indices_pos_ions),1);
J = msh.f_from_d + (indices_pos_ions-1)*msh.Nf;
S = -gammaIIdiel * ones(size(J));

surf_charge_accum_flux_coeff = surf_charge_accum_flux_coeff + sparse(I, J(:), S(:), msh.Nf*ns, msh.Nf*ns);

end
