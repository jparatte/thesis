function [ G ] = knn_graph( data, source, k, distance)
%KNN_GRAPH Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('source', 'var')
       source = 'raw'; 
    end

    if ~exist('distance', 'var')
       distance = 'l2'; 
    end
    
    if ~exist('k', 'var')
       k = 10; 
    end

    if isfield(data, source)
        X = getfield(data,source);
    else
        error('%s data source not present in knn_graph', source);
    end
    
    switch distance
        case 'l2'
            paramsnn = knn_graph_params(data);
            paramsnn.k = k;
            G = gsp_nn_graph(X, paramsnn);
            
        case 'cosine'
            [nn, dd] = knn_search_cosine(X, k);
            G = graph_from_nn(nn, dd);
        
        otherwise
            error('unknown distance type');
    end
end

