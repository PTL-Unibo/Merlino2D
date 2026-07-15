reactions = {
    'e + Ar(gnd) -> e + Ar(*)',                             'k_exc_of_Ar(E)'; % excitation
    'e + Ar(gnd) -> e + e + Ar(+,gnd)',                     'k_iz_of_Ar(E)'; % iz from gs
    'e + Ar(*) -> e + e + Ar(+,gnd)',                       'k_iz_of_Ars(E)'; % iz from exc
    'e + Ar(*) -> e + Ar(gnd)',                             'k_de_exc(E)'; % de-exc
    'e + Ar(+,gnd) -> Ar(*)',                               '4E-13*Te^-0.5 * 1E-6'; % G6
    'e + e + Ar(+,gnd) -> Ar(*) + e',                       '5E-27*Te^-4.7 * 1E-12'; % G7
    'e + Ar2(+,X) -> Ar(*) + Ar(gnd)',                      '5.38E-8*Te^-0.66 * 1E-6'; % G8 % ALTERNATIVE: '6E-7*Loki_Te^-0.76*1E-6' or '5.38E-8*Loki_Te^-0.66 * 1E-6' %
    'Ar(*) + Ar(*) -> Ar(+,gnd) + Ar(gnd) + e',             5E-10 * 1E-6; % G9
    'Ar2(*) + Ar2(*) -> Ar2(+,X) + Ar(gnd) + Ar(gnd) + e',  5E-10 * 1E-6; % G10
    'Ar(*) + Ar(gnd) + Ar(gnd) -> Ar2(*) + Ar(gnd)',        1.14E-32 * 1E-12; % G11
    'Ar(+,gnd) + Ar(gnd) + Ar(gnd) -> Ar2(+,X) + Ar(gnd)',  2.5E-31 * 1E-12; % G12
    'Ar2(*) -> Ar(gnd) + Ar(gnd)',                          6E7; % G13 problematic in Snoeckx model
    'e + Ar2(*) -> e + e + Ar2(+,X)',                       '9.00E-14 * Te^0.7 * exp(-3.66 / Te)'; % G14 RAMSES: '9.00E-14 * Loki_Te^0.7 * exp(-3.66 / Loki_Te)' DECONIK: '9E-88*Loki_Te^0.7 * exp(-3.66/Loki_Te) * 1E-6'
    'e + Ar2(*) -> e + Ar(gnd) + Ar(gnd)',                  1E-7 * 1E-6; % G15
};