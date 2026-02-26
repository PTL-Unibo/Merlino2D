function [] = ExportVTU(out_pp, title)

folder = title + "_vtu_export";

num_digits = 5;

vtu_write(folder, "t", num_digits, out_pp)

temp = [out_pp.x_faces(out_pp.msh.f_from_d), out_pp.msh.f_from_d];
temp = sortrows(temp);
x_sorted = temp(:,1);
sorted_diel_interfaces = temp(:,2);

vtu_write_sigma(folder, "s", num_digits,...
    out_pp.nt, ...
    x_sorted,...
    out_pp.SIGMA(out_pp.msh.d_from_f(sorted_diel_interfaces),:),...
    out_pp.I_SATO, ...
    out_pp.V);

GeneratePVD(folder, title+"_t", "t", num_digits, out_pp.tout)
GeneratePVD(folder, title+"_s", "s", num_digits, out_pp.tout)

end
