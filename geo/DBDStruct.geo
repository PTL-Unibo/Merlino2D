SetFactory("OpenCASCADE");

If (!Exists(k))
  k = 2e-4;
EndIf
MESH_SIZE = k;

If (!Exists(kd))
  kd = 1e-6;
EndIf
LMS_DIEL_INT = kd;

If (!Exists(g))
  g = 0;  
EndIf
INTERELECTRODE_GAP = g;

If (!Exists(wd))
  wd = 0.495e-3;  
EndIf
WIDTH_DIELECTRIC = wd;

If (!Exists(w))
  w = 1e-5;  
EndIf
WIDTH_ANODE = w;

If (!Exists(h))
  h = 2e-3;
EndIf
TOTAL_H = h; 

If (!Exists(lc))
  lc = 3e-3;
EndIf
LENGTH_CATODE = lc;

If (!Exists(la))
  la = 1e-3;
EndIf
LENGTH_ANODE = la;

If (!Exists(r))
  r = 3e-6;
EndIf
CURV_RADIUS = r;

If (!Exists(n))
  n = 3000;
EndIf
N_STRUCT_HORIZONTAL = n;

If (!Exists(nv))
  nv = 5;
EndIf
N_STRUCT_VERTICAL = nv;

If (!Exists(p))
  p = 1.001;
EndIf
PROG = p;

H_STRUCT = LMS_DIEL_INT;
L0 = LENGTH_CATODE / ((1 - PROG^(N_STRUCT_HORIZONTAL)) / (1 - PROG));

P_A = newp;
Point(P_A) = {0,0,0,MESH_SIZE};
P_B = newp;
Point(P_B) = {LENGTH_ANODE+INTERELECTRODE_GAP,0,0,MESH_SIZE};
P_C = newp;
Point(P_C) = {LENGTH_ANODE+LENGTH_CATODE,0,0,MESH_SIZE};
P_D = newp;
Point(P_D) = {LENGTH_ANODE+LENGTH_CATODE,WIDTH_DIELECTRIC,0,LMS_DIEL_INT};
P_E = newp;
Point(P_E) = {LENGTH_ANODE+LENGTH_CATODE,TOTAL_H,0,MESH_SIZE};
P_F = newp;
Point(P_F) = {0,TOTAL_H,0,MESH_SIZE};
P_G = newp;
Point(P_G) = {0,WIDTH_DIELECTRIC+WIDTH_ANODE,0,MESH_SIZE};
P_H = newp;
Point(P_H) = {LENGTH_ANODE-CURV_RADIUS,WIDTH_DIELECTRIC+WIDTH_ANODE,0,L0};
P_I = newp;
Point(P_I) = {LENGTH_ANODE,WIDTH_DIELECTRIC+WIDTH_ANODE-CURV_RADIUS,0,L0};
P_Z = newp;
Point(P_Z) = {LENGTH_ANODE,WIDTH_DIELECTRIC+H_STRUCT,0,L0};
P_J = newp;
Point(P_J) = {LENGTH_ANODE,WIDTH_DIELECTRIC,0,LMS_DIEL_INT};
P_K = newp;
Point(P_K) = {0,WIDTH_DIELECTRIC,0,MESH_SIZE};
P_L = newp;
Point(P_L) = {LENGTH_ANODE+LENGTH_CATODE,WIDTH_DIELECTRIC+H_STRUCT,0,L0*PROG^(N_STRUCT_HORIZONTAL-1)};

P_center = newp;
Point(P_center) = {LENGTH_ANODE-CURV_RADIUS,WIDTH_DIELECTRIC+WIDTH_ANODE-CURV_RADIUS,0,MESH_SIZE};

L_A_B = newl;
Line(L_A_B) = {P_A, P_B};
L_B_C = newl;
Line(L_B_C) = {P_B, P_C};
L_C_D = newl;
Line(L_C_D) = {P_C, P_D};
L_D_L = newl;
Line(L_D_L) = {P_D, P_L};
L_L_E = newl;
Line(L_L_E) = {P_L, P_E};
L_E_F = newl;
Line(L_E_F) = {P_E, P_F};
L_F_G = newl;
Line(L_F_G) = {P_F, P_G};
L_G_H = newl;
Line(L_G_H) = {P_G, P_H};
Lc_H_I = newl;
Circle(Lc_H_I) = {P_H, P_center, P_I};
L_I_Z = newl;
Line(L_I_Z) = {P_I, P_Z};
L_Z_J = newl;
Line(L_Z_J) = {P_Z, P_J};
L_J_K = newl;
Line(L_J_K) = {P_J, P_K};
L_K_A = newl;
Line(L_K_A) = {P_K, P_A};

L_Z_L = newl;
Line(L_Z_L) = {P_Z, P_L};
L_J_D = newl;
Line(L_J_D) = {P_J, P_D};

Delete { Point{P_center}; }

CL_air_unstruct = newll;
Curve Loop(CL_air_unstruct) = {L_L_E, L_E_F, L_F_G, L_G_H, Lc_H_I, L_I_Z, L_Z_L};

CL_air_struct = newll;
Curve Loop(CL_air_struct) = {L_Z_J, L_J_D, L_D_L, -L_Z_L};

CL_diel = newll;
Curve Loop(CL_diel) = {L_J_K, L_K_A, L_A_B, L_B_C, L_C_D, -L_J_D};

S_air_unstruct = news;
Plane Surface(S_air_unstruct) = {CL_air_unstruct};
S_air_struct = news;
Plane Surface(S_air_struct) = {CL_air_struct};

S_diel = news;
Plane Surface(S_diel) = {CL_diel};

Transfinite Curve {L_Z_L,L_J_D} = N_STRUCT_HORIZONTAL Using Progression PROG;
Transfinite Curve {L_Z_J,L_D_L} = N_STRUCT_VERTICAL Using Progression 1;
Transfinite Surface {S_air_struct};

Physical Surface(1) = {S_air_unstruct, S_air_struct};
Physical Surface(2) = {S_diel};

Physical Curve(1) = {L_Z_J, L_J_K}; // anode 1
Physical Curve(2) = {L_G_H, Lc_H_I, L_I_Z}; // anode 2
Physical Curve(3) = {L_B_C}; // cathode 1
Physical Curve(4) = {L_A_B}; // cathode 2
Physical Curve(5) = {L_F_G, L_K_A}; // west
Physical Curve(6) = {L_C_D, L_D_L, L_L_E}; // east
Physical Curve(7) = {L_E_F}; // north
Physical Curve(1000) = {L_J_D}; // dielectric interface

Mesh 2;
Mesh.MshFileVersion = 2;
Save "DBDStruct.m";