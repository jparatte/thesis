%% Noiseless data
data = generate_data(1200, 4, struct('lambda', 1, 'name', 'square', 'noise_level', 0, 'noise_fraction', 0.2));
data.Ge = knn_graph(data, 'embedding');
G = data.Ge;
G = gsp_estimate_lmax(G);
g = gsp_design_heat(G, get_heat_tau(0.01));
ntig = gsp_norm_tig(G, g, 0);
f1 = figure;
gsp_plot_signal(G, ntig);
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_a.pdf');
close(f1);

ns = 10;
edge_colors= zeros(ns-1, 3);
edge_colors(:,1) = (2:ns)./(ns*2);
edge_colors(:,2) = (2:ns)./(ns*2);
edge_colors(:,3) = (2:ns)./(ns*2);


%% Active sampling, gamma = 0


gamma = 0;
[samples, atoms] = sampling_active(G, ns, gamma);

f1 = figure;
gsp_plot_signal(G, ntig);
hold on
s1 = samples(1:end-1);
s2 = samples(2:end);

for ii = 1:ns-1
    plot([G.coords(s1(ii), 1)', G.coords(s2(ii), 1)'], [G.coords(s1(ii), 2)', G.coords(s2(ii), 2)'], 'LineWidth', 4, 'Color', edge_colors(ii,:));
end
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_c.pdf');
close(f1);

%% Active sampling, gamma = 0.5
ns = 10;
gamma = 0.3;
[samples, atoms] = sampling_active(G, ns, gamma);

f1 = figure;
gsp_plot_signal(G, ntig);
hold on

s1 = samples(1:end-1);
s2 = samples(2:end);

for ii = 1:ns-1
    plot([G.coords(s1(ii), 1)', G.coords(s2(ii), 1)'], [G.coords(s1(ii), 2)', G.coords(s2(ii), 2)'], 'LineWidth', 4, 'Color', edge_colors(ii,:));
end
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_e.pdf');
close(f1);

%% Noisy data
data = generate_data(1200, 4, struct('lambda', 1, 'name', 'square', 'noise_level', 1, 'noise_fraction', 0.1));
data.Ge = knn_graph(data, 'embedding');
G = data.Ge;
G = gsp_estimate_lmax(G);
g = gsp_design_heat(G, get_heat_tau(0.01));
ntig = gsp_norm_tig(G, g, 0);
f1 = figure;
gsp_plot_signal(G, ntig);
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_b.pdf');
close(f1);

%% Active sampling, gamma = 0
ns = 10;
gamma = 0;
[samples, atoms] = sampling_active(G, ns, gamma);

f1 = figure;
gsp_plot_signal(G, ntig);
hold on

s1 = samples(1:end-1);
s2 = samples(2:end);

for ii = 1:ns-1
    plot([G.coords(s1(ii), 1)', G.coords(s2(ii), 1)'], [G.coords(s1(ii), 2)', G.coords(s2(ii), 2)'], 'LineWidth', 4, 'Color', edge_colors(ii,:));
end
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_d.pdf');
close(f1);

%% Active sampling, gamma = 0.5
ns = 10;
gamma = 0.3;
[samples, atoms] = sampling_active(G, ns, gamma);

f1 = figure;
gsp_plot_signal(G, ntig);
hold on

s1 = samples(1:end-1);
s2 = samples(2:end);

for ii = 1:ns-1
    plot([G.coords(s1(ii), 1)', G.coords(s2(ii), 1)'], [G.coords(s1(ii), 2)', G.coords(s2(ii), 2)'], 'LineWidth', 4, 'Color', edge_colors(ii,:));
end
%xlim([-2, 4])
%ylim([-2, 4])
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
set(gca,'LooseInset',get(gca,'TightInset'))
export_fig('export/ch2_example_ntig_noise_f.pdf');
close(f1);
