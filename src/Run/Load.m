function [out_pp] = Load(name)

out_pp = load(name);

out_pp.msh = GetMesh(out_pp.input.geo_file_content, out_pp.input.p.COORDINATES, out_pp.input.p.MSH_PARAMETERS);

out_pp = rmfield(out_pp,"y_end");

end
