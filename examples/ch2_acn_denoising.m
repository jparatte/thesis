%% Noisy data
data = generate_data(4000, 4, struct('lambda', 1, 'name', 'square', 'noise_level', 1, 'noise_fraction', 0.1));
data.Ge = knn_graph(data, 'embedding');
G = data.Ge;


cat0 = find(data.labels == 0);
signal0 = zeros(data.N, 1);
signal0(cat0) = 1;

param.vertex_size = 30;
%param = {};
%%
f1 = figure;
gsp_plot_signal(G, signal0, param);

set(f1, 'Position', [0 0 500 400])
set(f1, 'Color', 'w');
colorbar('off');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_acn_denoising_a.pdf');
close(f1);


%%
G0 = gsp_graph(G.W(cat0, cat0));
G0 = gsp_estimate_lmax(G0);
outliers0 = detect_outliers(G0);
inliers0 = setdiff(1:G0.N, outliers0);
inliers = cat0(inliers0);

signal_inliers = zeros(data.N, 1);
signal_inliers(inliers) = 1;

f1 = figure;
gsp_plot_signal(G, signal_inliers, param);
colorbar('off');
set(f1, 'Position', [0 0 500 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_acn_denoising_b.pdf');
close(f1);