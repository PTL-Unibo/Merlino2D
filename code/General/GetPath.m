function [p] = GetPath(id)
arguments
    id (1,:) char {mustBeMember(id,{'gmsh','geo','data','kin','loki'})}
end

Merlino2Dpath = "C:/Users/fabio/Documents/GitHub/Merlino2D/";
LoKIpath = "C:/Users/fabio/Documents/GitHub/Merlino/LokiB";

switch id
    case 'gmsh'
        path_gmsh = "C:/Users/fabio/Documents/gmsh-4.13.1-Windows64/gmsh.exe";
        p = path_gmsh;
    case 'loki'
        p = LoKIpath;
    case 'geo'
        p = Merlino2Dpath + "geo";
    case 'data'
        p = Merlino2Dpath + "data";
    case 'kin'
        p = Merlino2Dpath + "kinetic";
end

end