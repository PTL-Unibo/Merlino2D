function [seconds] = StringToSeconds(string)
seconds = 0;

celll = split(string,"d");
if numel(celll) == 2
    seconds = seconds + 3600*24*str2double(celll{1});
    string = celll{2};
end

celll = split(string,"h");
if numel(celll) == 2
    seconds = seconds + 3600*str2double(celll{1});
    string = celll{2};
end

celll = split(string,"m");
if numel(celll) == 2
    seconds = seconds + 60*str2double(celll{1});
    string = celll{2};
end

celll = split(string,"s");
if numel(celll) == 2
    seconds = seconds + str2double(celll{1});
end

end

