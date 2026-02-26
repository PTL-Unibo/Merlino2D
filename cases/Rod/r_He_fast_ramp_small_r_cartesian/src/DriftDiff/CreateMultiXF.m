function [XF] = CreateMultiXF(msh, indices, ns)

I_XF = [];
J_XF = [];

for i = 1:ns
    I_XF = [I_XF; indices{i}.faces.F + (i-1)*msh.Nf];
    J_XF = [J_XF; msh.b_from_f(indices{i}.faces.F) + (i-1)*msh.Nb];
end

XF = sparse(I_XF, J_XF, 1, msh.Nf*ns, msh.Nb*ns);

end
