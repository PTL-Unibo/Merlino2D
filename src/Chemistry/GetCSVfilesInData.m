function [file_names_str] = GetCSVfilesInData()
data_dir_cell = {dir(GetPath("data")).name};
done = 0;
k = 1;
while ~done
    name_k = data_dir_cell{k};
    if numel(name_k) > 4
        if ~(name_k(end-3:end) == ".csv")
            data_dir_cell(k) = [];
        else
            data_dir_cell{k} = string(name_k(1:end-4)); 
            k = k + 1;
        end
    else
        data_dir_cell(k) = [];
    end
    if k > numel(data_dir_cell)
        done = 1;
    end
end
file_names_str = [data_dir_cell{:}];
end
