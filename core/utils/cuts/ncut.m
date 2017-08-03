function [ nc, hist_nc ] = ncut( G, labels )
%NCUT Compute ACI based on NCut scores
%   Detailed explanation goes here
    cats = unique(labels);
    K = length(cats);
    N = G.N;
    
    nc = 0;
    hist_nc = zeros(K, 1);
    
    for k = 1:K
        vci = find(labels == cats(k));
        vcic = find(labels ~= cats(k));
        nci = length(vci);
        
        hist_nc(k) = cut(G, vci, vcic) * (1/vol(G, vci) + 1/vol(G, vcic));
        nc = nc + nci * hist_nc(k);
    end
    
    nc = nc / N;
end

