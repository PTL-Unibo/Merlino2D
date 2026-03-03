MSH = "Square";
BCEL_FLAG = [0;0;0;0];
BCEL_VAL = [0;0;0;0];
V_APPLIED = @(t) 0;
BC_FLAG = {'N',{"FreeDriftFlow",'FreeDriftFlow',"FreeDriftFlow","FreeDriftFlow"}};
BC_VAL = {"N", {0, 0, 0, 0}};
TIME_INSTANTS = linspace(0,6e-3,601);
INITIAL_CONDITION.A = 1e10;
INITIAL_CONDITION.B = 0;
INITIAL_CONDITION.x0 = 0;
INITIAL_CONDITION.y0 = -900*6e-3/(2*pi);
INITIAL_CONDITION.sigma_x = sqrt(5e-3);
INITIAL_CONDITION.sigma_y = sqrt(5e-3);
SPECIES_NO_CHEM = 'N';
MU = {'N',0};
D = {"N",0};
V_TH_COEFF = {"N",1};
CONST_OMEGA = {'N',0};
OUTPUT_FUNCTION = "cmd";
% Uncomment lines 56 and 57 in DaeFunc2D.m:
% ux = ones(size(ux)) * 900*cos(2*pi*(1/6e-3)*t);
% uy = ones(size(uy)) * 900*sin(2*pi*(1/6e-3)*t);
% BE CAREFUL!! COMMENT THEM AGAIN AFTER!!
