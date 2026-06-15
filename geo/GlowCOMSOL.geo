SetFactory("OpenCASCADE");

HEIGHT = 0.05;
WIDTH = 0.4;
H_ELECTRODE = 0.0375;
W_ELECTRODE = 6E-3;
DELTA = 0.01;

If (!Exists(r))
  r = 8e-4;
EndIf
CURVE_RADIUS = r;

MESH_SIZE = 1e-3;

P_A = newp;
Point(P_A) = {0,0,0,MESH_SIZE};
P_B = newp;
Point(P_B) = {DELTA,0,0,MESH_SIZE};
P_C1 = newp;
Point(P_C1) = {DELTA,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_C2 = newp;
Point(P_C2) = {DELTA+CURVE_RADIUS,H_ELECTRODE,0,MESH_SIZE};
P_D1 = newp;
Point(P_D1) = {DELTA+W_ELECTRODE-CURVE_RADIUS,H_ELECTRODE,0,MESH_SIZE};
P_D2 = newp;
Point(P_D2) = {DELTA+W_ELECTRODE,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_E = newp;
Point(P_E) = {DELTA+W_ELECTRODE,0,0,MESH_SIZE};
P_F = newp;
Point(P_F) = {WIDTH-DELTA-W_ELECTRODE,0,0,MESH_SIZE};
P_G1 = newp;
Point(P_G1) = {WIDTH-DELTA-W_ELECTRODE,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_G2 = newp;
Point(P_G2) = {WIDTH-DELTA-W_ELECTRODE+CURVE_RADIUS,H_ELECTRODE,0,MESH_SIZE};
P_H1 = newp;
Point(P_H1) = {WIDTH-DELTA-CURVE_RADIUS,H_ELECTRODE,0,MESH_SIZE};
P_H2 = newp;
Point(P_H2) = {WIDTH-DELTA,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_I = newp;
Point(P_I) = {WIDTH-DELTA,0,0,MESH_SIZE};
P_J = newp;
Point(P_J) = {WIDTH,0,0,MESH_SIZE};
P_K = newp;
Point(P_K) = {WIDTH,HEIGHT,0,MESH_SIZE*2};
P_L = newp;
Point(P_L) = {0,HEIGHT,0,MESH_SIZE*2};

P_O1 = newp;
Point(P_O1) = {DELTA+CURVE_RADIUS,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_O2 = newp;
Point(P_O2) = {DELTA+W_ELECTRODE-CURVE_RADIUS,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_O3 = newp;
Point(P_O3) = {WIDTH-DELTA-W_ELECTRODE+CURVE_RADIUS,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};
P_O4 = newp;
Point(P_O4) = {WIDTH-DELTA-CURVE_RADIUS,H_ELECTRODE-CURVE_RADIUS,0,MESH_SIZE};

L_A_B = newl;
Line(L_A_B) = {P_A, P_B};
L_B_C1 = newl;
Line(L_B_C1) = {P_B, P_C1};
Lc_C1_C2 = newl;
Circle(Lc_C1_C2) = {P_C1, P_O1, P_C2};
L_C2_D1 = newl;
Line(L_C2_D1) = {P_C2, P_D1};
Lc_D1_D2 = newl;
Circle(Lc_D1_D2) = {P_D1, P_O2, P_D2};
L_D2_E = newl;
Line(L_D2_E) = {P_D2, P_E};
L_E_F = newl;
Line(L_E_F) = {P_E, P_F};
L_F_G1 = newl;
Line(L_F_G1) = {P_F, P_G1};
Lc_G1_G2 = newl;
Circle(Lc_G1_G2) = {P_G1, P_O3, P_G2};
L_G2_H1 = newl;
Line(L_G2_H1) = {P_G2, P_H1};
Lc_H1_H2 = newl;
Circle(Lc_H1_H2) = {P_H1, P_O4, P_H2};
L_H2_I = newl;
Line(L_H2_I) = {P_H2, P_I};
L_I_J = newl;
Line(L_I_J) = {P_I, P_J};
L_J_K = newl;
Line(L_J_K) = {P_J, P_K};
L_K_L = newl;
Line(L_K_L) = {P_K, P_L};
L_L_A = newl;
Line(L_L_A) = {P_L, P_A};
CL_gas = newll;
Curve Loop(CL_gas) = {L_A_B, L_B_C1, Lc_C1_C2, L_C2_D1, Lc_D1_D2, L_D2_E, L_E_F, L_F_G1, Lc_G1_G2, L_G2_H1, Lc_H1_H2, L_H2_I, L_I_J, L_J_K, L_K_L, L_L_A};

Delete { Point{P_O1}; }
Delete { Point{P_O2}; }
Delete { Point{P_O3}; }
Delete { Point{P_O4}; }

S_gas = news;
Plane Surface(S_gas) = {CL_gas};

Physical Surface(1) = {S_gas};

Physical Curve(1) = {L_B_C1, Lc_C1_C2, L_C2_D1, Lc_D1_D2, L_D2_E}; // anode
Physical Curve(2) = {L_F_G1, Lc_G1_G2, L_G2_H1, Lc_H1_H2, L_H2_I}; // cathode
Physical Curve(3) = {L_A_B, L_E_F, L_I_J, L_J_K, L_K_L, L_L_A}; // walls

Mesh 2;
Mesh.MshFileVersion = 2;
Save "GlowCOMSOL.m";
