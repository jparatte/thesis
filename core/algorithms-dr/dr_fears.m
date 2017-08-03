function [ Y, t, tmt ] = dr_fears( data, target_dim, param )
%DR_FEARS Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('param', 'var')
        param = {};
    end

    if isfield(data, 'G')
        G = data.G;
    else
        G = knn_graph(data);
    end
    
    if ~isfield(param, 'order')
        param.order = 50;
    end
    
    G = gsp_estimate_lmax(G);

    param.verbose = 0;
    
    ts = tic;
    Y = gsp_eigenspace_estimation(G, target_dim, param);
    t = toc(ts);
    tmt = t; 
end

