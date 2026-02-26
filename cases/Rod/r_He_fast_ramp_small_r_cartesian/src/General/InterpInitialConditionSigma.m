function [sigma_new] = InterpInitialConditionSigma(x_old,y_old,sigma_old,x,y,Nd)

sigma_new = zeros(Nd,1);

for i = 1:Nd
    d = (x_old - x(i)).^2 + (y_old - y(i)).^2;
    [~,k] = min(d); 
    sigma_new(i) = sigma_old(k);
end

end