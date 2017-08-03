function [ avg_score, scores ] = quality_1nn( data, params)
%QUALITY_1NN Summary of this function goes here
%   Detailed explanation goes here

    data.labels = data.labels(:);
    cats = unique(data.labels);
    K = length(cats);
    N = data.N;
    
    %perform 1NN-search
    paramsnn.type = 'kdtree';
    nn = knn_search(data.embedding, 1, paramsnn);
    
    labels_1nn = data.labels(nn);
    avg_score = sum(abs(data.labels - labels_1nn) > 0, 1) / N;
    
    scores = zeros(K, 1);
        
    for k = 1:K
        vci = find(data.labels == cats(k));
        nci = length(vci);
         
        scores(k) = sum(abs(data.labels(vci) - labels_1nn(vci)) > 0, 1)/nci;
    end
    
end

