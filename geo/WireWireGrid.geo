SetFactory("OpenCASCADE");

N_COLLECTORS = 4;
R_EMITTER = 50e-6;
R_COLLECTOR = 100e-6;
SPACING_COLLECTORS = 3.55e-3;
DISTANCE = 20e-3;

HEIGHT = (N_COLLECTORS-1)*2*R_COLLECTOR + R_COLLECTOR + (N_COLLECTORS-1)*SPACING_COLLECTORS + SPACING_COLLECTORS*0.5;
WIDTH = 5.5e-2;

K_STRUCT_EMITTER = 2;
K_CONTROLLO_EMITTER = 10;
K_CONTROLLO_COLLECTOR = 10;

If (!Exists(k))
  k = 1;  // default if not passed from command line
EndIf

LMS_EMITTER = 0.5e-5*k; 
LMS_COLLECTOR = 1e-5*k;
LMS_CONTROLLO_EMITTER = 1.5e-4*k;
LMS_CONTROLLO_COLLECTOR = 2.5e-4*k;
LMS_RECTANGLE = 3e-3*k;
a0 = 0.5e-5*k;

counter = -1;

x_center = R_COLLECTOR + 0.5*DISTANCE;

n_nodes_azimut = Round(Pi*R_EMITTER*K_STRUCT_EMITTER/LMS_EMITTER);

L_tot = (K_STRUCT_EMITTER-1)*R_EMITTER;
p = 0.98;
n_nodes_radial = Round(Log((p*L_tot+a0-L_tot)/a0)/Log(p)) + 1;

P_A = newp;
Point(P_A) = {x_center-0.5*WIDTH, 0, 0, LMS_RECTANGLE};
P_B = newp;
Point(P_B) = {x_center-0.5*WIDTH, HEIGHT, 0, LMS_RECTANGLE};
P_C = newp;
Point(P_C) = {x_center+0.5*WIDTH, HEIGHT, 0, LMS_RECTANGLE};
P_D = newp;
Point(P_D) = {x_center+0.5*WIDTH, 0, 0, LMS_RECTANGLE};

P_eO = newp;
Point(P_eO) = {0, 0, 0, 1};
P_eW = newp;
Point(P_eW) = {-R_EMITTER, 0, 0, LMS_EMITTER};
P_eE = newp;
Point(P_eE) = {R_EMITTER, 0, 0, LMS_EMITTER};

P_seW = newp;
Point(P_seW) = {-R_EMITTER*K_STRUCT_EMITTER, 0, 0, LMS_EMITTER};
P_seE = newp;
Point(P_seE) = {R_EMITTER*K_STRUCT_EMITTER, 0, 0, LMS_EMITTER};

P_ceW = newp;
Point(P_ceW) = {-K_CONTROLLO_EMITTER*R_EMITTER, 0, 0, LMS_CONTROLLO_EMITTER};
P_ceE = newp;
Point(P_ceE) = {K_CONTROLLO_EMITTER*R_EMITTER, 0, 0, LMS_CONTROLLO_EMITTER};

x_center_collector = R_EMITTER + DISTANCE + R_COLLECTOR;
P_cO = newp;
Point(P_cO) = {x_center_collector, 0, 0, 1};
P_cW = newp;
Point(P_cW) = {x_center_collector-R_COLLECTOR, 0, 0, LMS_COLLECTOR};
P_cE = newp;
Point(P_cE) = {x_center_collector+R_COLLECTOR, 0, 0, LMS_COLLECTOR};

P_ccW = newp;
Point(P_ccW) = {x_center_collector-K_CONTROLLO_COLLECTOR*R_COLLECTOR, 0, 0, LMS_CONTROLLO_COLLECTOR};
P_ccE = newp;
Point(P_ccE) = {x_center_collector+K_CONTROLLO_COLLECTOR*R_COLLECTOR, 0, 0, LMS_CONTROLLO_COLLECTOR};

P_TOPW = newp;
Point(P_TOPW) = {x_center_collector-K_CONTROLLO_COLLECTOR*R_COLLECTOR, HEIGHT, 0, LMS_CONTROLLO_COLLECTOR};
P_TOPE = newp;
Point(P_TOPE) = {x_center_collector+K_CONTROLLO_COLLECTOR*R_COLLECTOR, HEIGHT, 0, LMS_CONTROLLO_COLLECTOR};


