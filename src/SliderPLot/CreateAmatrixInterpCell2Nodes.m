function [A] = CreateAmatrixInterpCell2Nodes(msh)
ii = (1:msh.Nn)';
I = repelem(ii, msh.num_cs_from_n(ii));
J = vertcat(msh.cs_from_n{ii});
S = vertcat(msh.w_cs_from_n{ii});
A = sparse(I(:), J, S, msh.Nn, msh.Nc);
end