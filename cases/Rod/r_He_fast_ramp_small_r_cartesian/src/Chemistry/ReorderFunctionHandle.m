function [ordered_str] = ReorderFunctionHandle(str,mapping)

str = strrep(str,'@(t)','');
str = strrep(str,'[','');
str = strrep(str,']','');
cell_arr = split(str,';');
cell_arr = cell_arr(mapping);

ordered_str = "@(t)["+join(string(cell_arr),";")+"]";

end
