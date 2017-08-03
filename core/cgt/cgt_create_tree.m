function [ tree ] = cgt_create_tree( data, params )
%CREATE_TREE Summary of this function goes here
%   Detailed explanation goes here
    
    if ~exist('params', 'var')
        params = {};
    end
    
    if ~isfield(params, 'branching')
        if isfield(params, 'target_size')
            [branching, L] = compute_branching(params.target_size);
            fprintf('Optimal branching found at K=%d, with approximate target size %d\n', branching, branching^L);
        else
            branching = 64;
        end
    else
       branching = params.branching; 
    end
    
    if ~isfield(params, 'k')
       nnk = 100; 
    else 
       nnk = k; 
    end
    
    hkm_params = struct('algorithm', 'kmeans', 'branching', branching);
    
    features = double(data.raw');

    [index, ~, ~, tree] = flann_build_index(features, hkm_params);
    
    if isfield(params, 'target_size')
       tree.target_level = L; 
    end
    
    [tree, encoding] = encode_tree(tree);
    tree.encoding = encoding;
    
    depth = size(encoding, 2);

    for ii = depth:-1:1
        fprintf('level %d : %d nodes \n', depth - ii + 1, length(unique(encoding(:,ii))));
    end
    
    tree.data = cell(tree.depth+1,1);

    if ~isfield(params, 'limit_graph_level')
       min_graph_depth = 2;
    else
        if strcmp(params.limit_graph_level, 'auto')
            min_graph_depth = depth - L + 1;
        else
            min_graph_depth = depth - params.limit_graph_level + 1;
        end
    end
    
    for ii = depth:-1:min_graph_depth
        level = depth - ii + 1;
        fprintf('Constructin graph at level %d with %d nodes \n', level, length(unique(encoding(:,ii))));
        [meta_features, level_idx] = get_level_map(tree, features, encoding, level);
        ldata.raw = meta_features';
        ldata.level_idx = level_idx';
        [N, D] = size(ldata.raw);
        ldata.N = N;
        ldata.D = D;
        lnnk = max(min(nnk, floor(ldata.N/2)), min(10, ldata.N - 1));
        paramsnn = knn_graph_params(ldata, lnnk);
        [ldata.nn, ldata.dd] = knn_search(ldata.raw, lnnk, paramsnn);
        if lnnk > 75
            kernel_type = 'perplexity';
        else
            kernel_type = 'gaussian';
        end
        ldata.G = graph_from_nn(ldata.nn, ldata.dd, kernel_type);
        tree.data{level} = ldata;
    end
    
    if ~isfield(data, 'G')
        data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 20);
    end
    tree.data{depth} = data;
end

