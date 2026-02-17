function [] = Save(out_pp, name)

if ~exist("name","var")
    name = GetTimeString(datetime);
end

save_struct.tout = out_pp.tout;
save_struct.N_CELLS = out_pp.N_CELLS;
save_struct.SIGMA = out_pp.SIGMA;
save_struct.PHI_NODES = out_pp.PHI_NODES; 
save_struct.EX_CELLS_MATRIX = out_pp.EX_CELLS_MATRIX;
save_struct.EY_CELLS_MATRIX = out_pp.EY_CELLS_MATRIX;
save_struct.RHO_CELLS = out_pp.RHO_CELLS;
save_struct.I_SATO = out_pp.I_SATO;
save_struct.VAPP = out_pp.VAPP;
save_struct.link_cell_to_nodes = out_pp.link_cell_to_nodes;
save_struct.x_cells = out_pp.x_cells;
save_struct.x_faces = out_pp.x_faces;
save_struct.x_nodes = out_pp.x_nodes;
save_struct.y_cells = out_pp.y_cells;
save_struct.y_faces = out_pp.y_faces;
save_struct.y_nodes = out_pp.y_nodes;
save_struct.Nb = out_pp.Nb;
save_struct.Nc = out_pp.Nc;
save_struct.Nd = out_pp.Nd;
save_struct.Nf = out_pp.Nf;
save_struct.Nn = out_pp.Nn;
save_struct.ns = out_pp.ns;
save_struct.nt = out_pp.nt;
save_struct.qs = out_pp.qs;
save_struct.Sph = out_pp.Sph;
save_struct.S_NAMES = out_pp.S_NAMES;
save_struct.stats = out_pp.stats;
save_struct.input = out_pp.input;

save_struct.y_end = [out_pp.N_CELLS(:,end); out_pp.SIGMA(:,end)];

if isfield(out_pp,"EX_MATRIX")
    save_struct.EX_MATRIX = out_pp.EX_MATRIX;
    save_struct.EY_MATRIX = out_pp.EY_MATRIX;
    save_struct.OMEGA_MATRIX = out_pp.OMEGA_MATRIX;
    save_struct.GAMMA_X_MATRIX = out_pp.GAMMA_X_MATRIX;
    save_struct.GAMMA_Y_MATRIX = out_pp.GAMMA_Y_MATRIX;
    save_struct.N_NODES = out_pp.N_NODES;
    save_struct.RHO_NODES = out_pp.RHO_NODES;
    save_struct.EX_NODES_MATRIX = out_pp.EX_NODES_MATRIX;
    save_struct.EY_NODES_MATRIX = out_pp.EY_NODES_MATRIX;
    save_struct.I_bID = out_pp.I_bID;
end

SaveStruct(name,save_struct)

end

function [time_string] = GetTimeString(t)
[h,m,s] = hms(t);
[Y,M,D] = ymd(t);
time_string = num2str(Y) + "_" + num2str(M) + "_" + num2str(D) + ...
    "_" + num2str(h) + "_" + num2str(m) + "_" + num2str(round(s));
end


