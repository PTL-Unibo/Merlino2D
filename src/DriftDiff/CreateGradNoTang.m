function [Gx, Gy] = CreateGradNoTang(msh, ns)

indices_internal_f = find(msh.cs_from_f(:,2)~=0);

magnitude_I = sqrt(msh.I(:,1).^2 + msh.I(:,2).^2);
iv = msh.I ./ magnitude_I; 
coeff_x = iv(:,1) ./ magnitude_I; 
coeff_y = iv(:,2) ./ magnitude_I; 

i = [indices_internal_f; indices_internal_f];
j = [msh.cs_from_f(indices_internal_f,2); msh.cs_from_f(indices_internal_f,1)];
s = [coeff_x(indices_internal_f); -coeff_x(indices_internal_f)];
Gx = sparse(repeat(i,msh.Nf,ns), repeat(j,msh.Nc,ns), repmat(s,ns,1), ns*msh.Nf, ns*msh.Nc);

i = [indices_internal_f; indices_internal_f];
j = [msh.cs_from_f(indices_internal_f,2); msh.cs_from_f(indices_internal_f,1)];
s = [coeff_y(indices_internal_f); -coeff_y(indices_internal_f)];
Gy = sparse(repeat(i,msh.Nf,ns), repeat(j,msh.Nc,ns), repmat(s,ns,1), ns*msh.Nf, ns*msh.Nc);

end

function [rv] = repeat(v, N, n)
    rv = reshape(v(:)+(0:N:(n-1)*N), [], 1);
end
