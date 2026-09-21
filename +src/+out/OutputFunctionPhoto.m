function OutputFunctionPhoto(t,y,flag,photo_update_frequency,p,extra_num_char)
global Sph %#ok<GVMIS>
persistent counter final_time num_char_printed

switch flag
    case 'init'
        counter = 1;
        final_time = t(end);
        % the initialization of Sph was done in Merlino2D
        num_char_printed = fprintf("%d: Updated photoionization, maximum value = %e\n", counter, max(Sph));
    case ''
        counter = counter + 1;
        if (mod(counter,photo_update_frequency) == 0) || (t(end) == final_time)
            UpdatePhoto(y(:,end),t(end),p);
            fprintf(repmat('\b',1,num_char_printed+extra_num_char));
            num_char_printed = fprintf("%d: Updated photoionization, maximum value = %e\n", counter, max(Sph));
            fprintf(repmat(' ',1,extra_num_char));
        end

    case 'done'
        % do nothing
end

end