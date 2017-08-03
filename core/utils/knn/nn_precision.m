function [ p ] = nn_precision( nn_gt, nn_target )
%NN_PRECISION Summary of this function goes here
%   Detailed explanation goes here

    [n, k] = size(nn_gt);
    
    nb_common = 0;
    for ii = 1:n
       nb_common = nb_common + length(intersect(nn_gt(ii,:), nn_target(ii,:))); 
    end

    p = nb_common/(n*k);
end

