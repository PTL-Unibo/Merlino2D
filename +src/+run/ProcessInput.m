function [p,input_file_content] = ProcessInput(input_folder,input_script_name)
arguments
    input_folder (1,:) char
    input_script_name (1,:) char
end

% add .m if not already included in input_script_name
if ~strcmp(input_script_name(end-1:end),'.m')
    input_script_name = [input_script_name, '.m'];
end

input_script_name = string(input_folder) + filesep + input_script_name;

p = struct;
run(input_script_name)
p_default = src.run.DefaultMerlino2Dinput;
field_names_cell = fieldnames(p_default);
for i = 1:numel(field_names_cell)
    field_name = field_names_cell{i};
    if exist(field_name,"var")
        p.(field_name) = eval(field_name);
    else
        p.(field_name) = p_default.(field_name);
    end
end

input_file_content = src.gen.RemoveUselessLines(readlines(input_script_name));

end