function [I,J,S] = SparseRepMat(M,indices,type)

[i,j,s] = find(M);
n = numel(i);
ni = numel(indices);

I = zeros(n,ni);
J = zeros(n,ni);
S = zeros(n,ni);

for k = 1:ni
    index = indices(k);
    if type == "row"
        I(:,k) = i;
        J(:,k) = j + (index-1)*size(M,2);
    elseif type == "column"
        I(:,k) = i + (index-1)*size(M,1);
        J(:,k) = j;
    end
    S(:,k) = s;
end

I = I(:);
J = J(:);
S = S(:);

end