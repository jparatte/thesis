function [ params ] = flann_params( n, d, algo, nb_cores )
%FLANN_PARAMS Get params using data parameters
%   Heuristics based on constant cell size

    if ~exist('nb_cores', 'var')
       nb_cores = 1; 
    end
    if ~exist('algo', 'var')
       algo = 'kdtree'
    end
    
    %Parameters to influence precision
    avg_log2_dim = 5; % lower is more precise (min : 0)
    mu_checks = 0.5; % higher is more precise (max : 1)
    mu_trees = 0.5;  % higher is more precise (max : 1)

    mu_d = max(round(log2(d) - avg_log2_dim), 1);
    lmu_d = max(round(log2(mu_d)), 1);
    
    min_trees = 4;
    min_checks = 256;

    switch algo
        case 'kdtree'
            params = struct('algorithm','kdtree', 'cores', nb_cores);
            params.checks = max(pow2(ceil(log2(n)*mu_checks))*mu_d, min_checks);
            params.trees = max(ceil(log2(n)*mu_trees)*lmu_d, min_trees);
        case 'kmeans'
            params = struct('algorithm','kmeans', 'cores', nb_cores);
            %todo
        otherwise
            error('Algo for flann not found');
    end
    
end

