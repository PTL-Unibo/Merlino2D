function [out_pp] = Load(name)

out_pp = load(name);

% for back compatibility (can be removed when distributing code) ----------
if ~isfield(out_pp.input.p,"MSHparameters")                           %   |
    input = out_pp.input;                                             %   |                       
    input.p.MSHparameters = struct;                                   %   |
    out_pp.input = input;                                             %   |
    save(name,"input","-append")                                      %   |
end                                                                   %   |
% -------------------------------------------------------------------------

out_pp.msh = GetMesh(out_pp.input.geo_file_content, out_pp.input.p.MSHparameters);

out_pp = rmfield(out_pp,"y_end");

end
