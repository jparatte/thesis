%% Example of graph-based image denoising

% Initialization

clear all;

% Parameters

sigma = 0.1;
nb_cores = 12;

% Read the image

img = imread('data/barracudas.png');
img = imresize(img, 0.75);

% Create a noisy version
img = double(img) ./ 255;
img_noisy = img + sigma*randn(size(img));

% Convert to L*a*b*
img_noisy = rgb2lab(uint8(img_noisy.*255));

% Create the graph using image patches
param.nnparam.use_flann = 1;
param.nnparam.k = 10;
param.patch_size = 7;
param.rho = 2;
% Auto flann params
param.nnparam.flann_params = flann_params(size(img, 1)*size(img, 2), param.patch_size, 'kdtree', nb_cores);

tic;
[G, signal] = gsp_patch_graph(img_noisy(:,:,1),param);
G = gsp_estimate_lmax(G);
toc;

% Graph-based denoising (per channel)
img_denoised_graph = zeros(size(img_noisy));
img_denoised_graph(:,:,1) = denoise_img(G, img_noisy(:,:,1), 75);
img_denoised_graph(:,:,2) = denoise_img(G, img_noisy(:,:,2), 100);
img_denoised_graph(:,:,3) = denoise_img(G, img_noisy(:,:,3), 100);

% Wavelet denoising (per channel)
img_denoised_wavelet = zeros(size(img_noisy));
img_denoised_wavelet(:,:,1) = denoise_wavelet(img_noisy(:,:,1));
img_denoised_wavelet(:,:,2) = denoise_wavelet(img_noisy(:,:,2));
img_denoised_wavelet(:,:,3) = denoise_wavelet(img_noisy(:,:,3));

% Display the result
figure;
subplot(221)
imshow(img);
subplot(222)
imshow(lab2rgb(img_noisy));
subplot(223)
imshow(lab2rgb(img_denoised_graph));
subplot(224)
imshow(lab2rgb(img_denoised_wavelet));

% Compute and display SNR
fprintf('Noisy image (SNR) : %f\n', snr(img, lab2rgb(img_noisy)));
fprintf('Denoised image - graph (SNR) : %f\n', snr(img, lab2rgb(img_denoised_graph)));
fprintf('Denoised image - wavelet (SNR) : %f\n', snr(img, lab2rgb(img_denoised_wavelet)));

%%
imwrite(img, 'export/ch1_example_denoising_orig.png');
imwrite(lab2rgb(img_noisy), 'export/ch1_example_denoising_noisy.png');
imwrite(lab2rgb(img_denoised_graph), 'export/ch1_example_denoising_graph.png');
imwrite(lab2rgb(img_denoised_wavelet), 'export/ch1_example_denoising_wavelet.png')
