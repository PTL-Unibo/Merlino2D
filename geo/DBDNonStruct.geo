SetFactory("OpenCASCADE");

If (!Exists(k))
  k = 0.75e-4;
EndIf
MESH_SIZE = k;

If (!Exists(kd))
  kd = 5e-6;
EndIf
LMS_DIEL_INT = kd;

If (!Exists(g))
  g = 1e-3;  
EndIf
INTERELECTRODE_GAP = g;

If (!Exists(wd))
  wd = 3e-3;  
EndIf
WIDTH_DIELECTRIC = wd;

If (!Exists(w))
  w = 70e-6;  
EndIf
WIDTH_ANODE = w;

If (!Exists(h))
  h = 6e-3;
EndIf
TOTAL_H = h; 

If (!Exists(lc))
  lc = 5e-3;
EndIf
LENGTH_CATODE = lc;

If (!Exists(la))
  la = 2e-3;
EndIf
LENGTH_ANODE = la;

If (!Exists(r))
  r = 2e-5;
EndIf
CURV_RADIUS = r;

If (!Exists(x))
  x = 6e-3;
EndIf
X_MIDDLE = x;

P_A = newp;
Point(P_A) = {0,0,0,MESH_SIZE};
P_B = newp;
Point(P_B) = {LENGTH_ANODE+INTERELECTRODE_GAP,0,0,MESH_SIZE};
P_C = newp;
Point(P_C) = {LENGTH_ANODE+LENGTH_CATODE,0,0,MESH_SIZE};
P_D = newp;
Point(P_D) = {LENGTH_ANODE+LENGTH_CATODE,WIDTH_DIELECTRIC,0,MESH_SIZE};
P_E = newp;
Point(P_E) = {LENGTH_ANODE+LENGTH_CATODE,TOTAL_H,0,MESH_SIZE};
P_F = newp;
Point(P_F) = {0,TOTAL_H,0,MESH_SIZE};
P_G = newp;
Point(P_G) = {0,WIDTH_DIELECTRIC+WIDTH_ANODE,0,MESH_SIZE};
P_H = newp;
Point(P_H) = {LENGTH_ANODE-CURV_RADIUS,WIDTH_DIELECTRIC+WIDTH_ANODE,0,LMS_DIEL_INT};
P_I = newp;
Point(P_I) = {LENGTH_ANODE,WIDTH_DIELECTRIC+WIDTH_ANODE-CURV_RADIUS,0,LMS_DIEL_INT};
P_Z = newp;
Point(P_Z) = {LENGTH_ANODE,WIDTH_DIELECTRIC+LMS_DIEL_INT,0,LMS_DIEL_INT};
P_J = newp;
Point(P_J) = {LENGTH_ANODE,WIDTH_DIELECTRIC,0,LMS_DIEL_INT};
P_K = newp;
Point(P_K) = {0,WIDTH_DIELECTRIC,0,MESH_SIZE};
P_L = newp;
Point(P_L) = {X_MIDDLE,WIDTH_DIELECTRIC,0,LMS_DIEL_INT};

P_center = newp;
Point(P_center) = {LENGTH_ANODE-CURV_RADIUS,WIDTH_DIELECTRIC+WIDTH_ANODE-CURV_RADIUS,0,MESH_SIZE};

L_AB = newl;
Line(L_AB) = {P_A, P_B};
L_BC = newl;
Line(L_BC) = {P_B, P_C};
L_CD = newl;
Line(L_CD) = {P_C, P_D};
L_DE = newl;
Line(L_DE) = {P_D, P_E};
L_EF = newl;
Line(L_EF) = {P_E, P_F};
L_FG = newl;
Line(L_FG) = {P_F, P_G};
L_GH = newl;
Line(L_GH) = {P_G, P_H};
L_HI = newl;
Circle(L_HI) = {P_H, P_center, P_I};
L_IZ = newl;
Line(L_IZ) = {P_I, P_Z};
L_ZJ = newl;
Line(L_ZJ) = {P_Z, P_J};
L_JK = newl;
Line(L_JK) = {P_J, P_K};
L_KA = newl;
Line(L_KA) = {P_K, P_A};
L_JL = newl;
Line(L_JL) = {P_J, P_L};
L_LD = newl;
Line(L_LD) = {P_L, P_D};

Delete { Point{P_center}; }

CL_air = newll;
Curve Loop(CL_air) = {L_JL, L_LD, L_DE, L_EF, L_FG, L_GH, L_HI, L_IZ, L_ZJ};

CL_diel = newll;
Curve Loop(CL_diel) = {L_AB, L_BC, L_CD, -L_LD, -L_JL, L_JK, L_KA};

S_air = news;
Plane Surface(S_air) = {CL_air};

S_diel = news;
Plane Surface(S_diel) = {CL_diel};

Transfinite Curve {L_JL} = Round((X_MIDDLE-LENGTH_ANODE)/LMS_DIEL_INT) Using Progression 1;

Physical Curve(1) = {L_ZJ, L_JK}; // anode 1
Physical Curve(2) = {L_GH, L_HI, L_IZ}; // anode 2
Physical Curve(3) = {L_BC}; // cathode 1
Physical Curve(4) = {L_AB}; // cathode 2
Physical Curve(5) = {L_FG, L_KA}; // west
Physical Curve(6) = {L_CD, L_DE}; // east
Physical Curve(7) = {L_EF}; // north

Physical Curve(1000) = {L_JL, L_LD}; // dielectric interface

Physical Surface(1) = {S_air};
Physical Surface(2) = {S_diel};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "DBDNonStruct.m";