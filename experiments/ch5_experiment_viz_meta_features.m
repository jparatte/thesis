%% Params
dataname = 'mnist';
source_set = 'full';

data = load_data(dataname, source_set, {'raw', 'nn'});
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);

%% Construct CGT
params.branching = 8;
ts = tic;
tree = cgt_create_tree(data, params);
te = toc(ts);
fprintf('CGT created in %.3fs\n', te);
%%
embeddings = cell(4,1);
labels = cell(4, 1);
timing = cell(4, 1);
ct = 1;
for ll = 2:5
    from_lvl = ll;
    mdata = tree.data{from_lvl}; 
    [embeddings{ct}, timing{ct}] = compute_dr(mdata, 'tsne');
    labels{ct} = cgt_downsample(tree, data.labels, tree.depth+1, from_lvl);
    ct = ct+1;
end

save('export/ch5_experiment_viz_meta_features.mat', 'embeddings', 'labels', 'timing'); 

%%
mksizes = [100, 30, 10, 6];

for ii = 1:4
    f2 = figure;
    plot2d(embeddings{ii}, labels{ii}, mksizes(ii));
    title(sprintf('$N_l=%d$', length(embeddings{ii})), 'Interpreter', 'latex', 'FontName', 'cmr10');
    set(gca, 'FontSize', 18);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch5_experiment_metafeatures_l%d.pdf', ii+1));
    close(f2);
end
