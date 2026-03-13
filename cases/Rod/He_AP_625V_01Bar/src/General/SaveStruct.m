function [] = SaveStruct(name,input_struct)
cell_names = fieldnames(input_struct);
cmd_text = "save(""" + name + """,";
for c = cell_names'
    cmd_text = cmd_text + """" + string(c) + """,";
    eval(string(c) + " = input_struct.(""" + string(c) + """);");
end
cmd_text = cmd_text + """-v7.3"");";
eval(cmd_text);
fprintf("%s\n","Saved results in " + name)
end