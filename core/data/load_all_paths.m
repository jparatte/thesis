function [ paths ] = load_all_paths( prefix )
%LOAD_ALL_PATHS Summary of this function goes here
%   Detailed explanation goes here
    dirs = dir(sprintf('%s', prefix));
    dirs = dirs(3:end);
    paths = cell(length(dirs), 1);
    for ii = 1:length(dirs)
       paths{ii} = sprintf('%s/%s', prefix, dirs(ii).name);
    end
end

