function [bc_val_func_str] = GetBCvalFuncStr(cell)
string_cell = cellfun(@(x)GeneralConvert2String(x),cell,'UniformOutput',false);
dim = size(cell,1);
rows = repmat("",dim,1);
for i = 1:dim
    rows(i) = strjoin([string_cell{i,:}],",");
end
bc_val_func_str = "@(t)["+strjoin(rows,";")+"]";
end

function [out] = GeneralConvert2String(in)
if isnumeric(in)
    out = num2str(in);
elseif isa(in,"function_handle")
    out = func2str(in);
    out = strrep(out,'@(t)','');
end
out = string(out);
end
