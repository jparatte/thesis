function [  ] = datasets_subsample( target, force, prefix )
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    if ~exist('force', 'var')
        force = 0; 
    end
    
    datapath = sprintf('%s/raw/full', prefix);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    switch target
        case '1k'
            K = 1000;
            Nc = 10;
        case '10k'
            K = 10000;
            Nc = 25;
        otherwise
            error('Unsupported target');
    end
    
    fprintf('Subsampling %d datasets in %s :\n', num_data, datapath ); 
    
    for ii = 1:num_data
        
        filename = name_from_path(paths{ii});
        outpath = sprintf('%s/raw/%s/%s.mat', prefix, target, filename);
        
        if exist(outpath, 'file') && ~force
            fprintf('[%d] - skipping %s (file already exist)\n', ii, filename);
            continue
        end
        
        chunk = load(paths{ii});
        
        if ~isfield(chunk.data, 'raw')
            fprintf('[%d] - skipping %s (no raw data)\n', ii, filename);
            continue
        end
        
        if chunk.data.N <= K
            fprintf('[%d] - skipping %s (not enough samples)\n', ii, filename);
            continue
        end
        
        fprintf('[%d] - processing %s ...', ii, filename);
        data = randsample_data(chunk.data, K, Nc);
        save(outpath, 'data');
        fprintf('done. (Nc = %d)\n', length(unique(data.labels)));
    end
end

