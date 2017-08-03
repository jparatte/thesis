function [ ] = datasets_init( prefix )
%DATASETS_INIT Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    if ~exist(prefix, 'file')
       system(sprintf('mkdir %s', prefix)); 
    end
    
    subfolders = {'raw', 'embedding', 'nn', 'metadata'};
    
    ns = numel(subfolders);
    
    for ss = 1:ns 
        folder = sprintf('%s/%s', prefix, subfolders{ss});
        if ~exist(folder, 'file')
            system(sprintf('mkdir %s', folder));
        end
        
        folder = sprintf('%s/%s/full', prefix, subfolders{ss});
        if ~exist(folder, 'file')
            system(sprintf('mkdir %s', folder));
        end
        
    end   
end

