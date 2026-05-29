function [status] = GeneralOutputFunction(t,y,flag,...
    output_function,scale,...
    ph_is_on,photo_update_frequency,p,...
    sporadic_save_is_on,save_each_k_tinesteps,odefun_mixed)
persistent extra_num_char
if isempty(extra_num_char)
    extra_num_char = 0; % Initialize if not set
end

if ph_is_on
    OutputFunctionPhoto(t,y,flag,photo_update_frequency,p,extra_num_char);
end
if sporadic_save_is_on
    OutputFunctionEachKthTimeStep(t,y,flag,save_each_k_tinesteps);
end

switch output_function
    case 'bar'
        status = OutputFunctionProgressBar(t,y,flag,scale);
    case 'cmd'
        [status,extra_num_char] = OutputFunctionCommand(t,y,flag,scale);
    case 'i'
        status = OutputFunctionCurrent(t,y,flag,odefun_mixed,scale);
end

end