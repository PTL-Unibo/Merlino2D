function [fComputeMU,fComputeD,fComputeKr] = GetFcomputeMuDKr(Mu,D,Kr,Nc,Nf)

Mu_str = CellExpressionToStringArray(Mu,Nf);
D_str = CellExpressionToStringArray(D,Nf);
Kr_str = CellExpressionToStringArray(Kr,Nc);

strMu = "@(E,Te,T,Ngas)[" + join(Mu_str,",") + "]";
strKr = "@(E,Te,T,Ngas)[" + join(Kr_str,",") + "]";
strD = "@(mu,E,Te,T,Ngas)[" + join(D_str,",") + "]";

strMu = AddDot(strMu);
strKr = AddDot(strKr);
strD = AddDot(strD);
strD = regexprep(strD, 'mu(\d+)', 'mu(:,$1)'); % replace mu123 with mu(:,123)

% creating griddedInterpolants --------------------------------------------
file_names_str = GetCSVfilesInData();
num_files = numel(file_names_str);
for i = 1:num_files
    if contains(strMu,file_names_str(i)) || contains(strD,file_names_str(i)) || contains(strKr,file_names_str(i))
        LUT = load(GetPath("data") + "/"+file_names_str(i)+".csv"); %#ok<NASGU>
        eval(file_names_str(i) + " = griddedInterpolant(LUT(:,1),LUT(:,2),""linear"",""nearest"");");
    end
end
% -------------------------------------------------------------------------

fComputeMU = eval(strMu);
fComputeD = eval(strD);
fComputeKr = eval(strKr);

end
