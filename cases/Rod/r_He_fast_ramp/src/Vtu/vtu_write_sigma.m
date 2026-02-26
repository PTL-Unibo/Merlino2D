function [] = vtu_write_sigma(folder, name, num_digits, nt, x_sorted, SIGMA_sorted, I, V)

Nd = numel(x_sorted);

f = "%.12e";

for k = 1:nt
    k_str = num2str(k);
    fileID = fopen(folder + "/" + name + repmat('0',1,num_digits-strlength(k_str)) + k_str + ".vtu", "w");
    fprintf(fileID,"<?xml version=""1.0""?>\n");
    fprintf(fileID,"<VTKFile type=""UnstructuredGrid"" version=""0.1"" byte_order=""LittleEndian"">\n");
    fprintf(fileID,"  <UnstructuredGrid>\n");
    fprintf(fileID,"    <Piece NumberOfPoints=""" + num2str(Nd) + """ NumberOfCells=""1"">\n\n");
    
    fprintf(fileID,"      <Points>\n");
    fprintf(fileID,"        <DataArray type=""Float64"" NumberOfComponents=""3"" format=""ascii"">\n");
    fprintf(fileID,"          %e %e %e\n",[x_sorted(:), zeros(Nd,1), zeros(Nd,1)]');
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"      </Points>\n\n");
    
    fprintf(fileID,"      <Cells>\n");
    fprintf(fileID,"        <DataArray type=""Int32"" Name=""connectivity"" format=""ascii"">\n");
    fprintf(fileID,"          %d", (0:1:Nd-1)'); fprintf(fileID,"\n");
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"        <DataArray type=""Int32"" Name=""offsets"" format=""ascii"">\n");
    fprintf(fileID,"          %d\n", Nd); 
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"        <DataArray type=""UInt8"" Name=""types"" format=""ascii"">\n");
    fprintf(fileID,"          %d\n", 4); 
    fprintf(fileID,"        </DataArray>\n");
    fprintf(fileID,"      </Cells>\n\n");

    % writing CellData ----------------------------------------------------
    fprintf(fileID,"      <CellData>\n");
        WriteScalar("I",I(k))
        WriteScalar("V",V(k))
    fprintf(fileID,"      </CellData>\n\n");
    
    % writing PointData ---------------------------------------------------
    fprintf(fileID,"      <PointData>\n");
        WriteScalar("sigma",SIGMA_sorted(:,k))
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

end
