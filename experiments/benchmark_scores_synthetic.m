function [ results, shifts ] = benchmark_scores_synthetic( score, data_type, params )
%BENCHMARK_SCORES_SYNTHETIC Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
       params = {}; 
    end
    
    if ~isfield(params, 'step')
        step = 0.05;
    else
        step = params.step;
    end
    
    if ~isfield(params, 'class_size')
        n = 200;
    else
        n = params.class_size;
    end
    
    if ~isfield(params, 'nb_runs')
        NR = 10;
    else
        NR = params.nb_runs;
    end
    
    if ~isfield(params, 'noise_level')
       nl = 0; 
    else
        nl = params.noise_level;
    end
    
    if ~isfield(params, 'noise_fraction')
        nf = 0; 
    else
        nf = params.noise_fraction;
    end
    
    
    shifts = 0:step:1;
    M = length(shifts);
    
    dataparams = {};
    dataparams.name = data_type;
    dataparams.noise_level = nl;
    dataparams.noise_fraction = nf;
    
    switch data_type
        case 'square'
            vrange = [4, 16];
        otherwise
            vrange = 2:5;
    end
    
    K = length(vrange);
    results = zeros(M, K);
    
    for jj = 1:K

        k = vrange(jj);
           
        N = 2*k*n;
        
        result_k = zeros(M, NR);

        for rr = 1:NR
            for ii = 1:M
                dataparams.lambda = shifts(ii);

                data = generate_data(N, k, dataparams);
                
                if strcmp(score, 'aci')
                    if isfield(params, 'aci')
                        aci_type = params.aci;
                    else
                        aci_type = 'cheeger';
                    end
                    result_k(ii, rr) = compute_quality( data, score, aci_type );
                else
                    result_k(ii, rr) = compute_quality( data, score, params);
                end

            end
        end
        
        results(:,jj) = mean(result_k, 2);
    
    end
    
end

