function [dM] = MatrixDerivative(M, v)
%MATRIXDERIVATIVE Summary of this function goes here
%   This function takes as input a matrix M and a vector v (column or row)
%   If v is a row the derivative of the matrix will be performed with respect 
%   to the colums, if v is a column the derivative of the matrix will be performed with
%   respect to the rows.
%   At all points the derivative is "second-order" accurate.

% First point
% k * M(2) - M(3) = (k-1) * M(1) + M' * (k * dv(1) - dv(1) - dv(2))
% k = ((dv(1) + dv(2)) / dv(1)) ^ 2

% Middle
% k * M(i+1) - M(i-1) = (k-1) * M(i) + M' * (k dv(i+1/2) + dv(i-1/2))
% k = (dv(i-1/2) / dv(i+1/2) ) ^ 2

% Last point
% k * M(end-1) - M(end-2) = (k-1) * M(end) + M' * (-k * dv(end) + dv(end) + dv(end-1))
% k = ((dv(end) + dv(end-1)) / dv(end)) ^ 2

dM = zeros(size(M));

dv = v(2:end) - v(1:end-1);

if isrow(v)
    % First Point
    k = ((dv(1) + dv(2)) / dv(1)) ^ 2;
    dM(:,1) = (k * M(:,2) - M(:,3) - (k-1) * M(:,1)) / (k * dv(1) - dv(1) - dv(2)); 

    % Middle
    k = (dv(1:end-1) ./ dv(2:end)).^2;
    dM(:,2:end-1) = (k .* M(:,3:end) - M(:,1:end-2) - (k-1).* M(:,2:end-1)) ./ (k .* dv(2:end) + dv(1:end-1));

    % Last Point
    k = ((dv(end) + dv(end-1)) / dv(end)) ^ 2;
    dM(:,end) = (k * M(:,end-1) - M(:,end-2) - (k-1) * M(:,end)) / (-k * dv(end) + dv(end) + dv(end-1));
    
elseif iscolumn(v)
    % First Point
    k = ((dv(1) + dv(2)) / dv(1)) ^ 2;
    dM(1,:) = (k * M(2,:) - M(3,:) - (k-1) * M(1,:)) / (k * dv(1) - dv(1) - dv(2)); 

    % Middle
    k = (dv(1:end-1) ./ dv(2:end)).^2;
    dM(2:end-1,:) = (k .* M(3:end,:) - M(1:end-2,:) - (k-1).* M(2:end-1,:)) ./ (k .* dv(2:end) + dv(1:end-1));

    % Last Point
    k = ((dv(end) + dv(end-1)) / dv(end)) ^ 2;
    dM(end,:) = (k * M(end-1,:) - M(end-2,:) - (k-1) * M(end,:)) / (-k * dv(end) + dv(end) + dv(end-1));

end

end
