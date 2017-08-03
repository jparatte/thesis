function [ data, labels ] = generate_data_square( Nin, k, params )
%GENERATE_DATA_ Summary of this function goes here
%   Detailed explanation goes here


    if nargin < 1
       Nin = 400; 
    end

    if nargin < 2
       k = 4; 
    elseif round(sqrt(k)) ~= sqrt(k) 
        disp('Error : k must be a square');
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
    
    if (lambda > 0.5)
       ilambda = 1;
       jlambda = 2*(lambda - 0.5);
    else
       ilambda = 2*lambda;
       jlambda = 0;
    end
    
    n = Nin / (4*k);
    N = 4*k*n;
    sk = sqrt(k);
    gap = k*n;
    
    range = 1:n;
    
    data = rand(N, 2);
    labels = zeros(N, 1); 
    
    
     c = 0;
     for ii = 0:(sk-1)
         for jj = 0:(sk - 1)
             data(range + c, 1) = data(range + c, 1) + ii;
             data(range + c, 2) = data(range + c, 2) + jj;
             labels(range+c) = sk*ii + jj;
             
             data(range + c + gap, 1) = data(range + c + gap, 1) + ii + (1 - ilambda)*sk;
             data(range + c + gap, 2) = data(range + c + gap, 2) + jj;
             labels(range + c + gap) = sk*ii + jj;
             
             data(range + c + 2*gap, 1) = data(range + c + 2*gap, 1) + ii;
             data(range + c + 2*gap, 2) = data(range + c + 2*gap, 2) + jj + (1 - jlambda)*sk; 
             labels(range + c + 2*gap) = sk*ii + jj;
             
             data(range + c + 3*gap, 1) = data(range + c + 3*gap, 1) + ii + (1 - ilambda)*sk;             
             data(range + c + 3*gap, 2) = data(range + c + 3*gap, 2) + jj + (1 - jlambda)*sk;
             
             labels(range + c + 3*gap) = sk*ii + jj;
            c = c + n;
         end
     end
     
     if noise
         noisy_idx = randperm(N, round(N*noise_ratio));
         data(noisy_idx, :) = data(noisy_idx, :) + (noise*randn(length(noisy_idx),2)); 
     end
     
end

