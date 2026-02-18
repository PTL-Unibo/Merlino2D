function [out] = SpecificLoader()

% prepare GetPath
split_str = strsplit(mfilename('fullpath'),filesep);
Merlino2D_path = strjoin(split_str(1:end-1),"/");
text = fileread(GetPath("src")+"/General/GetPath.m");
new_text = regexprep(text,"Merlino2Dpath = [^;]*","Merlino2Dpath = """ + Merlino2D_path + "/""");
fileID = fopen(Merlino2D_path + "/src/General/GetPath.m","w");
fprintf(fileID,"%s",new_text);
fclose(fileID);

origianl_path = GetPath("src");
current_path = Merlino2D_path+"/src";

rmpath(genpath(origianl_path)) % - original

addpath(genpath(current_path)) % + current

try
    % Load save -----------------------------------------------------------
    out = Merlino2D(Merlino2D_path+"/input_script.m","init");            %|
                                                                         %|
    split_merlino_path = strsplit(Merlino2D_path,"/");                   %|
    result_folder_name = split_merlino_path(end);                        %|
    out2 = load(Merlino2D_path+"/"+result_folder_name+".mat");           %|
                                                                         %|
    % merge the 2 struct                                                 %|
    fn = fieldnames(out2);                                               %|
    fn(fn=="y_end") = []; % remove y_end                                 %|
    for k = 1:numel(fn)                                                  %|
        out.(fn{k}) = out2.(fn{k});                                      %|
    end                                                                  %|
    % ---------------------------------------------------------------------
catch ME
    fprintf("Load failed due to: " + ME.message + "\n")
    out = 0;
end

rmpath(genpath(current_path)) % - current

addpath(genpath(origianl_path)) % + original

end