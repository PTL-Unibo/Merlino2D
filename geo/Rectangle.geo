If (!Exists(l))
  l = 1;
EndIf
LENGTH = l;

If (!Exists(h))
  h = 1;
EndIf
HEIGHT = h;

If (!Exists(msh))
  msh = 1e-2;
EndIf
MSH_SIZE = msh;

P_A = newp;
Point(P_A) = {0, 0, 0, MSH_SIZE};
P_B = newp;
Point(P_B) = {LENGTH, 0, 0, MSH_SIZE};
P_C = newp;
Point(P_C) = {LENGTH, HEIGHT, 0, MSH_SIZE};
P_D = newp;
Point(P_D) = {0, HEIGHT, 0, MSH_SIZE};

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
Save "Rectangle.m";