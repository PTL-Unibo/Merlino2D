function [dydt,aux_BC_el,Bfval,Ex,Ey,omega,Gamma_x,Gamma_y,I] = DaeFunc2D(t,y,Nf,Nc,Nd,Nph, ...
    multi_indices_diel_interfaces,multi_indices_diel_cells,sum_diel_interfaces_fluxes_matrix, ...
    Kelet,rho2RHS,aux2RHS,Flux2N,M_get_aux_BC_el,fBfval,i_upwind,i_n_left,i_n_right,Xmu,XFx,XFy,...
    phi2Ex,phi2Ey,aux2Ex,aux2Ey,Eint2Ec,Ngas,T,qs,BCEL_VAL,V_APPLIED,...
    fTe,fMu,fD,fKr,M,Mindices,Nindices,stoichiometric_matrix,const_omega,ns,...
    indices_faces_A,indices_cells_A,...
    indices_faces_G,indices_cells_G,v_th_x,v_th_y,indices_faces_Ge,indices_faces_Gp,gammaII, ...
    surf_charge_accum_flux_coeff, ppp, inv_ppp,...
    Gx, Gy, nx_matrix, ny_matrix,...
    Ex_1, Ey_1, g2Is, re,...
    Ks,Si2RHS,ph_coeff,indices_src_reactions_ph,CellFromNodesPh)

persistent n_left n_right
if isempty(n_left)
    n_left = zeros(Nf*ns, 1);
end
if isempty(n_right)
    n_right = zeros(Nf*ns, 1);
end

y = y(inv_ppp); % converts y into normal ordering

n_c = y(1:ns*Nc);
sigma = y(ns*Nc+1:ns*Nc+Nd);
phi = y(ns*Nc+Nd+1:end-Nph);
Sph = y(end-(Nph-1):end);

n_left(i_upwind) = n_c(i_n_left);
n_right(i_upwind) = n_c(i_n_right);

% Compute charge density
n_matrix = reshape(n_c,[],ns);
rho = e * sum(n_matrix.*qs, 2);
rho_sigma_eps = [rho; sigma] / eps0;

% Compute electric field
aux_BC_el = M_get_aux_BC_el * BCEL_VAL * V_APPLIED(t);
Ex = phi2Ex * phi + aux2Ex * aux_BC_el;
Ey = phi2Ey * phi + aux2Ey * aux_BC_el;

Ecx = Eint2Ec * Ex;
Ecy = Eint2Ec * Ey;
E_int = sqrt(Ex.^2 + Ey.^2);
E_c = sqrt(Ecx.^2 + Ecy.^2);

E_int_Td = E_int/Ngas*1e21; % in Td
E_c_Td = E_c/Ngas*1e21; % in Td

Te_int = fTe(E_int_Td);
Te_c = fTe(E_c_Td);

v_th_x(1:numel(indices_faces_Ge)) = v_th_x(1:numel(indices_faces_Ge)) .* sqrt(Te_int(indices_faces_Ge));
v_th_y(1:numel(indices_faces_Ge)) = v_th_y(1:numel(indices_faces_Ge)) .* sqrt(Te_int(indices_faces_Ge));

mu = fMu(E_int_Td,Te_int,ones(Nf,1)*T,ones(Nf,1)*Ngas);
D = fD(mu,E_int_Td,Te_int,ones(Nf,1)*T,ones(Nf,1)*Ngas);
kr = fKr(E_c_Td,Te_c,ones(Nc,1)*T,ones(Nc,1)*Ngas);

Dmatrix = spdiags(reshape(D,[],1),0,ns*Nf,ns*Nf);

ux = reshape(qs .* mu .* Ex, [], 1);
uy = reshape(qs .* mu .* Ey, [], 1);
% ux = ones(size(ux)) * 900*cos(2*pi*(1/6e-3)*t);
% uy = ones(size(uy)) * 900*sin(2*pi*(1/6e-3)*t);
u_dot_n = nx_matrix*ux + ny_matrix*uy;
u_dot_n_max = u_dot_n>0;
u_dot_n_min = ~u_dot_n_max;

