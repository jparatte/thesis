function [  ] = datasets_embedding_reporting_all( source_set, prefix)
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    datapath = sprintf('%s/embedding/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    fprintf('Reporting embedding status for %d datasets in %s :\n', num_data, datapath ); 
    
    nb_ok = 0;
    for ii = 1:num_data
        chunk = load(paths{ii});
        dataname = name_from_path(paths{ii});
        if strcmp(chunk.data.embedding_status, 'OK')
           nb_ok = nb_ok + 1; 
        end
        fprintf('[%d] - [%s] %s (%.3fs)\n', ii, chunk.data.embedding_status, dataname, chunk.data.embedding_time);
    end
    
    fprintf('========= [%d/%d OK] =========\n', nb_ok, num_data);
end

