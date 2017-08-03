%% Example of localized filters

%% Initialization

clear all;

%% Parameters

sigma = 0.1;
nb_cores = 8;
sampling_factor = 0.05;

%% Read the image

img = imread('data/moiry.png');
img = imresize(img, 0.25);

%%

% Create the graph using image patches
param.nnparam.use_flann = 1;
param.nnparam.k = 8;
param.patch_size = 3;
param.rho = 10;

h = size(img, 1);
w = size(img, 2);

param.nnparam.flann_params = flann_params(h*w, param.patch_size, 'kdtree', nb_cores);
tic;
[G, ~] = gsp_patch_graph(rgb2gray(img),param);
toc;
G = gsp_estimate_lmax(G);

ns = round(G.N * sampling_factor);

%% Uniform sampling

[~, samples_uniform] = sampling_uniform(G, ns);
sampling_signal_uniform = zeros(G.N, 1);
sampling_signal_uniform(samples_uniform) = 1;
sampling_mask_uniform = reshape(sampling_signal_uniform, h, w);

samples_uniform_img = zeros(h, w, 3);
samples_uniform_img(:,:,1) = round(double(img(:,:,1)) .* sampling_mask_uniform) ;
samples_uniform_img(:,:,2) = round(double(img(:,:,2)).* sampling_mask_uniform) ;
samples_uniform_img(:,:,3) = round(double(img(:,:,3)).* sampling_mask_uniform) ;

imshow(uint8(samples_uniform_img))

%% Reconstruct with uniform

%% Active sampling

samples_active = sampling_active(G, ns);

sampling_signal_active = zeros(G.N, 1);
sampling_signal_active(samples_active) = 1;
sampling_mask_active = reshape(sampling_signal_active, h, w);

samples_active_img = zeros(h, w, 3);
samples_active_img(:,:,1) = round(double(img(:,:,1)) .* sampling_mask_active) ;
samples_active_img(:,:,2) = round(double(img(:,:,2)).* sampling_mask_active) ;
samples_active_img(:,:,3) = round(double(img(:,:,3)).* sampling_mask_active) ;

imshow(uint8(samples_active_img))
