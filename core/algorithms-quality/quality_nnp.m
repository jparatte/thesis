function [ score, score_vec ] = quality_nnp( data, params)
%QUALITY_1NN Summary of this function goes here
%   Detailed explanation goes here

    score_vec = [];
    if ~isfield(data, 'nn')
        error('need data.nn field');
    end
    
    max_k = size(data.nn, 2);
    nnk = min(max_k, 150);
    
    %perform 1NN-search
    paramsnn.type = 'kdtree';
    nn = knn_search(data.embedding, nnk, paramsnn);
    
    score = nn_precision(data.nn(:,1:nnk), nn);
end

