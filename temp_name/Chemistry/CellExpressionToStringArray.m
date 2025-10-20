function [str_array] = CellExpressionToStringArray(cell_expr,num)
str_array = repmat(" ",numel(cell_expr),1);
for i = 1:numel(cell_expr)
    if ~(ischar(cell_expr{i}) | isstring(cell_expr{i}))
        str_array(i) = "ones("+num2str(num)+",1)*"+num2str(cell_expr{i});
    else
        str_array(i) = string(cell_expr{i});
    end
end

end
