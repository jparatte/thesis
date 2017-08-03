function [  ] = datasets_extract_metadata( source_set, force, prefix )
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    if ~exist('force', 'var')
        force = 0; 
    end
    
    datapath = sprintf('%s/raw/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    fprintf('Extracting metadata from %d datasets in %s :\n', num_data, datapath ); 
    
    for ii = 1:num_data
        
        dataname = name_from_path(paths{ii});
        outpath = sprintf('%s/metadata/%s/%s.mat', prefix, source_set, dataname);
        
        if exist(outpath, 'file') && ~force
            fprintf('[%d] - skipping %s (file already exist)\n', ii, dataname);
            continue
        end
        
        chunk = load(paths{ii});
        
        fprintf('[%d] - processing %s ... ', ii, dataname);
        
        if isfield(chunk.data, 'raw')
            data = rmfield(chunk.data, 'raw'); %copy the metadata
        end
        if isfield(chunk.data, 'W')
            data = rmfield(chunk.data, 'W');
        end
        
        save(outpath, 'data');
        fprintf('done.\n');
    end
end

