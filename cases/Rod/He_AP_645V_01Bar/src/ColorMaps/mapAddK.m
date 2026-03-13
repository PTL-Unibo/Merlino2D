function [map] = mapAddK(name,n)
arguments
    name (1,:) char
    n = 1;
end

n_original = 19*n;
n_addition = n;

the_map = feval(name,n_original);

colors = [0,0,0;the_map(1,:)];

add_map = interp1([0, 1], colors, linspace(0,1,n_addition+1));

map = [add_map(1:n_addition,:); the_map];

end
