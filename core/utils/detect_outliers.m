function [ outliers, ntig ] = detect_outliers( G )
%DETECT_OUTLIERS Summary of this function goes here
%   Detailed explanation goes here

    band = 0.01;
    gamma = 0.1;
    min_sigma = 0.09;
    
    g = gsp_design_heat(G, get_heat_tau(band));
    ntig = gsp_norm_tig(G, g, 0);
    
    mu = mean(ntig);
    sigma = std(ntig);
    
    outliers = [];
    if sigma > min_sigma
        outliers = find(ntig > mu + gamma*sigma);
    end
end

