%% Example of localized filters

%% Initialization

clear all;

%% Parameters

sigma = 0.1;
nb_cores = 12;

%% Read the image

img = imread('data/moiry.png');
%img = imresize(img, 0.75);

%%

% Create the graph using image patches
param.nnparam.use_flann = 1;
param.nnparam.k = 8;
param.patch_size = 7;
param.rho = 2;

param.nnparam.flann_params = flann_params(size(img, 1)*size(img, 2), param.patch_size, 'kdtree', nb_cores);
tic;
[G, ~] = gsp_patch_graph(rgb2gray(img),param);
toc;
G = gsp_estimate_lmax(G);

%%
idx_a = 286*358 + 31;
idx_b = 335*358 + 263;
idx_c = 136*358 + 113;

diracs = zeros(G.N, 3);
diracs(idx_a, 1) = 1;
diracs(idx_b, 2) = 1;
diracs(idx_c, 3) = 1;

img_diracs = img;

figure;
imshow(img_diracs);
hold on;
scatter(286, 31, 100, [1.0, 0, 0] ,'filled');
scatter(335, 263, 100, [0, 1.0, 0] ,'filled');
scatter(136, 113, 100, [1.0, 1.0, 0] ,'filled');


h = gsp_design_heat(G, 500);

localized_atoms = gsp_filter_analysis(G, h, diracs);
localized_atoms = localized_atoms ./ max(localized_atoms);

image_atoms = zeros(size(img));
%Red
image_atoms(:,:,1) = reshape(localized_atoms(:,1), size(img(:,:,1)));
%Green
image_atoms(:,:,2) = reshape(localized_atoms(:,2), size(img(:,:,1)));
%Yellow
image_atoms(:,:,1) = image_atoms(:,:,1) + reshape(localized_atoms(:,3), size(img(:,:,1)));
image_atoms(:,:,2) = image_atoms(:,:,2) + reshape(localized_atoms(:,3), size(img(:,:,1)));

%imagesc(reshape(sum(localized_atoms, 2), size(img(:,:,1))))
figure;
imshow(image_atoms)

%%


