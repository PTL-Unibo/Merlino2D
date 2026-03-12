function [input_file_content] = RemoveUselessLines(input_file_content)

N = numel(input_file_content);
delete_list = zeros(1,N);
cont = 1;
for i = 1:N
    line = strtrim(input_file_content(i));
    char_line = char(line);
    if numel(char_line) == 0 || char_line(1) == "%"
        delete_list(cont) = i;
        cont = cont + 1;
    end
end

delete_list = delete_list(delete_list>0);
input_file_content(delete_list) = [];

end