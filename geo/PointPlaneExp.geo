SetFactory("OpenCASCADE");

HEIGHT = 10e-3;
CURVE_RADIUS = 0.2e-3;
NEEDLE_HEIGHT = 1.5e-3;
NEEDLE_LENGTH = 8e-3;
ANGLE = 12;

L_PARAM_SMOOTH = 0.6e-3;
DX_CONTROL_CIRC = 0.5e-3; 

If (!Exists(g))
  g = 5e-3;  // default if not passed from command line
EndIf
PP_DISTANCE = g; // point-plane distance

If (!Exists(k))
  k = 1;  // default if not passed from command line
EndIf
BIG_MSH_SIZE = 5e-4 * k;
SMALL_MSH_SIZE = 1e-5 * k;
MEDIUM_MESH_SIZE = 1e-4 * k;

sphere_point_length = CURVE_RADIUS * (1 - Sin(ANGLE*Pi/180));
needle_point_length = (NEEDLE_HEIGHT - CURVE_RADIUS * Cos(ANGLE*Pi/180)) / Tan(ANGLE*Pi/180);
l = NEEDLE_LENGTH - needle_point_length - sphere_point_length;

// smooth other angle
x0 = l + L_PARAM_SMOOTH*Cos(ANGLE*Pi/180);
y0 = NEEDLE_HEIGHT - L_PARAM_SMOOTH*Sin(ANGLE*Pi/180);
x_star = l - L_PARAM_SMOOTH;
y_star = y0 + Tan((90-ANGLE)*Pi/180)*(x_star - x0);

// control circle
x_ref = NEEDLE_LENGTH - DX_CONTROL_CIRC;
y_ref = y0 - Tan(ANGLE*Pi/180)*(x_ref - x0);
r_circ_control = Sqrt((x_ref - NEEDLE_LENGTH)^2 + (y_ref)^2);
Length_circ_control = (Pi-Atan(y_ref/(DX_CONTROL_CIRC)))*r_circ_control;

P_O = newp;
Point(P_O) = {NEEDLE_LENGTH - CURVE_RADIUS, 0, 0, 0};
P_Os = newp;
Point(P_Os) = {x_star, y_star, 0, 1};

P_B = newp;
Point(P_B) = {0, NEEDLE_HEIGHT, 0, MEDIUM_MESH_SIZE};
P_Cleft = newp;
Point(P_Cleft) = {x_star, NEEDLE_HEIGHT, 0, MEDIUM_MESH_SIZE};
// P_C = newp;
// Point(P_C) = {l, NEEDLE_HEIGHT, 0, SMALL_MSH_SIZE};
P_Cright = newp;
Point(P_Cright) = {x0, y0, 0, MEDIUM_MESH_SIZE};
P_Dleft = newp;
Point(P_Dleft) = {x_ref, y_ref, 0, SMALL_MSH_SIZE};
P_D = newp;
Point(P_D) = {l + needle_point_length, CURVE_RADIUS * Cos(ANGLE*Pi/180), 0, SMALL_MSH_SIZE};
P_E = newp;
Point(P_E) = {NEEDLE_LENGTH, 0, 0, SMALL_MSH_SIZE};
P_F = newp;
Point(P_F) = {NEEDLE_LENGTH + r_circ_control, 0, 0, SMALL_MSH_SIZE};
P_G = newp;
Point(P_G) = {NEEDLE_LENGTH + PP_DISTANCE, 0, 0, MEDIUM_MESH_SIZE};
P_H = newp;
Point(P_H) = {NEEDLE_LENGTH + PP_DISTANCE, HEIGHT/2, 0, MEDIUM_MESH_SIZE};
P_I = newp;
Point(P_I) = {NEEDLE_LENGTH + PP_DISTANCE, HEIGHT, 0, BIG_MSH_SIZE};
P_A = newp;
Point(P_A) = {0, HEIGHT, 0, BIG_MSH_SIZE};

L_A_B = newl;
Line(L_A_B) = {P_A, P_B};
L_B_Cleft = newl;
Line(L_B_Cleft) = {P_B, P_Cleft};
Lc_Cleft_Cright = newl;
Circle(Lc_Cleft_Cright) = {P_Cleft, P_Os, P_Cright};
L_Cright_Dleft = newl;
Line(L_Cright_Dleft) = {P_Cright, P_Dleft};
L_Dleft_D = newl;
Line(L_Dleft_D) = {P_Dleft, P_D};
Lc_D_E = newl;
Circle(Lc_D_E) = {P_D, P_O, P_E};
L_E_F = newl;
Line(L_E_F) = {P_E, P_F};
L_F_G = newl;
Line(L_F_G) = {P_F, P_G};
L_G_H = newl;
Line(L_G_H) = {P_G, P_H};
L_H_I = newl;
Line(L_H_I) = {P_H, P_I};
L_I_A = newl;
Line(L_I_A) = {P_I, P_A};
CL_1 = newll;
Curve Loop(CL_1) = {L_B_Cleft, Lc_Cleft_Cright, L_Cright_Dleft, L_Dleft_D, Lc_D_E, L_E_F, L_F_G, L_G_H, L_H_I, L_I_A, L_A_B};

Delete { Point{P_O}; }
Delete { Point{P_Os}; }

S_1 = news;
Plane Surface(S_1) = {CL_1};

Lc_control = newl;
Circle(Lc_control) = {P_Dleft, P_E, P_F};
Curve{Lc_control} In Surface{S_1};
Transfinite Curve {Lc_control} = Round(Length_circ_control/SMALL_MSH_SIZE) Using Progression 1;


Physical Curve(1) = {L_B_Cleft, Lc_Cleft_Cright, L_Cright_Dleft, L_Dleft_D, Lc_D_E}; // anode
Physical Curve(3) = {L_E_F, L_F_G}; // axis
Physical Curve(2) = {L_G_H, L_H_I}; // cathode
Physical Curve(4) = {L_I_A}; // external boundaries
Physical Curve(5) = {L_A_B}; // external boundaries


Physical Surface(1) = {S_1};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "PointPlaneExp.m";