L_A_ceW = newl;
Line(L_A_ceW) = {P_A, P_ceW};
L_ceW_seW = newl;
Line(L_ceW_seW) = {P_ceW, P_seW};
Lc_seW_seE = newl;
Circle(Lc_seW_seE) = {P_seW, P_eO, P_seE};
L_seE_ceE = newl;
Line(L_seE_ceE) = {P_seE, P_ceE};
L_ceE_ccW = newl;
Line(L_ceE_ccW) = {P_ceE, P_ccW};
L_ccW_cW = newl;
Line(L_ccW_cW) = {P_ccW, P_cW};
Lc_cW_cE = newl;
Circle(Lc_cW_cE) = {P_cW, P_cO, P_cE};
L_cE_ccE = newl;
Line(L_cE_ccE) = {P_cE, P_ccE};
L_ccE_D = newl;
Line(L_ccE_D) = {P_ccE, P_D};
L_D_C = newl;
Line(L_D_C) = {P_D, P_C};
L_C_TOPE = newl;
Line(L_C_TOPE) = {P_C, P_TOPE};
L_TOPE_TOPW = newl;
Line(L_TOPE_TOPW) = {P_TOPE, P_TOPW};
L_TOPW_B = newl;
Line(L_TOPW_B) = {P_TOPW, P_B};
L_B_A = newl;
Line(L_B_A) = {P_B, P_A};
CL_rect = newll;
Curve Loop(CL_rect) = {L_A_ceW, L_ceW_seW, Lc_seW_seE, L_seE_ceE, L_ceE_ccW, L_ccW_cW, Lc_cW_cE, L_cE_ccE, L_ccE_D, L_D_C, L_C_TOPE, L_TOPE_TOPW, L_TOPW_B, L_B_A};
L_seW_eW = newl;
Line(L_seW_eW) = {P_seW, P_eW};
Lc_eW_eE = newl;
Circle(Lc_eW_eE) = {P_eW, P_eO, P_eE};
L_eE_seE = newl;
Line(L_eE_seE) = {P_eE, P_seE};
CL_struct = newll;
Curve Loop(CL_struct) = {L_seW_eW, Lc_eW_eE, L_eE_seE, -Lc_seW_seE};
Lc_ceW_ceE = newl;
Circle(Lc_ceW_ceE) = {P_ceW, P_eO, P_ceE};
Lc_ccW_ccE = newl;
Circle(Lc_ccW_ccE) = {P_ccW, P_cO, P_ccE};

Physical Curve("emitter100",100) = {Lc_eW_eE};
Physical Curve("collector200",200) = {Lc_cW_cE};

i_physical = 200;
For i In {1:N_COLLECTORS-1}
    collector_i = newl;
    y = (2*R_COLLECTOR + SPACING_COLLECTORS)*i;
    Circle(collector_i) = {x_center_collector, y, 0, R_COLLECTOR, 0, 2*Pi};
    Transfinite Curve {collector_i} = Round(2*Pi*R_COLLECTOR/LMS_COLLECTOR) Using Progression 1;
    c_loop_i = newll;
    Curve Loop(c_loop_i) = {collector_i};
    counter ++;
    collectors_array[counter] = c_loop_i;
    i_physical ++;
    Physical Curve(i_physical) = {collector_i};
EndFor

S_unstruct = news;
Plane Surface(S_unstruct) = {CL_rect, collectors_array()};

S_struct = news;
Plane Surface(S_struct) = {CL_struct};

Curve{Lc_ceW_ceE} In Surface{S_unstruct};
Transfinite Curve {Lc_ceW_ceE} = Round(Pi*R_EMITTER*K_CONTROLLO_EMITTER/LMS_CONTROLLO_EMITTER) Using Progression 1;

Curve{Lc_ccW_ccE} In Surface{S_unstruct};
Transfinite Curve {Lc_ccW_ccE} = Round(Pi*R_COLLECTOR*K_CONTROLLO_COLLECTOR/LMS_CONTROLLO_COLLECTOR) Using Progression 1;

Transfinite Curve {L_seW_eW} = n_nodes_radial Using Progression p;
Transfinite Curve {L_eE_seE} = n_nodes_radial Using Progression (1/p);
Transfinite Curve {Lc_eW_eE} = n_nodes_azimut Using Progression 1;
Transfinite Curve {Lc_seW_seE} = n_nodes_azimut Using Progression 1;
Transfinite Surface {S_struct};

For i In {1:N_COLLECTORS-1}
    controllo_collector_i = newl;
    y = (2*R_COLLECTOR + SPACING_COLLECTORS)*i;
    Circle(controllo_collector_i) = {x_center_collector, y, 0, K_CONTROLLO_COLLECTOR*R_COLLECTOR, 0, 2*Pi};
    Curve{controllo_collector_i} In Surface{S_unstruct};
    Transfinite Curve {controllo_collector_i} = Round(2*Pi*R_COLLECTOR*K_CONTROLLO_COLLECTOR/LMS_CONTROLLO_COLLECTOR) Using Progression 1;
EndFor

Recursive Delete {
    Point{P_eO}; 
}

Recursive Delete {
    Point{P_cO}; 
}

Physical Curve("North",300) = {L_C_TOPE, L_TOPE_TOPW, L_TOPW_B};
Physical Curve("East",301) = {L_D_C};
Physical Curve("South",302) = {L_A_ceW, L_ceW_seW, L_seW_eW, L_eE_seE, L_seE_ceE, L_ceE_ccW, L_ccW_cW, L_cE_ccE, L_ccE_D};
Physical Curve("West",303) = {L_B_A};

Physical Surface(1) = {S_unstruct, S_struct};

Mesh 2;
Mesh.MshFileVersion = 2;
Save "WireWireGrid.m";