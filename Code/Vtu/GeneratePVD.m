function [] = GeneratePVD(folder, title, name, num_digits, tout)

fileID = fopen(folder + "/" + title + ".pvd","w");
fprintf(fileID, "<?xml version=""1.0""?>\n");
fprintf(fileID, "<VTKFile type=""Collection"" version=""0.1"" byte_order=""LittleEndian"">\n");
fprintf(fileID, "  <Collection>\n");
for k = 1:numel(tout)
    k_str = num2str(k);
    fprintf(fileID, "    <DataSet timestep=""" + num2str(tout(k)) + """ file=""" + name + repmat('0',1,num_digits-strlength(k_str)) + k_str + ".vtu""/>\n");
end
fprintf(fileID, "  </Collection>\n");
fprintf(fileID, "</VTKFile>\n");
fclose(fileID);

end