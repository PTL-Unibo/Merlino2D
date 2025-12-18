reactions = {
        % 1)
       "e + N2 -> 2e + N2+",                "reduced_alpha_Benilov(E) * Loki_mu(E) * E/1e21"; 
       "e + O2 -> 2e + O2+",                "reduced_alpha_Benilov(E) * Loki_mu(E) * E/1e21";
        % 2)
       "e + O2 -> O- + O",                  "reduced_eta_Benilov(E) * Loki_mu(E) * E/1e21";
        % 3)
       "e + O2 + O2 -> O2- + O2",           "1.6e-47*E^(-1.1) * Loki_mu(E) * E/1e21";
       "e + O2 + N2 -> O2- + N2",           "1.6e-47*E^(-1.1) * Loki_mu(E) * E/1e21";
        % 5)
       "O2- + O2 -> e + O2 + O2",           "1.24e-17*(exp(-179/(8.8+E)))^2";
       "O2- + N2 -> e + O2 + N2",           "1.24e-17*(exp(-179/(8.8+E)))^2";
        % 6)
       "O- + N2 -> e + N2O",                "1.16e-18*(exp(-48.9/(11+E)))^2";
        % 7)
       "O- + O2 -> O + O2-",                "6.96e-17*(exp(-198/(5.6+E)))^2";
        % 8)
       "O- + O2 + O2 -> O3- + O2",          "1.1e-42*(exp(-E/65))^2";
       "O- + O2 + N2 -> O3- + N2",          "1.1e-42*(exp(-E/65))^2";
       };