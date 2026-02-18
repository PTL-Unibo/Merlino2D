function [p,processed_input] = ProcessInput(input_script,flag)

input_file_content = readlines(input_script);

if flag == "run"
    N = numel(input_file_content);
    delete_list = zeros(1,N);
    cont = 1;
    k_start = 0;
    k_end = 0;
    for i = 1:numel(input_file_content)
        line = strtrim(input_file_content(i));
        char_line = char(line);
        if k_start ~= 0
            if line == "%>>>>>"
                k_end = i;
                break
            else
                if numel(char_line) == 0
                    delete_list(cont) = i;
                    cont = cont + 1;
                elseif char_line(1) == "%"
                    delete_list(cont) = i;
                    cont = cont + 1;
                end
            end
        else
            if line == "%<<<<<"
                k_start = i;
            end
        end
    end
    
    delete_list = delete_list(delete_list>0) - k_start;
    l = (k_end-1) - (k_start+1) + 1;
    delete_list(delete_list>l) = [];
    processed_input = input_file_content(k_start+1:k_end-1);
    processed_input(delete_list) = [];

    % print input on screen
    fprintf("Running input:\n")
    fprintf("%s\n",processed_input)
    fprintf("\n")
elseif flag == "init"
    processed_input = input_file_content;
end

eval(strjoin(processed_input,newline));

end