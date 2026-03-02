function [msh] = GetMesh(geo_file_content,coordinates,MSHparameters)

% writing msh.geo
lines = geo_file_content;
searching = true;
while searching
    char_ll = char(lines(end));
    if numel(char_ll) > 3
        if string(char_ll(1:4)) == "Save"
            searching = false;
        end
    end
    lines(end) = [];
end
lines = [lines; 'Save "mesh.m";'];

user_directory = strrep(userpath,"\","/");
writelines(lines, user_directory+"/msh.geo");

cmd_argumets = CreateCmdMshParameters(MSHparameters);
[~,~] = system(GetPath("gmsh") + " " + user_directory + "/msh.geo" + cmd_argumets + " -parse_and_exit");
msh = PreProcessing(user_directory+"/mesh", coordinates, "remove_dielectric","yes");

delete(user_directory+"/msh.geo")
delete(user_directory+"/mesh.m")

end
