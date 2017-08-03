function [ v ] = vol( G, idx )
%VOL Summary of this function goes here
%   Detailed explanation goes here
    v = sum(G.d(idx));
end

