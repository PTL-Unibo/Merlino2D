function [I_s, C_s, Ex_1, Ey_1, g2Is] = ComputeStaticSato(start_time, end_time, BCEL_VAL, V_APPLIED, DV_APPLIED, EPSR_VAL, M_get_aux_BC_el, Kelet_d, aux2RHS,...
    Dirichlet_nodes_indices, non_Dirichlet_nodes_indices, Phi2Ex_c, Phi2Ey_c,...
    phi2Ex, phi2Ey, aux2Ex, aux2Ey, cID_from_c, full_vol, eps0, e, Eint2Ec, vol)

dirichlet_nodes_1 = M_get_aux_BC_el * BCEL_VAL;
phi1 = Kelet_d \ (aux2RHS * dirichlet_nodes_1);
phi_full_1(Dirichlet_nodes_indices,:) = dirichlet_nodes_1;
phi_full_1(non_Dirichlet_nodes_indices,:) = phi1;
Ec_full_1_x = Phi2Ex_c * phi_full_1;
Ec_full_1_y = Phi2Ey_c * phi_full_1;

C_s = eps0 * sum(full_vol .* EPSR_VAL(cID_from_c) .* (Ec_full_1_x.^2 + Ec_full_1_y.^2));

if isa(DV_APPLIED, 'function_handle')
    I_s = @(t) C_s * DV_APPLIED(t);
else
    time_instants = linspace(start_time,end_time,1e4);
    v_in_time = zeros(size(time_instants));
    for i = 1:numel(time_instants)
        v_in_time(i) = V_APPLIED(time_instants(i));
    end
    dvdt = MatrixDerivative(v_in_time, time_instants);
    I_s = @(t) C_s * interp1(time_instants,dvdt,t);
end

Ex_1 = phi2Ex * phi1 + aux2Ex * dirichlet_nodes_1;
Ey_1 = phi2Ey * phi1 + aux2Ey * dirichlet_nodes_1;

g2Is = e * vol' * Eint2Ec;

end
