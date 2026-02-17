function [p] = GetPath(id)
arguments
    id (1,:) char {mustBeMember(id,{'gmsh','geo','data','kin','src','loki'})}
end

Merlino2Dpath = "C:/Users/Faz98/Documents/GitHub/Merlino2D/";

switch id
    case 'gmsh'
        path_gmsh = "C:/GMSH/gmsh.exe";
        p = path_gmsh;
    case 'loki'
        path_loki = "C:/Users/Faz98/Documents/GitHub/LoKI-B/Code";
        p = path_loki;
    case 'geo'
        p = Merlino2Dpath + "geo";
    case 'data'
        p = Merlino2Dpath + "data";
    case 'kin'
        p = Merlino2Dpath + "kinetic";
    case 'src'
        p = Merlino2Dpath + "src";
end

end