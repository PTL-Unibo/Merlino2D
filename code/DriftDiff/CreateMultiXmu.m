function [Xmu] = CreateMultiXmu(msh, indices, ns)

I_Xmu = [];
J_Xmu = [];

for i = 1:ns
    I_Xmu = [I_Xmu; indices{i}.faces.D + (i-1)*msh.Nf];
    J_Xmu = [J_Xmu; msh.b_from_f(indices{i}.faces.D) + (i-1)*msh.Nb];
end

Xmu = sparse(I_Xmu, J_Xmu, 1, msh.Nf*ns, msh.Nb*ns);

end