Bfval = fBfval(t);

% Compute omega with matrix form 
M(1,:) = kr(:);
M(Mindices) = n_c(Nindices);
reaction_rates = reshape(prod(M),Nc,[]);
omega = reshape(reaction_rates*stoichiometric_matrix + (CellFromNodesPh*Sph).*ph_coeff + const_omega,[],1);

n_up = n_left .* u_dot_n_max + n_right .* u_dot_n_min + Xmu * Bfval;

diffusion_x = -Dmatrix * (Gx * n_c);
diffusion_y = -Dmatrix * (Gy * n_c);
Gamma_x = diffusion_x + n_up .* ux + XFx * Bfval;
Gamma_y = diffusion_y + n_up .* uy + XFy * Bfval;

Gamma_x(multi_indices_diel_interfaces) = n_c(multi_indices_diel_cells) .* ux(multi_indices_diel_interfaces) .* u_dot_n_max(multi_indices_diel_interfaces);
Gamma_y(multi_indices_diel_interfaces) = n_c(multi_indices_diel_cells) .* uy(multi_indices_diel_interfaces) .* u_dot_n_max(multi_indices_diel_interfaces);

% -> Absorbent BC ----------------------------------------------------------|
Gamma_x(indices_faces_A) = n_c(indices_cells_A) .* ux(indices_faces_A);   % |
Gamma_y(indices_faces_A) = n_c(indices_cells_A) .* uy(indices_faces_A);   % |
% --------------------------------------------------------------------------|

% -> Gorin BC -------------------------------------------------------------------------------------------------------------|
Gamma_x(indices_faces_G) = n_c(indices_cells_G) .* (0.5*v_th_x + ux(indices_faces_G) .* u_dot_n_max(indices_faces_G));    %|
Gamma_y(indices_faces_G) = n_c(indices_cells_G) .* (0.5*v_th_y + uy(indices_faces_G) .* u_dot_n_max(indices_faces_G));    %|
                                                                                                                          %|
Gamma_x(indices_faces_Ge) = ((1-re)/(1+re)) * Gamma_x(indices_faces_Ge) +...                                              %|
                                - 2/(1+re) * gammaII * sum(Gamma_x(indices_faces_Gp),2);                                  %|
Gamma_y(indices_faces_Ge) = ((1-re)/(1+re)) * Gamma_y(indices_faces_Ge) +...                                              %|
                                - 2/(1+re) * gammaII * sum(Gamma_y(indices_faces_Gp),2);                                  %|
% -------------------------------------------------------------------------------------------------------------------------|

I = g2Is * (Ex_1 .* sum(reshape(surf_charge_accum_flux_coeff*Gamma_x,Nf,ns).*qs,2) +...
            Ey_1 .* sum(reshape(surf_charge_accum_flux_coeff*Gamma_y,Nf,ns).*qs,2));

Gamma_dot_n = nx_matrix*Gamma_x + ny_matrix*Gamma_y;

% photoionization
Si = (0.03 + 0.1) .* sum(reaction_rates(:,indices_src_reactions_ph),2);

dndt = -Flux2N*surf_charge_accum_flux_coeff*Gamma_dot_n + omega;
dsdt = sum_diel_interfaces_fluxes_matrix*Gamma_dot_n(multi_indices_diel_interfaces);
phi_dae = Kelet * phi - rho2RHS * rho_sigma_eps - aux2RHS * aux_BC_el;
ph_ioniz_dae = Ks*Sph - Si2RHS*Si;

dydt = [dndt; dsdt; phi_dae; ph_ioniz_dae];

dydt = dydt(ppp); % converts dydt into ordering to "diagonalize" the Jacobian 

end
