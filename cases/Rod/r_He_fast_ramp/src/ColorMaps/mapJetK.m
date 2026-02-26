function [map] = mapJetK()

n_original = 1000;
n_addition = 50;

jet_map = jet(n_original); 

colors = [0,0,0;jet_map(1,:)];

add_map = interp1([0, 1], colors, linspace(0,1,n_addition+1));

map = [add_map(1:n_addition,:); jet_map];

end
