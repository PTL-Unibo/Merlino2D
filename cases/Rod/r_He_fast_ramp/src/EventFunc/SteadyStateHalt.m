function [value, isterminal, direction] = SteadyStateHalt(t,y,threshold)
persistent y_prec

if isempty(y_prec)
    y_prec = zeros(size(y));
end

rel_diff_vector = abs(y_prec - y)./y;
value = max(rel_diff_vector) - threshold;
y_prec = y;

isterminal = 1; % Stop the solver when condition is met
direction = -1; % Detect when decreasing

end
