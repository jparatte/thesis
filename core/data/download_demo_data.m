function [ ] = download_demo_data( dataname, prefix )
%DOWNLOAD_DEMO_DATA Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    system(sprintf('wget --no-check-certificate https://lts2.epfl.ch/datasets/mat/%s.mat -O %s/raw/full/%s.mat', dataname, prefix, dataname));
end

