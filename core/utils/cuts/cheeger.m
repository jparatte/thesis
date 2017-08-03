function [ ch, hist_ch ] = cheeger( G, labels )
%CHEEGER Compute the ACI base on Cheeger scores
%   Detailed explanation goes here
    
    cats = unique(labels);
    K = length(cats);
    N = G.N;
    
    ch = 0;
    hist_ch = zeros(K, 1);
    
    for k = 1:K
        vci = find(labels == cats(k));
        vcic = find(labels ~= cats(k));
        nci = length(vci);
        hist_ch(k) = cut(G, vci, vcic) / min(vol(G, vci), vol(G, vcic));
        ch = ch + nci * hist_ch(k);
    end
    
    ch = ch / N;
end

