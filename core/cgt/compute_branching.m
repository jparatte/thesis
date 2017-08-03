function [ K, L ] = compute_branching( S )
%COMPUTE_BRANCHING Summary of this function goes here
%   Detailed explanation goes here

    min_k = 10;
    max_l = floor(log(S) / log(min_k));
    ll = 2:max_l;
    ks = nthroot(S, ll);
    err = abs(ks - round(ks));
    [~, idx] = min(err);

    L = ll(idx);
    K = round(ks(idx));

    fprintf('Best value found for S=%d : K^L=%d (K=%d, L=%d)\n', S, K^L, K, L); 

end

