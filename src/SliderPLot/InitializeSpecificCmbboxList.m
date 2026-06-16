function [visible,list] = InitializeSpecificCmbboxList(i,ns)

if i <= ns % species
    visible = 'on';
    list = {"cells","nodes","omega"};
elseif i == ns + 1 % rho
    visible = 'on';
    list = {"cells","nodes"};
elseif i == ns + 2 % phi
    visible = 'off';
    list = {};
elseif i == ns + 3 % E
    visible = 'on';
    list = {"cells","nodes","quiver"};
elseif i == ns + 4 % fx
    visible = 'on';
    list = {"cells","nodes"};
else % reactions
    visible = 'on';
    list = {"rate","coefficient"};
end

end