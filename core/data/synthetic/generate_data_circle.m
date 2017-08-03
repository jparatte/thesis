function [ data, labels ] = generate_data_circle( Nin, k, params )
%GENERATE_DATA_CIRCLE Summary of this function goes here
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
    
    labels = zeros(N, 1);
    
    range = 1:n;
    
    theta = 2*pi*(1/(2*k))*rand(N, 1);
    radius = sqrt(rand(N, 1)); %to uniformly distribute over the circle
    
    for ii = 0:k-1
        theta(range+ii*n, 1) = theta(range+ii*n, 1) + (pi/k)*(k - ii) + pi*lambda;
        labels(range+ii*n) = ii;
        
        theta(range+(ii+k)*n, 1) = theta(range+(ii+k)*n, 1) + pi + (pi/k)*(k - ii);
        labels(range+(ii+k)*n) = ii;
    end

    data = zeros(N, 2);
    data(:,1) = radius .* cos(theta);
    data(:,2) = radius .* sin(theta);

     if noise
         noisy_idx = randperm(N, round(N*noise_ratio));
         data(noisy_idx, :) = data(noisy_idx, :) + (noise*randn(length(noisy_idx),2)); 
     end
end

