function [ nn, dd ] = knn_search( X, k, params )
%KNN_SEARCH Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('params', 'var')
       params = {}; 
    end

    if ~isfield(params, 'type'), params.type = 'flann'; end;
    if ~isfield(params, 'distance'), params.distance = 'euclidean'; end;
    
    switch params.type
        case 'exact'
            [nn, dd] = flann_search(transpose(X), transpose(X), k+1, struct('algorithm','linear'));
            
        case 'kdtree'
            kdt = KDTreeSearcher(X, 'distance', 'euclidean');
            [nn, dd] = knnsearch(kdt, X, 'k', k+1 );
            nn = transpose(nn);
            dd = transpose(dd);
            
        case 'flann'
            flann_set_distance_type(params.distance);
            
            if isfield(params, 'flann_params')
                flann_params = params.flann_params;
            else
                flann_params = {};
                flann_params.algorithm = 'kmeans';
                flann_params.iterations = 1;
                flann_params.branching = 16;
                flann_params.checks = 256;
            end
            
            [nn, dd] = flann_search(transpose(X), transpose(X), k+1, flann_params);
        otherwise
            error('Unrecognized knn search type');
    end
    
    nn = transpose(nn(2:end,:));
    dd = transpose(dd(2:end,:));
end

