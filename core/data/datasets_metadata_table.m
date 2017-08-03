function [  ] = datasets_metadata_table( source_set, prefix )
%DATASETS_METADATA_TABLE Summary of this function goes here
%   Detailed explanation goes here
    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    datapath = sprintf('%s/metadata/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    for ii = 1:num_data
        dataname = name_from_path(paths{ii});
        chunk = load(paths{ii});
        if (isfield(chunk.data, 'D'))
            fprintf('%s & %d & %d & %d \\\\ \\cline{1-4} \n', dataname, chunk.data.N, chunk.data.D, length(unique(chunk.data.labels)));
        else
           fprintf('%s & %d & - & %d \\\\ \\cline{1-4} \n', dataname, chunk.data.N, length(unique(chunk.data.labels))); 
        end
    end
end

