%% Params
dataname = 'mnist';
source_set = 'full';

data = load_data(dataname, source_set, {'raw', 'nn'});
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);

%% Construct CGT
params.branching = 16;
params.limit_graph_level = 3;
from_lvl = 3;
ts = tic;
tree = cgt_create_tree(data, params);
te = toc(ts);
fprintf('CGT created in %.3fs\n', te);

%% Compute HSV colormap
hsv_colors = cgt_compute_hsv(tree);
rgb_colors = hsv2rgb(hsv_colors);

%% Compute one embedding by upsampling
mdata = tree.data{from_lvl}; 
Yl = compute_dr(mdata, 'tsne');
up_embedding = cgt_upsample(tree, Yl, from_lvl, tree.depth+1, 0.1);

%% Visualize colormap on both

data_tsne = load_data(dataname, source_set, {'embedding:tsne'});
mksize = 2;

f2 = figure;
plot2d(up_embedding, rgb_colors, mksize);
title(sprintf('$l=%d$ $(N_l=%d, k=%d)$', from_lvl, tree.data{from_lvl}.N, params.branching), 'Interpreter', 'latex', 'FontName', 'cmr10');
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(gca,'LooseInset',get(gca,'TightInset'))
axis off;
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');
export_fig(sprintf('export/ch5_experiment_color_viz_upsample_k%d.pdf', params.branching));
close(f2);

f2 = figure;
plot2d(data_tsne.embedding, rgb_colors, mksize);
title(sprintf('Original (k=%d)', params.branching), 'Interpreter', 'latex', 'FontName', 'cmr10');
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(gca,'LooseInset',get(gca,'TightInset'))
axis off;
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');
export_fig(sprintf('export/ch5_experiment_color_viz_original_k%d.pdf', params.branching));
close(f2);
