DIM = 1.1*1.2;
MSH_SIZE = 1.8e-2;

P_A = newp;
Point(P_A) = {-DIM, -DIM, 0, MSH_SIZE};
P_B = newp;
Point(P_B) = {DIM, -DIM, 0, MSH_SIZE};
P_C = newp;
Point(P_C) = {DIM, DIM, 0, MSH_SIZE};
P_D = newp;
Point(P_D) = {-DIM, DIM, 0, MSH_SIZE};

L_AB = newl;
Line(L_AB) = {P_A, P_B};
L_BC = newl;
Line(L_BC) = {P_B, P_C};
L_CD = newl;
Line(L_CD) = {P_C, P_D};
L_DA = newl;
Line(L_DA) = {P_D, P_A};

CL_1 = newll;
Curve Loop(CL_1) = {L_AB, L_BC, L_CD, L_DA};

S_1 = news;
Plane Surface(S_1) = {CL_1};

Physical Curve(1) = {L_AB};
Physical Curve(2) = {L_BC};
Physical Curve(3) = {L_CD};
Physical Curve(4) = {L_DA};

Physical Surface(1) = {S_1};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "Square.m";