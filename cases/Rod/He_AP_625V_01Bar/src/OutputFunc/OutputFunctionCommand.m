function [status,extra_num_char] = OutputFunctionCommand(t,~,flag,scale)
persistent t0 t_end start_wct num_char

extra_num_char = 0;

switch flag
    case 'init'
        t0 = t(1);
        t_end = t(end);
        start_wct=datetime("now");
        num_char = fprintf("Elapsed Time = %s\n"+...
            "t = %.3e s\n"+...
            "|%s%s| %.3f%%\n",...
            SecondsToString(0),...
            0,...
            repmat('-',1,0),repmat(' ',1,100),...
            0);

    case ''
        if scale == "log"
            perc=(log10(t(end))-log10(t0))/(log10(t_end)-log10(t0));
        elseif scale == "lin"
            perc=(t(end)-t0)/(t_end-t0);
        end
        elapsed_time_seconds = seconds(datetime("now")-start_wct);
        fprintf(repmat('\b',1,num_char));
        num_char = fprintf("Elapsed Time = %s\n"+...
            "t = %.3e s\n"+...
            "|%s%s| %.3f%%\n",...
            SecondsToString(elapsed_time_seconds),...
            t(end),...
            repmat('-',1,round(perc*100)),repmat(' ',1,100-round(perc*100)),...
            perc*100);
        extra_num_char = num_char;

    case 'done'
        % do nothing
end

status = 0;

end