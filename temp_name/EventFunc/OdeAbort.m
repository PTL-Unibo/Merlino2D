function [value,isterminal,direction] = OdeAbort(~,~)
value = double(ishandle(95));
isterminal = 1;
direction = 0 ;
end