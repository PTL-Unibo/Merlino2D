function [p] = GetPath(id)
arguments
    id (1,:) char {mustBeMember(id,{'gmsh','geo','data','kin','loki','src','func'})}
end

switch id
    case 'gmsh'
        path_gmsh = "C:/Users/fabio/Documents/gmsh-4.13.1-Windows64/gmsh.exe";
        p = path_gmsh;
    case 'loki'
        path_loki = "C:/Users/fabio/Documents/LoKI-B/Code";
        p = path_loki;
    case 'geo'
        p = "geo";
    case 'data'
        p = "data";
    case 'kin'
        p = "kinetic";
    case 'src'
        p = "+src";
    case 'func'
        p = "+func";
end

end