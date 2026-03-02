function [p,input_file_content] = ProcessInput(input_script_name)
arguments
    input_script_name (1,:) char
end

% add .m if not already included in input_script_name
if ~strcmp(input_script_name(end-1:end),'.m')
    input_script_name = [input_script_name, '.m'];
end

p = struct;
run(input_script_name)
p_default = DefaultMerlino2Dinput;
field_names_cell = fieldnames(p_default);
for i = 1:numel(field_names_cell)
    field_name = field_names_cell{i};
    if exist(field_name,"var")
        p.(field_name) = eval(field_name);
    else
        p.(field_name) = p_default.(field_name);
    end
end

input_file_content = RemoveUselessLines(readlines(input_script_name));

end