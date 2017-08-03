function [ results, nl_range, nf_range ] = benchmark_scores_synthetic_noise( score, data_type, params )
%BENCHMARK_SCORES_SYNTHETIC Summary of this function goes here
%   Detailed explanation goes here
    %% B : ACI

    if nargin < 3
       params = {}; 
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
    
    
    dataparams = {};
    dataparams.name = data_type;
    
    dataparams.lambda = 1;
    
    nl_range = [0,0.2,0.4,0.8,1.0,2.0, 3.0];
    nf_range = 0:0.1:0.5;
    
    K = length(nl_range);
    M = length(nf_range);
    results = zeros(K, M);
    
    k = 4;
    N = 2*k*n;
    
    for jj = 1:K
        
        dataparams.noise_level = nl_range(jj);    
        result_k = zeros(M, NR);
        
        for ii = 1:M
            dataparams.noise_fraction = nf_range(ii);
            for rr = 1:NR
                data =  generate_data(N, k, dataparams);

                if strcmp(score, 'aci')
                    result_k(ii, rr) = compute_quality( data, score, 'cheeger' );
                else
                    result_k(ii, rr) = compute_quality( data, score);
                end
            end
        
        end
        
        results(jj, :) = mean(result_k, 2);
    end
    
end

