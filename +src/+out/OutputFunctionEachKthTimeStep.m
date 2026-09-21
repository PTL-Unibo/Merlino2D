function OutputFunctionEachKthTimeStep(t,y,flag,K)
persistent stepCounter storedT storedY final_time
global tout_sparse yout_sparse %#ok<GVMIS>

switch flag
    case 'init'
        stepCounter = 1;
        storedT = [];
        storedY = [];
        storedT(1,1) = t(1);  % column vector
        storedY(1,:) = y';    % row to match ode15s output
        final_time = t(end);
    case ''
        stepCounter = stepCounter + 1;
        if (mod(stepCounter,K) == 0) || (t(end) == final_time)
            storedT(end+1,1) = t(end);       % column vector
            storedY(end+1,:) = y(:,end)';    % row to match ode15s output
        end
        
    case 'done'
        % Make results accessible
        tout_sparse = storedT;
        yout_sparse = storedY;
end

end