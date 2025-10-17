SetFactory("OpenCASCADE");

HEIGHT = 30e-3; // RECTANGLE
WIDTH = 100e-3; // RECTANGLE
R_EMITTER = 50e-6;
R_COLLECTOR = 5e-3;
DISTANCE = 30e-3; // DISTANCE EMITTER - COLLECTOR

LMS_RECTANGLE = 5e-3; // EXTERNAL BOUNDARY MESH SIZE
LMS_EMITTER = 7e-6;
LMS_COLLECTOR = 1e-4; // ONLY FOR 1ST COLLECTOR
LMS_CONTROLLO_EMITTER = 2e-4;
LMS_CONTROLLO_COLLECTOR = 3e-4; // FOR EVERY COLLECTOR IN THE GRID (INCLUDING 1ST ONE)

K_STRUCT_EMITTER = 2; // SIZE STRUCTURED REGION EMITTER
K_STRUCT_COLLECTOR = 1.1;
K_CONTROLLO_EMITTER = 50;
K_CONTROLLO_COLLECTOR = 1.5;

N_NODES_RADIAL_EMITTER = 10;
PROGR_RADIAL_EMITTER = 0.98;

N_NODES_RADIAL_COLLECTOR = 10;
PROGR_RADIAL_COLLECTOR = 0.98;

// EMITTER --------------------------------------------------------------------
P_eO = newp;
Point(P_eO) = {0, 0, 0, 1};
P_eA = newp;
Point(P_eA) = {-R_EMITTER, 0, 0, 1};
P_eB = newp;
Point(P_eB) = {0, R_EMITTER, 0, 1};
P_eC = newp;
Point(P_eC) = {R_EMITTER, 0, 0, 1};

P_emitter_left = newp;
Point(P_emitter_left) = {-K_STRUCT_EMITTER*R_EMITTER, 0, 0, LMS_EMITTER};
P_eBB = newp;
Point(P_eBB) = {0, K_STRUCT_EMITTER*R_EMITTER, 0, LMS_EMITTER};
P_emitter_right = newp;
Point(P_emitter_right) = {K_STRUCT_EMITTER*R_EMITTER, 0, 0, LMS_EMITTER};

L_e_inner_circ1 = newl;
Circle(L_e_inner_circ1) = {P_eA, P_eO, P_eB};
L_e_inner_circ2 = newl;
Circle(L_e_inner_circ2) = {P_eB, P_eO, P_eC};

L_e_outer_circ1 = newl;
Circle(L_e_outer_circ1) = {P_emitter_left, P_eO, P_eBB};
L_e_outer_circ2 = newl;
Circle(L_e_outer_circ2) = {P_eBB, P_eO, P_emitter_right};

L_eA = newl;
Line(L_eA) = {P_emitter_left, P_eA};
L_eB = newl;
Line(L_eB) = {P_eBB, P_eB};
L_eC = newl;
Line(L_eC) = {P_emitter_right, P_eC};

CL_e1 = newll;
Curve Loop(CL_e1) = {-L_eA, L_e_outer_circ1, L_eB, -L_e_inner_circ1};
CL_e2 = newll;
Curve Loop(CL_e2) = {-L_eB, L_e_outer_circ2, L_eC, -L_e_inner_circ2};

S_e1 = news;
Plane Surface(S_e1) = {CL_e1};
S_e2 = news;
Plane Surface(S_e2) = {CL_e2};

Transfinite Curve {L_e_inner_circ1, L_e_inner_circ2} = (0.5*K_STRUCT_EMITTER*R_EMITTER*Pi/LMS_EMITTER) Using Progression 1;
Transfinite Curve {L_e_outer_circ1, L_e_outer_circ2} = (0.5*K_STRUCT_EMITTER*R_EMITTER*Pi/LMS_EMITTER) Using Progression 1;

Transfinite Curve {L_eA, L_eB, L_eC} = N_NODES_RADIAL_EMITTER Using Progression PROGR_RADIAL_EMITTER;

Transfinite Surface {S_e1};
Transfinite Surface {S_e2};

Physical Curve("emitter100",100) = {L_e_inner_circ1, L_e_inner_circ2};


