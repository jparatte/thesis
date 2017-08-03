function [ c ] = cut(G, idx_a, idx_b )
%CUT Summary of this function goes here
%   Detailed explanation goes here
    c = sum(sum(G.W(idx_a, idx_b)));
end

