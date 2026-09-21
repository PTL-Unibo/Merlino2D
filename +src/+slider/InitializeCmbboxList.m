function [cmbbox_names_list] = InitializeCmbboxList(out)

cmbbox_names_list = cell(1,out.ns+4+numel(out.reactions));
for j = 1:out.ns
    cmbbox_names_list{j} = char(out.s_names(j));
end
cmbbox_names_list{out.ns+1} = 'Rho';
cmbbox_names_list{out.ns+2} = 'Phi';
cmbbox_names_list{out.ns+3} = 'E';
cmbbox_names_list{out.ns+4} = 'f';
jj = 1;
for j = (out.ns+5):(out.ns+4+numel(out.reactions))
    cmbbox_names_list{j} = char(out.reactions(jj));
    jj = jj + 1;
end

end