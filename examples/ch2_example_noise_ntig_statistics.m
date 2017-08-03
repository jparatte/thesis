%% Noiseless data
noise_levels = 1;
K = length(noise_levels);

data = generate_data(1200, 4, struct('lambda', 1, 'name', 'square', 'noise_level', noise_levels, 'noise_fraction', 0.1));
data.Ge = knn_graph(data, 'embedding');
G = data.Ge;
G = gsp_estimate_lmax(G);
g = gsp_design_heat(G, get_heat_tau(0.01));
ntig = gsp_norm_tig(G, g, 0);

%%
f1 = figure;
gsp_plot_signal(G, ntig);
colorbar('off');
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_stat_a.pdf');
close(f1);
    

%%
f1 = figure;
histogram(ntig, 100)
%ylabel(sprintf('$| V_{\\epsilon_t} | / N$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
xlabel(sprintf('$\\|\\mathcal{T}_ig\\|_2^2$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'YScale','log')
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_stat_b.pdf');
close(f1);
