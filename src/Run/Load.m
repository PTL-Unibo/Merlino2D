function [out_pp] = Load(name)
global BentoCaraca %#ok<GVMIS>

out_pp = load(name);

if BentoCaraca
    out_pp.msh = PreProcessing(GetPath("geo")+"/"+out_pp.input.p.MSH, out_pp.input.p.COORDINATES, "remove_dielectric","yes"); 
else
    out_pp.msh = GetMesh(out_pp.input.geo_file_content, out_pp.input.p.COORDINATES, out_pp.input.p.MSH_PARAMETERS);
end

out_pp = rmfield(out_pp,"y_end");

end
