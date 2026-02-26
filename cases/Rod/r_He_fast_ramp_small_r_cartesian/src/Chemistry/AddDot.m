function [str_out] = AddDot(str_in)
str_in = regexprep(str_in, '(?<!\.)\*', '.*'); % replace * with .*
str_in = regexprep(str_in, '(?<!\.)/',  './'); % replace / with ./
str_in = regexprep(str_in, '(?<!\.)\^', '.^'); % replace ^ with .^
str_out = str_in;
end
