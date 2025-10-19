species = ["e","p","n","Neutral"];
reactions = {
    "e + Neutral -> 2e + p",    "Loki_alpha(E) .* Loki_mu(E) .* E/1e21";
    "e + Neutral -> n",         "Loki_eta(E)   .* Loki_mu(E) .* E/1e21";
    "e + p -> Neutral",         2e-7 * 1e-6; 
    "n + p -> 2Neutral",        2e-7 * 1e-6; 
    };
const_species = 4;
const_vals = Ngas;