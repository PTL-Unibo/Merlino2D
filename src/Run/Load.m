function [out] = Load(input_name)

arguments
    input_name (1,:) char = ""
end

if input_name == ""
    folder_name = uigetdir("",'Select the folder');
    folder_name = strrep(folder_name,filesep,"/");
else
    folder_name = input_name;
end

previous_path = pwd;
cd(folder_name)
out = SpecificLoader();
cd(previous_path)

end