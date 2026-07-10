reactions = {
    'e + Ar -> e + e + Arp',          'k_Ar_ion(E)';
    'e + Ar -> e + Ars',              'k_Ar_exc(E)';
    'e + Ars -> e + e + Arp',         'k_Ars_ion(E)';
    'Ars + Ars -> e + Arp + Ar',      "1.2e-9 * (300 / T)^(1/2) * 1e-6";
    'Arp + Ar + Ar -> Ar2p + Ar',     "2.5e-31 * (300 / T)^(3/2) * 1e-12";
    'e + Ar2p -> Ars + Ar',           "7e-7 * (300 / Te)^(1/2) * 1e-6";
    'Ars -> Ar',                      5e5;
};