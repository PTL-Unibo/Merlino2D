function [map] = mapCBKRY()

colors = [0,1,1;
          0,0,1;
          0,0,0;
          1,0,0;
          1,1,0]; 

map = interp1([0, 1, 2, 3, 4]/4, colors, linspace(0,1,1e3));

end
