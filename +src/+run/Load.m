function [out] = Load()

try
    % Load save -----------------------------------------------------------
    out = src.run.Merlino2D("","input_script.m","init");
    out2 = load("results.mat");

    % merge the 2 struct -------------------------------------------------              
    fn = fieldnames(out2);              
    fn(fn=="y_end") = []; % remove y_end
    for k = 1:numel(fn)                 
        out.(fn{k}) = out2.(fn{k});     
    end                                 
    % ---------------------------------------------------------------------
catch ME
    fprintf("%s\n", "Load failed due to: " + ME.message)
    out = 0;
end

end