function [] = vtu_write(folder, name, num_digits, out_pp)

f = "%.12e";
ff = "%.12e %.12e %.12e\n";

mkdir(folder),
for k = 1:out_pp.nt
    k_str = num2str(k);
    fileID = fopen(folder + "/" + name + repmat('0',1,num_digits-strlength(k_str)) + k_str + ".vtu", "w");
    fprintf(fileID,"<?xml version=""1.0""?>\n");
    fprintf(fileID,"<VTKFile type=""UnstructuredGrid"" version=""0.1"" byte_order=""LittleEndian"">\n");
    fprintf(fileID,"  <UnstructuredGrid>\n");
    fprintf(fileID,"    <Piece NumberOfPoints=""" + num2str(out_pp.Nn) + """ NumberOfCells=""" + num2str(out_pp.Nc) + """>\n\n");
    
    fprintf(fileID,"      <Points>\n");
    fprintf(fileID,"        <DataArray type=""Float64"" NumberOfComponents=""3"" format=""ascii"">\n");
    fprintf(fileID,"          %e %e %e\n",[out_pp.x_nodes, out_pp.y_nodes, zeros(out_pp.Nn,1)]');
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"      </Points>\n\n");
    
    fprintf(fileID,"      <Cells>\n");
    fprintf(fileID,"        <DataArray type=""Int32"" Name=""connectivity"" format=""ascii"">\n");
    fprintf(fileID,"          %d %d %d\n",(out_pp.link_cell_to_nodes-1)');
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"        <DataArray type=""Int32"" Name=""offsets"" format=""ascii"">\n");
    fprintf(fileID,"          %d",3:3:3*out_pp.Nc); fprintf(fileID,"\n");
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"        <DataArray type=""UInt8"" Name=""types"" format=""ascii"">\n");
    fprintf(fileID,"          %d",ones(1,out_pp.Nc)*5); fprintf(fileID,"\n");
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"      </Cells>\n\n");
    
    % writing CellData ----------------------------------------------------
    fprintf(fileID,"      <CellData>\n");
    for s = 1:out_pp.ns
        WriteScalar("n"+out_pp.S_NAMES(s),out_pp.N_CELLS(out_pp.Nc*(s-1)+1:s*out_pp.Nc,k))
    end
        WriteVector("E",[out_pp.EX_CELLS_MATRIX(:,k), out_pp.EY_CELLS_MATRIX(:,k), zeros(out_pp.Nc,1)])
    fprintf(fileID,"      </CellData>\n\n");

    % writing PointData ---------------------------------------------------
    fprintf(fileID,"      <PointData>\n");
        WriteScalar("phi",out_pp.PHI_NODES(:,k))
        if isfield(out_pp,"EX_NODES_MATRIX")
            WriteVector("E",[out_pp.EX_NODES_MATRIX(:,k), out_pp.EY_NODES_MATRIX(:,k), zeros(out_pp.Nn,1)])
        end
        if isfield(out_pp,"N_NODES")
            for s = 1:out_pp.ns
                WriteScalar("n"+out_pp.S_NAMES(s),out_pp.N_NODES(out_pp.Nn*(s-1)+1:s*out_pp.Nn,k))
            end
        end
    fprintf(fileID,"      </PointData>\n\n");
    
    fprintf(fileID,"    </Piece>\n");
    fprintf(fileID,"  </UnstructuredGrid>\n");
    fprintf(fileID,"</VTKFile>\n");
    fclose(fileID);
end

function [] = WriteScalar(name,vals)
fprintf(fileID,"        <DataArray type=""Float64"" Name=""" + name + """ format=""ascii"">\n");
fprintf(fileID,"          " + f,vals); fprintf(fileID,"\n");
fprintf(fileID,"        </DataArray>\n");
end

function [] = WriteVector(name,vals)
fprintf(fileID,"        <DataArray type=""Float64"" Name=""" + name + """ NumberOfComponents=""3"" format=""ascii"">\n");
fprintf(fileID,"          " + ff,vals');
fprintf(fileID,"        </DataArray>\n");
end

end
