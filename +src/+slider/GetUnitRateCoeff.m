function [unit] = GetUnitRateCoeff(reactions_string)
reactions_string = strrep(reactions_string," + "," ++ ");
members = split(reactions_string,"->");
n = numel(split(members(1), "++"));
unit = "\mathrm{m}^{"+(3*n - 3)+"}\mathrm{s}^{-1}";
end