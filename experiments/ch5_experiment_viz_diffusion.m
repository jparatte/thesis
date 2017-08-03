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
embeddings = cell(5,1);
Yls = cell(5, 1);
timing = cell(5, 1);
ct = 1;
for ll = 2:6
    from_lvl = ll;
    mdata = tree.data{from_lvl}; 
    [Yls{ct}, timing{ct}] = compute_dr(mdata, 'tsne');
    ct = ct+1;
end

%%
gammas = [0.6, 0.3, 0.1, 0.1, 0.1];
ct = 1;
for ll = 2:6
    from_lvl = ll;
    embeddings{ct} = cgt_upsample(tree, Yls{ct}, from_lvl, tree.depth+1, gammas(ct));
    ct = ct+1;
end

%%
    

save('export/ch5_experiment_viz_diffusion.mat', 'embeddings', 'Yls', 'timing'); 

%%
mksize = 2;
for ii = 1:5
    f2 = figure;
    plot2d(embeddings{ii}, data.labels, mksize);
    title(sprintf('$l=%d$ $(N_l=%d)$', ii+1, tree.data{ii+1}.N), 'Interpreter', 'latex', 'FontName', 'cmr10');
    set(gca, 'FontSize', 18);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch5_experiment_diffusion_l%d.pdf', ii+1));
    close(f2);
end

%% Original t-SNE embedding
data = load_data(dataname, source_set, {'embedding:tsne'});
f2 = figure;
plot2d(data.embedding, data.labels, mksize);
title(sprintf('Original'), 'Interpreter', 'latex', 'FontName', 'cmr10');
set(gca, 'FontSize', 18);
set(gca, 'FontName', 'cmr10');
set(gca,'LooseInset',get(gca,'TightInset'))
axis off;
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');
export_fig(sprintf('export/ch5_experiment_diffusion_orig.pdf'));
close(f2);
