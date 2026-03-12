function [cmd_text] = CreateCmdMshParameters(MSHparameters)

myfields = fieldnames(MSHparameters);
num_fields = numel(myfields);
cmd_text = "";

if num_fields > 0
    for i = 1:num_fields
        cmd_text = cmd_text + " -setnumber " + myfields{i} + " " + MSHparameters.(myfields{i});
    end
end

end

