function [ data, labels ] = generate_data_band( Nin, k, params)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 1
       Nin = 400; 
    end

    if nargin < 2
       k = 2; 
    end

    if nargin < 3
       params = {};
    end
    
    if ~isfield(params, 'lambda')
        lambda = 0;
    else
       lambda = params.lambda; 
    end
    
    if ~isfield(params, 'noise_level')
        noise = 0; 
    else
        noise = params.noise_level;
    end
    
    if ~isfield(params, 'noise_fraction')
        noise_ratio = 0;
    else
        noise_ratio = params.noise_fraction;
    end

    n = Nin / (2*k);
    N = 2*k*n;

    data = rand(N, 2);
    labels = zeros(N, 1);
    
    range = 1:n;
    
    for ii = 0:k-1
        data(range+ii*n, 1) = data(range+ii*n, 1) - (2*k - ii) + lambda*k;
        labels(range+ii*n) = ii;
        
        data(range+(ii+k)*n, 1) = data(range+(ii+k)*n, 1) - (k - ii);
        labels(range+(ii+k)*n) = ii;
    end

     if noise
         noisy_idx = randperm(N, round(N*noise_ratio));
         data(noisy_idx, :) = data(noisy_idx, :) + (noise*randn(length(noisy_idx),2)); 
     end
end

