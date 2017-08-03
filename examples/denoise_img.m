function [ img_denoised ] = denoise_img(G, img_noisy, tau )
%DENOISE_IMG Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
        tau = 100;
    end

    %% Create the patch graph

%     param.nnparam.use_flann = 1;
%     %param.nnparam.sigma = sigma;
%     param.nnparam.k = 5;
%     param.patch_size = 5;
%     param.rho = 0.2;
% 
%     [G, signal] = gsp_patch_graph(img_noisy,param);
%     G = gsp_estimate_lmax(G);

    h = gsp_design_heat(G, tau);
    %denoised_signal = gsp_filter_analysis(G, h, signal);
    denoised_signal = gsp_filter_analysis(G, h, img_noisy(:));
    
    img_denoised = reshape(denoised_signal, size(img_noisy));
end

