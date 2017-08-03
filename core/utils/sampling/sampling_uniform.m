function [ samples_idx ] = sampling_uniform( G, ns, params )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin < 3
       params = {}; 
    end

    N = G.N;
    k = ns;
    
    if isfield(params, 'samples')
        samples_idx = fast_wrs( 1:N, k, ones(N, 1), params.samples);
    else
        samples_idx = fast_wrs( 1:N, k, ones(N, 1));
    end
    
end
