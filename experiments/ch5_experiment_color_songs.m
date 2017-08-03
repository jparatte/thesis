%% Init

feat = dataset.features;

data.titles = dataset.names;

total = 0;
for ii = 1:numel(feat)
    nf = length(feat{ii});
    total = total + nf;
end

D = size(feat{1}, 1);

data.raw = zeros(total, D);
data.labels = zeros(total, 1);

offset = 1;
lab = 1;
for ii = 1:numel(feat)
    nf = size(feat{ii}, 2);
    data.raw(offset:offset+nf-1, :) = feat{ii}';
    data.labels(offset:offset+nf-1) = lab;
    lab = lab + 1;
    offset = offset + nf;
end

[data.N, data.D] = size(data.raw);
[data.nn, data.dd] = knn_search(data.raw, 100, knn_graph_params(data, 100));

%% Visualize the data

from_lvl = 2;
params.branching = 96;
params.limit_graph_level = from_lvl;
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);
tree = cgt_create_tree(data, params);
%%
mdata = tree.data{from_lvl};
Yl = compute_dr(mdata, 'tsne', 2);
Y = cgt_upsample(tree, Yl, from_lvl, tree.depth + 1, 0.1);
%%
plot2d(Y, 1:data.N)

%%
plot2d(Y, data.labels)
%%

for ii = 1:3
    figure;
    cat0 = find(data.labels == (2*ii - 1));
    cat1 = find(data.labels == 2*ii);
    ntot = length(cat0) + length(cat1);
    label_songs = zeros(data.N, 1);
    label_songs(cat0) = 1;
    label_songs(cat1) = 2;
    plot2d(Y([cat0; cat1], :), label_songs([cat0; cat1]))
end
%%
labels_artists = mod(data.labels, 2) == 0;
plot2d(Y, labels_artists)

%%
plot_titles = {'Nocturne (Ashkenazy)', 'Nocturne (Barton)', 'Impromptu (Barton)', 'Impromptu (Horowitz)', 'Etude (Van Cliburn)', 'Etude (Horowitz)'};

%% Compute HSV colormap
hsv_colors = cgt_compute_hsv(tree);
rgb_colors = hsv2rgb(hsv_colors);

%%
mksize = 250;
cats = unique(data.labels);
nc = length(cats);
%figure;
%hold on;
for ii = 1:nc
    cat = find(data.labels == cats(ii));
    n = length(cat);
    code_cat = tree.encoding(cat, 1);
    linear_embed = (1:n) ./ n;
     f2 = figure;
    scatter(linear_embed, ii*ones(n, 1), mksize, rgb_colors(cat, :), 'square', 'filled');
    colormap jet;
    title(sprintf('%s', plot_titles{ii}), 'FontName', 'cmr10');
    set(gca, 'FontSize', 18);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 100]);
    set(f2, 'Color', 'w');
    %export_fig(sprintf('export/ch5_experiment_color_songs_code_%d.pdf', ii));
    %close(f2);
end
%%
plot2d(Y, rgb_colors)

%%

%normalize
rx = max(Y(:,1)) - min(Y(:,1));
ry = max(Y(:,2)) - min(Y(:,2));
Z = Y ./ [rx, ry];
Z = 2*Z;
Z = Z - mean(Z);
%Z = Y - mean(Y);
degree = atan2d(Z(:,2), Z(:,1));
N = data.N;
hsv_z = ones(N, 3);
hsv_z(:,1) = (degree + 180)./ 360;
hsv_z(:,2) = 1.0 - 0.25 * (abs(Z(:,1)));
hsv_z(:,3) = 1.0 - 0.25 * (abs(Z(:,2)));
rgb_z = hsv2rgb(hsv_z);
%%
plot2d(Y, rgb_z)

%%

mksize = 250;
cats = unique(data.labels);
nc = length(cats);
%figure;
%hold on;
for ii = 1:nc
    cat = find(data.labels == cats(ii));
    n = length(cat);
    code_cat = tree.encoding(cat, 1);
    linear_embed = (1:n) ./ n;

    
    f2 = figure;
    scatter(linear_embed, ii*ones(n, 1), mksize, rgb_z(cat, :), 'square', 'filled');
    colormap jet;
    title(sprintf('%s', plot_titles{ii}), 'FontName', 'cmr10');
    set(gca, 'FontSize', 18);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 100]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch5_experiment_color_songs_embed_%d.pdf', ii));
    close(f2);
end

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