// COLLECTOR --------------------------------------------------------------------
X_CENTER_COLLECTOR = DISTANCE + R_COLLECTOR;
P_cO = newp;
Point(P_cO) = {X_CENTER_COLLECTOR, 0, 0, 1};
P_cA = newp;
Point(P_cA) = {X_CENTER_COLLECTOR - R_COLLECTOR, 0, 0, 1};
P_cB = newp;
Point(P_cB) = {X_CENTER_COLLECTOR, R_COLLECTOR, 0, 1};
P_cC = newp;
Point(P_cC) = {X_CENTER_COLLECTOR + R_COLLECTOR, 0, 0, 1};

P_collector_left = newp;
Point(P_collector_left) = {DISTANCE + (1 - K_STRUCT_COLLECTOR)*R_COLLECTOR, 0, 0, LMS_COLLECTOR};
P_cBB = newp;
Point(P_cBB) = {X_CENTER_COLLECTOR, K_STRUCT_COLLECTOR*R_COLLECTOR, 0, LMS_COLLECTOR};
P_collector_right = newp;
Point(P_collector_right) = {DISTANCE + (1 + K_STRUCT_COLLECTOR)*R_COLLECTOR, 0, 0, LMS_COLLECTOR};

L_c_inner_circ1 = newl;
Circle(L_c_inner_circ1) = {P_cA, P_cO, P_cB};
L_c_inner_circ2 = newl;
Circle(L_c_inner_circ2) = {P_cB, P_cO, P_cC};

L_c_outer_circ1 = newl;
Circle(L_c_outer_circ1) = {P_collector_left, P_cO, P_cBB};
L_c_outer_circ2 = newl;
Circle(L_c_outer_circ2) = {P_cBB, P_cO, P_collector_right};

L_cA = newl;
Line(L_cA) = {P_collector_left, P_cA};
L_cB = newl;
Line(L_cB) = {P_cBB, P_cB};
L_cC = newl;
Line(L_cC) = {P_collector_right, P_cC};

CL_c1 = newll;
Curve Loop(CL_c1) = {-L_cA, L_c_outer_circ1, L_cB, -L_c_inner_circ1};
CL_c2 = newll;
Curve Loop(CL_c2) = {-L_cB, L_c_outer_circ2, L_cC, -L_c_inner_circ2};

S_c1 = news;
Plane Surface(S_c1) = {CL_c1};
S_c2 = news;
Plane Surface(S_c2) = {CL_c2};

Transfinite Curve {L_c_inner_circ1, L_c_inner_circ2} = (0.5*K_STRUCT_COLLECTOR*R_COLLECTOR*Pi/LMS_COLLECTOR) Using Progression 1;
Transfinite Curve {L_c_outer_circ1, L_c_outer_circ2} = (0.5*K_STRUCT_COLLECTOR*R_COLLECTOR*Pi/LMS_COLLECTOR) Using Progression 1;

Transfinite Curve {L_cA, L_cB, L_cC} = N_NODES_RADIAL_COLLECTOR Using Progression PROGR_RADIAL_COLLECTOR;

Transfinite Surface {S_c1};
Transfinite Surface {S_c2};

Physical Curve("collector200",200) = {L_c_inner_circ1, L_c_inner_circ2};


// RECTANGLE --------------------------------------------------------------------
X_CENTER = R_COLLECTOR + DISTANCE / 2;

P_A = newp;
Point(P_A) = {X_CENTER - WIDTH/2, 0, 0, LMS_RECTANGLE};
P_B = newp;
Point(P_B) = {X_CENTER - WIDTH/2, HEIGHT, 0, LMS_RECTANGLE};
P_B1 = newp;
Point(P_B1) = {X_CENTER_COLLECTOR - 4.5e-3, HEIGHT, 0, LMS_RECTANGLE};
P_B2 = newp;
Point(P_B2) = {X_CENTER_COLLECTOR + 4.5e-3, HEIGHT, 0, LMS_RECTANGLE};
P_C = newp;
Point(P_C) = {X_CENTER + WIDTH/2, HEIGHT, 0, LMS_RECTANGLE};
P_D = newp;
Point(P_D) = {X_CENTER + WIDTH/2, 0, 0, LMS_RECTANGLE};
P_e_controllo_left = newp;
Point(P_e_controllo_left) = {-K_CONTROLLO_EMITTER*R_EMITTER, 0, 0, LMS_CONTROLLO_EMITTER};
P_e_controllo_right = newp;
Point(P_e_controllo_right) = {K_CONTROLLO_EMITTER*R_EMITTER, 0, 0, LMS_CONTROLLO_EMITTER};

