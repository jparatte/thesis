function [  ] = datasets_compute_nn_all( source_set, force, prefix)
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
    
    k = 150;
    
    fprintf('Computing knn for %d datasets in %s :\n', num_data, datapath ); 
    
    for ii = 1:num_data
        fprintf('[%d] - ', ii);
        dataname = name_from_path(paths{ii});
        datasets_compute_nn(dataname, source_set, k, force, prefix);
    end
end

