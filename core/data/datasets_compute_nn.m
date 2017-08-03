function [  ] = datasets_compute_nn( name, source_set, k, force, prefix)
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    if ~exist('force', 'var')
        force = 0; 
    end
    
    nb_cores = 8;

    datapath = sprintf('%s/raw/%s/%s.mat', prefix, source_set, name);

    dataname = name_from_path(datapath);
    outpath = sprintf('%s/nn/%s/%s.mat', prefix, source_set, dataname);

    if exist(outpath, 'file') && ~force
        fprintf('skipping %s (file already exist)\n', dataname);
        return
    end

    %Load metadata to avoid loading large file for nothing
    meta = load(sprintf('%s/metadata/%s/%s.mat', prefix, source_set, dataname));

    if meta.data.N > 2000000
        fprintf('skipping %s (too big for batch processing)\n', dataname);
        return
    end

    chunk = load(datapath);

    if ~isfield(chunk.data, 'raw')
        fprintf('skipping %s (no raw data)\n', dataname);
        return
    end

    data = rmfield(chunk.data, 'raw'); %copy the metadata
    data.k = k;

    sparsity_level = length(find(chunk.data.raw > 0)) / (chunk.data.N * chunk.data.D);
    fprintf('processing %s (nnz=%.4f, ', dataname, sparsity_level);

    if issparse(chunk.data.raw)
       fprintf('sparse), using cosine ...'); 
        [nn, dd] = knn_search_cosine(chunk.data.raw, k);
    else
       fprintf('dense), using l2 ...');
       paramsnn = knn_graph_params(data, k, nb_cores);
       [nn, dd] = knn_search(chunk.data.raw, k, paramsnn);
    end

    data.nn = nn;
    data.dd = dd;

    save(outpath, 'data');
    fprintf('done.\n');
end

