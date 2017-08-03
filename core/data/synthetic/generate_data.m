function [ data ] = generate_data(N, k, params )
%GENERATE_DATA Summary of this function goes here
%   Detailed explanation goes here
        fct_name = sprintf('generate_data_%s', params.name);
    
    try
        [dat, lab] = feval(fct_name, N, k, params);
        data.raw = dat;
        data.embedding = dat;
        data.labels = lab;
        data.N = size(dat, 1);
        data.D = size(dat, 2);
    catch
        fprintf('The generate data %s does not seem to be available', name);
    end

end

