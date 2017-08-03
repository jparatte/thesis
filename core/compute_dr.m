function [ Y, t, tmt ] = compute_dr( data, name, target_dim, params )
%COMPUTE_DR Summary of this function goes here
%   Detailed explanation goes here

    t = -1;
    tmt = -1;
    if nargin < 3
       target_dim = 2; 
    end

    fct_name = sprintf('dr_%s', name);
    
    ts = tic;
    try
        if isstruct(data)
            if exist('params', 'var')
                [Y, t, tmt] = feval(fct_name, data, target_dim, params);
            else
                [Y, t, tmt] = feval(fct_name, data, target_dim);
            end
        else %Might remove this part
            if exist('params', 'var')
                [Y, t, tmt] = feval(fct_name, indata, target_dim, params);
            else
                [Y, t, tmt] = feval(fct_name, indata, target_dim);
            end
        end
    catch me
        fprintf('An error occurred or the function %s is not available.\n', name);
        fprintf('%s \n', me.message);
    end

    if t < 0
        t = toc(ts);
    end

end

