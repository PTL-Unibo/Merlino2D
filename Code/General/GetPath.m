function [p] = GetPath(id)
arguments
    id (1,:) char {mustBeMember(id,{'gmsh','geo','data','kin'})}
end

Merlino2Dpath = "";

switch id
    case 'gmsh'
        path_gmsh = "";
        p = path_gmsh;
    case 'geo'
        p = Merlino2Dpath + "geo";
    case 'data'
        p = Merlino2Dpath + "data";
    case 'kin'
        p = Merlino2Dpath + "kinetic";
end

end