function [M] = CreateMatrixInterpCutLine(A,B,msh)

Ax = A(1);
Ay = A(2);

Bx = B(1);
By = B(2);

x = linspace(Ax,Bx,1e3);
y = linspace(Ay,By,1e3);

TR = triangulation(msh.ns_from_c,[msh.xn,msh.yn]);
c = pointLocation(TR,[x(:),y(:)]);

X = msh.xn(msh.ns_from_c);
Y = msh.yn(msh.ns_from_c);

L1 = abs(0.5 * ((X(c,2)-X(c,3)).*y(:) + (X(c,3)-x(:)).*Y(c,2) + (x(:)-X(c,2)).*Y(c,3)));
L2 = abs(0.5 * ((x(:)-X(c,3)).*Y(c,1) + (X(c,3)-X(c,1)).*y(:) + (X(c,1)-x(:)).*Y(c,3)));
L3 = abs(0.5 * ((X(c,2)-x(:)).*Y(c,1) + (x(:)-X(c,1)).*Y(c,2) + (X(c,1)-X(c,2)).*y(:)));

L1 = L1 .* msh.inv_vol(c);
L2 = L2 .* msh.inv_vol(c);
L3 = L3 .* msh.inv_vol(c);

I = repmat(1:numel(c),1,3)';
J = reshape(msh.ns_from_c(c,:),[],1);
S = [L1; L2; L3];

M = sparse(I,J,S,numel(c),msh.Nn);

end