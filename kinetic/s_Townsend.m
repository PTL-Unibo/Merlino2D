species = ["e","p","n","Neutral"];
reactions = {
    "e + Neutral -> 2e + p",    "alpha_Air(E) .* mu_Air(E) .* E/1e21";
    "e + Neutral -> n",         "eta_Air(E)   .* mu_Air(E) .* E/1e21";
    "e + p -> Neutral",         2e-7 * 1e-6; 
    "n + p -> 2Neutral",        2e-7 * 1e-6; 
    };
const_species = 4;
const_vals = Ngas;