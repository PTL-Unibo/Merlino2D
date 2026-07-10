p = 0.5;
bb = out.msh.bs_from_bID{1};
ff = out.msh.f_from_b(bb);
out_pp_k = ProcessInstant(out,numel(out.tout));
E_mod = sqrt(out_pp_k.EX(ff).^2 + out_pp_k.EY(ff).^2);
fprintf("E/p = %f kV/(mm*atm)\n",mean(E_mod)/p/1e6)