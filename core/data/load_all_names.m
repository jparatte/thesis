function [ names ] = load_all_names( source_set, prefix )
%LOAD_ALL_NAMES Summary of this function goes here
%   Detailed explanation goes here
    
    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    datapath = sprintf('%s/raw/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    N = numel(paths);
    names = cell(N, 1);
    for ii = 1:N
        names{ii} = name_from_path(paths{ii});
    end
end

