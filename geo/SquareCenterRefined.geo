SetFactory("OpenCASCADE");

MSH_SIZE = 2e-1;
MSH_SIZE_CENTER = 1e-3;
DIM = 10;

P_A = newp;
Point(P_A) = {-DIM, -DIM, 0, MSH_SIZE};
P_B = newp;
Point(P_B) = {DIM, -DIM, 0, MSH_SIZE};
P_C = newp;
Point(P_C) = {DIM, DIM, 0, MSH_SIZE};
P_D = newp;
Point(P_D) = {-DIM, DIM, 0, MSH_SIZE};
P_O = newp;
Point(P_O) = {0, 0, 0, MSH_SIZE_CENTER};
P_K = newp;
Point(P_K) = {0, -DIM, 0, MSH_SIZE};
P_H = newp;
Point(P_H) = {0, DIM, 0, MSH_SIZE};

L_AK = newl;
Line(L_AK) = {P_A, P_K};
L_KB = newl;
Line(L_KB) = {P_K, P_B};
L_BC = newl;
Line(L_BC) = {P_B, P_C};
L_CH = newl;
Line(L_CH) = {P_C, P_H};
L_HD = newl;
Line(L_HD) = {P_H, P_D};
L_DA = newl;
Line(L_DA) = {P_D, P_A};
L_KO = newl;
Line(L_KO) = {P_K, P_O};
L_OH = newl;
Line(L_OH) = {P_O, P_H};

CL_1 = newll;
Curve Loop(CL_1) = {L_AK, L_KO, L_OH, L_HD, L_DA};

CL_2 = newll;
Curve Loop(CL_2) = {L_KB, L_BC, L_CH, -L_OH, -L_KO};

S_1 = news;
Plane Surface(S_1) = {CL_1};

S_2 = news;
Plane Surface(S_2) = {CL_2};

Physical Curve(1) = {L_AK, L_KB, L_BC, L_CH, L_HD, L_DA};
Physical Surface(1) = {S_1, S_2};

Point{P_O} In Surface{S_1};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "SquareCenterRefined.m";