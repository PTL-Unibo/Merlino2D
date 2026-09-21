function [status] = OutputFunctionCurrent(t,y,flag,odefun_mixed,scale)
persistent time_array I_array pl t0 abort

switch flag
    case 'init'
        abort = 0;
        fig = figure("WindowStyle","normal");
        ax = axes(fig);
        uicontrol('Style', 'pushbutton', 'String', 'Abort','Position', [0 0 80 30], 'Callback', @pressed)
        t0 = t(1);
        t_end = t(end);
        time_array = t0;
        [~,~,~,~,~,~,~,I0,~,~] = odefun_mixed(t0,y);
        I_array = I0;
        if scale == "log"
            pl = semilogx(ax,time_array,I_array);
        elseif scale == "lin"
            pl = plot(ax,time_array,I_array);
        end
        xlim([t0, t_end])
        grid on
        ylabel("current $(\mathrm{A})$", "Interpreter","latex")
        xlabel("time $(\mathrm{s})$", "Interpreter","latex")
        grid on
        ax.TickLabelInterpreter = "latex";
        ax.FontSize = 15;
    case ''
        time_array = [time_array, t(end)];
        [~,~,~,~,~,~,~,I,~,~] = odefun_mixed(t(end), y(:,end));
        I_array = [I_array, I];
        pl.XData = time_array;
        pl.YData = I_array;
        xlim([t0, t(end)])
    case 'done'
        assignin("base","bigT",time_array)
        assignin("base","bigI",I_array)
end

drawnow
status = abort;

    function pressed(~,~)
        abort = 1;
    end

end