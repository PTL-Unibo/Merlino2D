function [map] = mapTurboK()

n_original = 1000;
n_addition = 50;

turbo_map = turbo(n_original); 

colors = [0,0,0;turbo_map(1,:)];

add_map = interp1([0, 1], colors, linspace(0,1,n_addition+1));

map = [add_map(1:n_addition,:); turbo_map];

end
