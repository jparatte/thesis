function [ na ] = nassoc( G, labels )
%NASSOC Summary of this function goes here
%   Detailed explanation goes here
    cats = unique(labels);
    K = length(cats);
    
    na = 0;
    
    for k = 1:K
        s = find(labels == cats(k));
        sc = find(labels ~= cats(k));
        
        na = na + (cut(G, s, s) / vol(G, s)) + (cut(G, sc, sc) / vol(G, sc));
    end

end

