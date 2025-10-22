reactions = {
    "e + M -> 2e + I+",     "Loki_alpha(E) .* Loki_mu(E) .* E/1e21";
    "e + M -> I-",          "Loki_eta(E)   .* Loki_mu(E) .* E/1e21";
    "e + I+ -> M",          2e-7 * 1e-6; 
    "I- + I+ -> 2M",        2e-7 * 1e-6; 
    };
const_species = {
    "M", Ngas
    };