function [] = CopyInSaveFolder(folder_name)

mkdir(folder_name+"/src")
mkdir(folder_name+"/geo")
mkdir(folder_name+"/kinetic")
mkdir(folder_name+"/data")

copyfile(GetPath('src'),folder_name+"/src")
copyfile(GetPath('geo'),folder_name+"/geo")
copyfile(GetPath('data'),folder_name+"/data")
copyfile(GetPath('kin'),folder_name+"/kinetic")

text = fileread(folder_name+"/src/General/GetPath.m");
new_text = regexprep(text,"Merlino2Dpath = [^;]*","Merlino2Dpath = """+strrep(pwd,filesep,"/")+"/"+folder_name+"/""");

fileID = fopen(folder_name+"/src/General/GetPath.m","w");
fprintf(fileID,"%s",new_text);
fclose(fileID);

end
