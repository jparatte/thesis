function [ ] = datasets_prune( name, source_set, prefix)
%DATASETS_PRUNE Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    datapath = sprintf('%s/raw/%s/%s.mat', prefix, source_set, name);

    dataname = name_from_path(datapath);
    
    chunk = load(datapath);

    if ~isfield(chunk.data, 'raw')
        fprintf('skipping %s (no raw data)\n', dataname);
        return
    end
    
    if ( any(isnan(chunk.data.raw(:))) || any(isinf(chunk.data.raw(:))) )
        fprintf('Inf or NaN values present, pruning %s ...', dataname);
    else
        fprintf('file clean, skipping %s\n', dataname);
        return
    end
    
    data = chunk.data;
    clear chunk;
    data.raw(isnan(data.raw)) = 0;
    data.raw(isinf(data.raw)) = 0;

    save(datapath, 'data');
    fprintf('done.\n');
end

