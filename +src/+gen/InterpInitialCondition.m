function [N_new] = InterpInitialCondition(x_old,y_old,N_old,x,y,ns,Nc)

N_new = zeros(Nc,ns);
N_old_matrix = reshape(N_old,[],ns);

for s = 1:ns
    for i = 1:Nc
        d = (x_old - x(i)).^2 + (y_old - y(i)).^2;
        [~,k] = min(d); 
        N_new(i,s) = N_old_matrix(k,s);
    end
end

N_new = N_new(:);

end