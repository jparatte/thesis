function [ dataset ] = load_all( prefix )
%LOAD_ALL Summary of this function goes here
%   Detailed explanation goes here
    dirs = dir(sprintf('%s', prefix));
    dirs = dirs(3:end);
    dataset = cell(length(dirs), 1);
    for ii = 1:length(dirs)
       chunk = load(sprintf('%s/%s', prefix, dirs(ii).name));
       dataset{ii} = chunk.data;
    end

end

