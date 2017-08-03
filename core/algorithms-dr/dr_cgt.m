function [ Y, t, tmt] = dr_cgt( data, nb_dim, params )
%DR_CGT Summary of this function goes here
%   Detailed explanation goes here

    if isfield(data, 'G')
        G = data.G;
    else
        if isfield(data, 'nn')
            G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);
        else
           G = knn_graph(data); 
        end
    end
    
    G = gsp_estimate_lmax(G);
    
    if ~exist('params', 'var')
        params = {};
    end
    
    if ~isfield(params, 'algo')
        params.algo = 'tsne';
    end
    
    if ~isfield(params, 'sketch_size')
        params.sketch_size = 4096;
    end

    if ~isfield(params, 'cgt_gamma')
       params.cgt_gamma = 0.2; 
    end
    
    cgtparams.target_size = params.sketch_size;
    cgtparams.limit_graph_level = 'auto';

    ts1 = tic;
    % 1) Create the tree
    tree = cgt_create_tree(data, cgtparams);

    % 2) Get the meta-features
    from_lvl = tree.target_level;
    mdata = tree.data{from_lvl}; 
    t1 = toc(ts1);
    
    % 3) Compute the embedding on the meta-features
    [Yl, t2, t2mt] = compute_dr(mdata, params.algo, nb_dim);    
    
    ts3 = tic;
    % 4) Upsample on the tree
    Y = cgt_upsample(tree, Yl, from_lvl, tree.depth+1, params.cgt_gamma);
    t3 = toc(ts3);
    
    t = t1 + t2 + t3;
    tmt = t1 + t2mt + t3;
    %labels_l = cgt_downsample(tree, data.labels, tree.depth+1, from_lvl);
end

