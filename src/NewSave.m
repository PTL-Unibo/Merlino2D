function [] = NewSave(out,folder_name)

if ~exist("folder_name","var")
    folder_name = GetTimeString(datetime);
end

if isfolder(folder_name)
    error("A saving with the same name already exists")
end

CopyInSaveFolder(folder_name)

out.p.V_APPLIED = func2str(out.p.V_APPLIED);

save_struct.p = out.p;
save_struct.tout = out.tout;
save_struct.yout = out.yout;
save_struct.wall_clock_time = out.wall_clock_time;
save_struct.statsout = out.statsout;
save_struct.Sph = out.Sph;

folder_name_split = strsplit(folder_name,"/");

SaveStruct(folder_name+"/"+folder_name_split(end),save_struct)

end
