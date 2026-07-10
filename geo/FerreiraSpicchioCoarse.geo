SetFactory("OpenCASCADE");

If (!Exists(r))
  r = 1e-3;
EndIf

alpha = 0.2;
Nradial1 = 25;
Prog1 = 0.97;
Nradial2 = 10;
Nazimut2 = 15;
Prog2 = 0.95;
k_struct1 = 1.2;
k_struct2 = 0.95;
R_CYL = 48.75e-3;

MESH_SIZE_CYL = R_CYL * k_struct2 * alpha / (Nazimut2-1);

msh_size_w = r*(k_struct1-1)*(1-Prog1)/(1-Prog1^(Nradial1-1));
Nazimut1 = r*k_struct1*alpha/msh_size_w;

P_O = newp;
Point(P_O) = {0,0,0,1};
P_A = newp;
Point(P_A) = {r,0,0,msh_size_w};
P_B = newp;
Point(P_B) = {r*Cos(alpha),r*Sin(alpha),0,msh_size_w};
P_C = newp;
Point(P_C) = {R_CYL*Cos(alpha),R_CYL*Sin(alpha),0,MESH_SIZE_CYL};
P_D = newp;
Point(P_D) = {R_CYL,0,0,MESH_SIZE_CYL};
P_H = newp;
Point(P_H) = {r*k_struct1,0,0,msh_size_w};
P_K = newp;
Point(P_K) = {r*k_struct1*Cos(alpha),r*k_struct1*Sin(alpha),0,msh_size_w};
P_M = newp;
Point(P_M) = {R_CYL*k_struct2,0,0,MESH_SIZE_CYL};
P_N = newp;
Point(P_N) = {R_CYL*k_struct2*Cos(alpha),R_CYL*k_struct2*Sin(alpha),0,MESH_SIZE_CYL};

Lc_A_B = newl;
Circle(Lc_A_B) = {P_A, P_O, P_B};
L_B_K = newl;
Line(L_B_K) = {P_B, P_K};
L_K_N = newl;
Line(L_K_N) = {P_K, P_N};
L_N_C = newl;
Line(L_N_C) = {P_N, P_C};
Lc_C_D = newl;
Circle(Lc_C_D) = {P_C, P_O, P_D};
L_D_M = newl;
Line(L_D_M) = {P_D, P_M};
L_M_H = newl;
Line(L_M_H) = {P_M, P_H};
L_H_A = newl;
Line(L_H_A) = {P_H, P_A};
Lc_H_K = newl;
Circle(Lc_H_K) = {P_H, P_O, P_K};
Lc_M_N = newl;
Circle(Lc_M_N) = {P_M, P_O, P_N};

CL_1 = newll;
Curve Loop(CL_1) = {Lc_A_B, L_B_K, -Lc_H_K, L_H_A};
CL_2 = newll;
Curve Loop(CL_2) = {Lc_H_K, L_K_N, -Lc_M_N, L_M_H};
CL_3 = newll;
Curve Loop(CL_3) = {L_N_C, Lc_C_D, L_D_M, Lc_M_N};

Transfinite Curve {Lc_A_B, Lc_H_K} = Nazimut1 Using Progression 1;
Transfinite Curve {-L_B_K, L_H_A} = Nradial1 Using Progression Prog1;
Transfinite Curve {Lc_M_N, Lc_C_D} = Nazimut2 Using Progression 1;
Transfinite Curve {-L_D_M, L_N_C} = Nradial2 Using Progression Prog2;

Delete { Point{P_O}; }

S_1 = news;
Plane Surface(S_1) = {CL_1};
S_2 = news;
Plane Surface(S_2) = {CL_2};
S_3 = news;
Plane Surface(S_3) = {CL_3};

Transfinite Surface {S_1};
Transfinite Surface {S_3};

Physical Curve(1) = {Lc_A_B}; // wire
Physical Curve(2) = {Lc_C_D}; // cylinder
Physical Curve(3) = {L_B_K, L_K_N, L_N_C, L_D_M, L_M_H, L_H_A}; // sides

Physical Surface(1) = {S_1, S_2, S_3}; 

Mesh 2;
Mesh.MshFileVersion = 2;
Save "FerreiraSpicchioCoarse.m";