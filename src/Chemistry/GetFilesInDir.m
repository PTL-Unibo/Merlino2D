function [file_names_str] = GetFilesInDir(extension,directory)
data_dir_cell = {dir(directory).name};
done = 0;
ext_dim = numel(char(extension));
k = 1;
while ~done
    name_k = data_dir_cell{k};
    if numel(name_k) > ext_dim
        if ~(name_k((end-ext_dim+1):end) == extension)
            data_dir_cell(k) = [];
        else
            data_dir_cell{k} = string(name_k(1:end-ext_dim)); 
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
