function [] = Save(out,folder_name)

if ~exist("folder_name","var")
    folder_name = src.gen.GetTimeString(datetime);
end

if isfolder(folder_name)
    error("A saving with the same name already exists")
end

% input
mkdir(folder_name)
mkdir(folder_name+"/inputs")
writelines(out.temp_input,folder_name + "/inputs/input_script.m")

% data
mkdir(folder_name+"/data")
copyfile(src.gen.GetPath('data'), folder_name+"/data")

% func
mkdir(folder_name+"/+func")
copyfile(src.gen.GetPath('func'), folder_name+"/+func")

% src
mkdir(folder_name+"/+src")
copyfile(src.gen.GetPath('src'), folder_name+"/+src")

% geo
mkdir(folder_name+"/geo")
writelines(out.temp_geo_file_content, folder_name + "/geo/" + out.p.MSH + ".geo")

% kinetic
if upper(out.p.CHEMICAL_MODEL) ~= "OFF"
    mkdir(folder_name+"/kinetic")
    copyfile(src.gen.GetPath('kin')+"/"+out.p.CHEMICAL_MODEL+".m",folder_name+"/kinetic/"+out.p.CHEMICAL_MODEL+".m")
end

save_struct.tout = out.tout;
save_struct.yout = out.yout;
save_struct.stats = out.stats;
save_struct.Sph = out.Sph;
save_struct.y_end = out.yout(:,end);

src.gen.SaveStruct(folder_name+"/results.mat",save_struct)

end