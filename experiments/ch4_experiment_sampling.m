%% Params
dataname = 'mnist';
source_set = '1k';

params = {};
params.algo = 'tsne';
params.sampling = 'uniform';
params.diffusionn = 'chd';

sampling = {'uniform', 'ntig', 'active'};
nd = numel(sampling);

embeddings = cell(nd, 1);

data = load_data(dataname, source_set, {'raw', 'nn'});
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 10);

nb_samples = 60:25:460;
ns = length(nb_samples);

nr = 200;
aci_scores = zeros(ns, nd);
nn_scores = zeros(ns, nd);
timing = zeros(ns, nd);
for ii = 1:ns
    params.ns = nb_samples(ii);
    for jj = 1:nd
        params.sampling = sampling{jj};
        for kk = 1:nr
            [data.embedding, t] = dr_cdr(data, 2, params);
            aci_scores(ii, jj) = aci_scores(ii, jj) + compute_quality(data, 'aci', 'ncut');
            nn_scores(ii, jj) = nn_scores(ii, jj) + compute_quality(data, '1nn');
            timing(ii, jj) = timing(ii, jj) + t;
        end
        aci_scores(ii, jj) = aci_scores(ii, jj) / nr;
        nn_scores(ii, jj) = nn_scores(ii, jj) / nr;
        timing(ii, jj) = timing(ii, jj) / nr;
    end
end

save(sprintf('export/ch4_experiment_sampling.mat'), 'nb_samples', 'aci_scores', 'timing');%, 'nn_scores'); 


%%


f2 = figure;
plot(nb_samples(1:2:end), aci_scores(1:2:end,:), '-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('uniform', 'ntig', 'active', 'Location', 'NorthEast');
xlabel(sprintf('$N_s$'), 'Interpreter', 'latex', 'FontSize', 16);
ylabel(sprintf('$ACI$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');

export_fig(sprintf('export/ch4_experiment_sampling_aci.pdf'));
close(f2);

%%

f2 = figure;
plot(nb_samples(1:2:end), nn_scores(1:2:end,:), '-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('uniform', 'ntig', 'active', 'Location', 'NorthEast');
xlabel(sprintf('$N_s$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
ylabel(sprintf('$1NN$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');

export_fig(sprintf('export/ch4_experiment_sampling_1nn.pdf'));
close(f2);



%%

f2 = figure;
plot(nb_samples(1:2:end), timing(1:2:end,:), '-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('uniform', 'ntig', 'active', 'Location', 'NorthWest');
xlabel(sprintf('$N_s$'), 'Interpreter', 'latex', 'FontSize', 16);
ylabel(sprintf('time [s]'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');

export_fig(sprintf('export/ch4_experiment_sampling_timing.pdf'));
close(f2);
