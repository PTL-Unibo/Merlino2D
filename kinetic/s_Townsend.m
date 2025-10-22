reactions = {
    "e + M -> 2e + I+",     "alpha_Air(E) .* mu_Air(E) .* E/1e21";
    "e + M -> I-",          "eta_Air(E)   .* mu_Air(E) .* E/1e21";
    "e + I+ -> M",          2e-7 * 1e-6; 
    "I- + I+ -> 2M",        2e-7 * 1e-6; 
    };
const_species = {
    "M", Ngas
    };