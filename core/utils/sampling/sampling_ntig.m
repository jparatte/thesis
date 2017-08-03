function [ samples_idx ] = sampling_ntig( G, ns, params )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin < 3
       params = {}; 
    end

    N = G.N;
    k = ns;
    
    g = gsp_design_expwin(G, 0.05);
    ntig = gsp_norm_tig(G, g, 0);
    
    if isfield(params, 'samples')
        samples_idx = fast_wrs( 1:N, k, abs(ntig), params.samples);
    else
        samples_idx = fast_wrs( 1:N, k, abs(ntig));
    end
    
end
