%% Params
dataname = 'mnist';
source_set = 'full';

data = load_data(dataname, source_set, {'raw', 'nn'});
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);

%% Construct CGT
kk = [4, 8, 16, 32];
for nk = 1:4
    params.branching = kk(nk);
    params.limit_graph_level = 1;
    ts = tic;
    tree = cgt_create_tree(data, params);
    te = toc(ts);
    fprintf('CGT created in %.3fs\n', te);

    data.embedding = tree.encoding(:,1);
    score_aci = compute_quality(data, 'aci');
    score_1nn = compute_quality(data, '1nn');

    mksize = 300;
    f2 = figure;
    scatter(tree.encoding(:,1), ones(data.N, 1), mksize, data.labels, 'square', 'filled');
    colormap jet;
    title(sprintf('$K=%d, 1NN=%.2f$', params.branching, score_1nn), 'Interpreter', 'latex', 'FontName', 'cmr10');
    set(gca, 'FontSize', 18);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 100]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch5_experiment_encoding_1embed_k%d.pdf', params.branching));
    close(f2);
end


%%
% 
% nencode = (double(tree.encoding) ./ double(max(tree.encoding)));
% figure;
% hold on;
% for ii = 1:tree.depth
%     scatter(nencode(:,ii), ones(data.N, 1)*(ii/10), mksize, data.labels, 'square', 'filled');
%     colormap jet;
% end


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
