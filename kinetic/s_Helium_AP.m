reactions = {
    % gs iz
    'e + He(gnd) -> e + e + He(+,gnd)',                                     'k_He_iz(E)'; % R1
    % metastable iz
    'e + He(*) -> e + e + He(+,gnd)',                                       'k_iz_from_meta(E)'; % --- k_iz_from_meta(E(t)) % R2 - ok Shon 1994
    % dissociative recombination
    'e + He2(+,X) -> He(gnd) + He(*)',                                      5e-15; % R3 - ok Shon 1994
    % recombination
    'e + He2(+,X) -> He2(*)',                                               '5E-15*T/(11600*Te)'; % R4
    'e + He(gnd) -> e + He(*)',                                             'k_He_exc(E)'; % R5
    'e + e + He(+,gnd) -> e + He(*)',                                       6e-32; % from Martens PhD, original is: 1E-38/(Te^(9/2)) R6 p.60 Smirnov Theory of Gas Discharges - ok Martens 2009 R5
    % added
    % 'e + e + He2(+,X) -> e + He(*) + He(gnd)'                               '6E-32'; % from Martens PhD, original is: 1E-38/(Te^(9/2)) R6 p.60 Smirnov Theory of Gas Discharges - ok Martens 2009 R5
    % -----
    % 'e + He(+,gnd) + He(gnd) -> He(gnd) + He(*)'                            '1E-38*(Te/T)^-2'; % R7 (<< R6)
    % three-body association
    'He(gnd) + He(gnd) + He(+,gnd) -> He2(+,X) + He(gnd)',                  1e-43; % R8 - ok Shon 1994
    'He(gnd) + He(gnd) + He(*) -> He2(*) + He(gnd)',                        '8.1E-48*T*exp(-650/T)'; % R9 - ok Martens 2009 R15
    'e + He(gnd) + He2(+,X) -> He2(*) + He(gnd)',                           '5E-39*T/(11600*Te)'; % R10 (duplicato di R4)
    % Penning 1
    'He2(*) + He(*) -> He(+,gnd) + e + He(gnd) + He(gnd)',                  '0.3 * 2.9E-15*sqrt(T/(11600*0.025))'; % R11
    'He2(*) + He(*) -> He2(+,X) + e + He(gnd)',                             '0.7 * 2.9E-15*sqrt(T/(11600*0.025))'; % R12
    % Penning 2
    'He(*) + He(*) -> He(+,gnd) + e + He(gnd)',                             '0.3 * 2.9E-15*sqrt(T/(11600*0.025))'; % R13 - ok Martens 2009 R16
    'He(*) + He(*) -> He2(+,X) + e',                                        '0.7 * 2.9E-15*sqrt(T/(11600*0.025))'; % R14 - ok Martens 2009 R17
    % Penning 3
    'He2(*) + He2(*) -> He(+,gnd) + e + He(gnd) + He(gnd) + He(gnd)',       '0.3 * 2.9E-15*sqrt(T/(11600*0.025))'; % R15
    'He2(*) + He2(*) -> He2(+,X) + e + He(gnd) + He(gnd)',                  '0.7 * 2.9E-15*sqrt(T/(11600*0.025))'; % R16 - ok Martens 2009 R20
    % mol metastable iz
    'e + He2(*) -> e + e + He2(+,X)',                                       '9.75E-16*Te^0.71*exp(-3.4/Te)'; % R17
    % metastable de-exc
    'e + He(*) -> e + He(gnd)',                                             'k_He_exc_superel(E)'; % R18
    % mol metastable de-exc
    'e + He2(*) -> e + He(gnd) + He(gnd)',                                  3.8e-15; % R19
    };