function [] = NewSave(out,folder_name)

if ~exist("folder_name","var")
    folder_name = GetTimeString(datetime);
end

if isfolder(folder_name)
    error("A saving with the same name already exists")
end

CopyInSaveFolder()

out.p.V_APPLIED = func2str(out.p.V_APPLIED);

save_struct.p = out.p;
save_struct.tout = out.tout;
save_struct.yout = out.yout;
save_struct.wall_clock_time = out.wall_clock_time;
save_struct.statsout = out.statsout;
save_struct.Sph = out.Sph;

folder_name_split = strsplit(folder_name,"/");

SaveStruct(folder_name+"/"+folder_name_split(end),save_struct)

    function [] = CopyInSaveFolder()
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

end


