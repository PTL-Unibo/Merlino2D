mfilePath = mfilename('fullpath');
if contains(mfilePath,'LiveEditorEvaluationHelper')
    mfilePath = matlab.desktop.editor.getActiveFilename;
end
pieces = string(strsplit(mfilePath,filesep))+"/";
Merlino2DPath = join(pieces(1:end-2),"");

current_directory = pwd;
cd(Merlino2DPath)

text = fileread("code/General/GetPath.m");
new_text = regexprep(text,"Merlino2Dpath = [^;]*","Merlino2Dpath = """+Merlino2DPath+"""");

[file,location] = uigetfile('*.exe','Select the gmsh executable');
location = strrep(location,"\","/");
new_new_text = regexprep(new_text,"path_gmsh = [^;]*","path_gmsh = """+location+file+"""");

location = uigetdir("",'Select the LoKI-B folder');
location = strrep(location,"\","/");
new_new_new_text = regexprep(new_new_text,"LoKIpath = [^;]*","LoKIpath = """+location+"""");

fileID = fopen("code/General/GetPath.m","w");
fprintf(fileID,"%s",new_new_new_text);
fclose(fileID);

run("init.m");

cd(current_directory)
clear current_directory fileID Merlino2DPath mfilePath new_text 
clear new_new_text new_new_new_text pieces text ans location file