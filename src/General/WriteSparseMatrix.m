function [] = WriteSparseMatrix(M,name)
name = char(name);
if (numel(name) < 5)
    name = [name, '.csv'];
elseif ~(name(end-3:end) == ".csv")
    name = [name, '.csv'];
end
[i,j,s] = find(M);
writematrix([[size(M,1);i],[size(M,2);j],[0;s]],name)
end