P_c_controllo_left = newp;
Point(P_c_controllo_left) = {X_CENTER_COLLECTOR-K_CONTROLLO_COLLECTOR*R_COLLECTOR, 0, 0, LMS_CONTROLLO_COLLECTOR};
P_c_controllo_right = newp;
Point(P_c_controllo_right) = {X_CENTER_COLLECTOR+K_CONTROLLO_COLLECTOR*R_COLLECTOR, 0, 0, LMS_CONTROLLO_COLLECTOR};

L_AB = newl;
Line(L_AB) = {P_A, P_B};
L_top1 = newl;
Line(L_top1) = {P_B, P_B1};
L_top2 = newl;
Line(L_top2) = {P_B1, P_B2};
L_top3 = newl;
Line(L_top3) = {P_B2, P_C};
L_CD = newl;
Line(L_CD) = {P_C, P_D};
L_bottom1 = newl;
Line(L_bottom1) = {P_A, P_e_controllo_left};
L_bottom2 = newl;
Line(L_bottom2) = {P_e_controllo_left, P_emitter_left};
L_bottom3 = newl;
Line(L_bottom3) = {P_emitter_right, P_e_controllo_right};
L_bottom4 = newl;
Line(L_bottom4) = {P_e_controllo_right, P_c_controllo_left};
L_bottom5 = newl;
Line(L_bottom5) = {P_c_controllo_left, P_collector_left};
L_bottom6 = newl;
Line(L_bottom6) = {P_collector_right, P_c_controllo_right};
L_bottom7 = newl;
Line(L_bottom7) = {P_c_controllo_right, P_D};

Physical Curve("North",300) = {L_top1, L_top2, L_top3};
Physical Curve("East",301) = {L_CD};
Physical Curve("South",302) = {L_bottom1, L_bottom2, L_bottom3, L_bottom4, L_bottom5, L_bottom6, L_bottom7, L_eA, L_eC, L_cA, L_cC};
Physical Curve("West",303) = {L_AB};

// UNSTRUCT REGION --------------------------------------------------------------------
CL_rect = newll;
Curve Loop(CL_rect) = {L_bottom1, L_bottom2, L_e_outer_circ1, L_e_outer_circ2, L_bottom3, L_bottom4, L_bottom5, L_c_outer_circ1, L_c_outer_circ2, L_bottom6, L_bottom7, -L_CD, -L_top3, -L_top2, -L_top1, -L_AB};

S_unstruct = news;
Plane Surface(S_unstruct) = {CL_rect, loop_cond()};

// --------------------------------------------------------------------
L_e_circ_controllo = newl;
Circle(L_e_circ_controllo) = {P_e_controllo_left, P_eO, P_e_controllo_right};
Curve{L_e_circ_controllo} In Surface{S_unstruct};
Transfinite Curve {L_e_circ_controllo} = Round(Pi*K_CONTROLLO_EMITTER*R_EMITTER/LMS_CONTROLLO_EMITTER) Using Progression 1;

L_c_circ_controllo = newl;
Circle(L_c_circ_controllo) = {P_c_controllo_left, P_cO, P_c_controllo_right};
Curve{L_c_circ_controllo} In Surface{S_unstruct};
Transfinite Curve {L_c_circ_controllo} = Round(Pi*K_CONTROLLO_COLLECTOR*R_COLLECTOR/LMS_CONTROLLO_COLLECTOR) Using Progression 1;

Physical Surface(1) = {S_unstruct, S_e1, S_e2, S_c1, S_c2, struct_surf()};

Recursive Delete {
    Point{P_eO}; 
}

Recursive Delete {
    Point{P_cO}; 
}

Mesh 2;
Mesh.MshFileVersion = 2;
RefineMesh;
Save "WireCyl_50u_5m_30m.m";