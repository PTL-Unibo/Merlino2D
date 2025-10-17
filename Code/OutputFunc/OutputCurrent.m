function status = OutputCurrent(t,y,flag,func,e,sn,indices_emitter,areaf_emitter,T_start)
persistent current time ax previous_mean

% T_start is the time instant after which we start to look for steady state

status = 0;
stop = 0;

if isempty(flag)
    % normal time step
    n_steps = numel(t);
    I = zeros(1, n_steps);
    for i = 1:n_steps
        [~,~,~,~,~,~,Gamma_x,Gamma_y] = func(t(i),y(:,i));
        J_e_emitter = -e *(sn(indices_emitter,1).*Gamma_x(indices_emitter) + sn(indices_emitter,2).*Gamma_y(indices_emitter));
        I(i) = sum(J_e_emitter .* areaf_emitter);
    end
    current = [current, I];
    time = [time, t];
    if numel(current) > 20
        current = current(end-19:end);
        time = time(end-19:end);
    end
else
    if flag == "init"
        % first time step
        time = t(1);
        [~,~,~,~,~,~,Gamma_x,Gamma_y] = func(t(1),y);
        J_e_emitter = -e *(sn(indices_emitter,1).*Gamma_x(indices_emitter) + sn(indices_emitter,2).*Gamma_y(indices_emitter));
        current = sum(J_e_emitter .* areaf_emitter);
        previous_mean = current;
        fig = figure(95);
        ax = axes(fig);
    elseif flag == "done"
        % last time step
        stop = 1;
    end
end

m = mean(current);
if ~stop
    if (numel(current) > 1) && (t(end) > T_start)
        if abs((m - previous_mean)/previous_mean) < 1e-4
            if (abs((max(current) - m)/m) < 0.01) && (abs((m - min(current))/m) < 0.01)
                status = 1;
            end
        end
    end
end

plot(ax, time, current, ".-")
title(ax, num2str(abs((m - previous_mean)/previous_mean),"%.3e"))
grid on
drawnow;

previous_mean = m;

end
