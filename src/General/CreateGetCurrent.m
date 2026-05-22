function [GetCurrent] = CreateGetCurrent(Nf,ns,qs,areaf,indices,Length)

M = [];
for i = 1:ns
    M = [M, speye(Nf)*qs(i)]; %#ok<AGROW>
end
M = e*M;

row = zeros(1,Nf);
row(indices) = -areaf(indices);

GetCurrent = Length * row * M;

GetCurrent = sparse(GetCurrent);

end