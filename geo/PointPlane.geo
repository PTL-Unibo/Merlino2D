SetFactory("OpenCASCADE");

HEIGHT = 6e-3;
PP_DISTANCE = 10e-3;
CURVE_RADIUS = 100e-6;
NEEDLE_HEIGHT = 300e-6;
NEEDLE_LENGTH = 3e-3;
ANGLE = 5;
BIG_MSH_SIZE = 5e-4;
SMALL_MSH_SIZE = 1e-5;
MEDIUM_MESH_SIZE = 1e-4;

sphere_point_length = CURVE_RADIUS * (1 - Sin(ANGLE*Pi/180));
needle_point_length = (NEEDLE_HEIGHT - CURVE_RADIUS * Cos(ANGLE*Pi/180)) / Tan(ANGLE*Pi/180);
l = NEEDLE_LENGTH - needle_point_length - sphere_point_length;

P_G = newp;
Point(P_G) = {NEEDLE_LENGTH + PP_DISTANCE, HEIGHT, 0, BIG_MSH_SIZE};
P_A = newp;
Point(P_A) = {0, HEIGHT, 0, BIG_MSH_SIZE};
P_B = newp;
Point(P_B) = {0, NEEDLE_HEIGHT, 0, MEDIUM_MESH_SIZE};
P_C = newp;
Point(P_C) = {l, NEEDLE_HEIGHT, 0, SMALL_MSH_SIZE};
P_D = newp;
Point(P_D) = {l + needle_point_length, CURVE_RADIUS * Cos(ANGLE*Pi/180), 0, SMALL_MSH_SIZE};
P_E = newp;
Point(P_E) = {NEEDLE_LENGTH, 0, 0, SMALL_MSH_SIZE};
P_O = newp;
Point(P_O) = {NEEDLE_LENGTH - CURVE_RADIUS, 0, 0, 0};
P_F = newp;
Point(P_F) = {NEEDLE_LENGTH + PP_DISTANCE, 0, 0, MEDIUM_MESH_SIZE};

L_A_B = newl;
Line(L_A_B) = {P_A, P_B};
L_B_C = newl;
Line(L_B_C) = {P_B, P_C};
L_C_D = newl;
Line(L_C_D) = {P_C, P_D};
Lc_D_E = newl;
Circle(Lc_D_E) = {P_D, P_O, P_E};
L_E_F = newl;
Line(L_E_F) = {P_E, P_F};
L_F_G = newl;
Line(L_F_G) = {P_F, P_G};
L_G_A = newl;
Line(L_G_A) = {P_G, P_A};
CL_1 = newll;
Curve Loop(CL_1) = {L_A_B, L_B_C, L_C_D, Lc_D_E, L_E_F, L_F_G, L_G_A};

Delete { Point{P_O}; }

S_1 = news;
Plane Surface(S_1) = {CL_1};

Physical Curve(1) = {L_B_C, L_C_D, Lc_D_E}; // anode
Physical Curve(2) = {L_F_G}; // cathode
Physical Curve(3) = {L_G_A, L_A_B}; // external boundaries
Physical Curve(4) = {L_E_F}; // axis

Physical Surface(1) = {S_1};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "PointPlane.m";