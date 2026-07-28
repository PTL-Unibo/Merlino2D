SetFactory("OpenCASCADE");

HEIGHT = 10e-3;
CURVE_RADIUS = 250e-6;
NEEDLE_LENGTH = 6.7e-3;
PP_DISTANCE = 3.3e-3; // point-plane distance
OFFSET_SQUARE = 5e-6;
L_SQUARE = 80e-6;
H_SQUARE = 80e-6;

// SMALL_MSH_SIZE = 0.5e-6;
MEDIUM_MESH_SIZE = 1e-4;
MSH_SIZE = 0.5e-3;
N_STRUCT_H = 120;
N_STRUCT_V = 120;
SMALL_MSH_SIZE = L_SQUARE / N_STRUCT_H;

a = 0.5/CURVE_RADIUS;

P_A = newp;
Point(P_A) = {NEEDLE_LENGTH, 0, 0, SMALL_MSH_SIZE};

n_int = 300;
n_middle = 180;
// dx = NEEDLE_LENGTH / n_int;
For i In {1:(n_int-1)}
  x = NEEDLE_LENGTH * (1 - Exp(Log(10)*7*(i/n_int-1)));
  y = Sqrt((NEEDLE_LENGTH - x)/a);
  Point(i+1) = {x, y, 0, SMALL_MSH_SIZE};
EndFor

P_B = newp;
Point(P_B) = {0, Sqrt(NEEDLE_LENGTH/a), 0, MEDIUM_MESH_SIZE};
P_C = newp;
Point(P_C) = {0, HEIGHT, 0, MSH_SIZE};
P_D = newp;
Point(P_D) = {NEEDLE_LENGTH+PP_DISTANCE, HEIGHT, 0, MSH_SIZE};
P_E = newp;
Point(P_E) = {NEEDLE_LENGTH+PP_DISTANCE, 0, 0, MEDIUM_MESH_SIZE};
P_W = newp;
Point(P_W) = {NEEDLE_LENGTH+OFFSET_SQUARE, 0, 0, SMALL_MSH_SIZE};
P_X = newp;
Point(P_X) = {NEEDLE_LENGTH+OFFSET_SQUARE, H_SQUARE, 0, SMALL_MSH_SIZE};
P_Y = newp;
Point(P_Y) = {NEEDLE_LENGTH+OFFSET_SQUARE+L_SQUARE, H_SQUARE, 0, SMALL_MSH_SIZE};
P_Z = newp;
Point(P_Z) = {NEEDLE_LENGTH+OFFSET_SQUARE+L_SQUARE, 0, 0, SMALL_MSH_SIZE};

L_A_K = newl;
Spline(L_A_K) = {P_A, 2:n_middle};
L_K_B = newl;
Spline(L_K_B) = {n_middle:n_int, P_B};
L_B_C = newl;
Line(L_B_C) = {P_B, P_C};
L_C_D = newl;
Line(L_C_D) = {P_C, P_D};
L_D_E = newl;
Line(L_D_E) = {P_D, P_E};
L_E_Z = newl;
Line(L_E_Z) = {P_E, P_Z};
L_Z_Y = newl;
Line(L_Z_Y) = {P_Z, P_Y};
L_Y_X = newl;
Line(L_Y_X) = {P_Y, P_X};
L_X_W = newl;
Line(L_X_W) = {P_X, P_W};
L_W_A = newl;
Line(L_W_A) = {P_W, P_A};
L_W_Z = newl;
Line(L_W_Z) = {P_W, P_Z};
CL_1 = newll;
Curve Loop(CL_1) = {L_A_K, L_K_B, L_B_C, L_C_D, L_D_E, L_E_Z, L_Z_Y, L_Y_X, L_X_W, L_W_A};
CL_2 = newll;
Curve Loop(CL_2) = {L_Z_Y, L_Y_X, L_X_W, L_W_Z};

S_1 = news;
Plane Surface(S_1) = {CL_1};
S_2 = news;
Plane Surface(S_2) = {CL_2};

Transfinite Curve {L_X_W,-L_Z_Y} = N_STRUCT_V Using Progression 1;
Transfinite Curve {L_Y_X,-L_W_Z} = N_STRUCT_H Using Progression 1;
Transfinite Surface {S_2};

Physical Curve(1) = {L_A_K, L_K_B}; // anode
Physical Curve(3) = {L_E_Z, L_W_Z, L_W_A}; // axis
Physical Curve(2) = {L_D_E}; // cathode
Physical Curve(4) = {L_B_C}; // external boundaries
Physical Curve(5) = {L_C_D}; // external boundaries

Physical Surface(1) = {S_1, S_2};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "PointPlaneParabolic.m";
