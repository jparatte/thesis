function [ params ] = knn_graph_params(data, k, nb_cores)
%KNN_GRAPH_PARAMS Summary of this function goes here
%   Detailed explanation goes here
    
    global GLOBAL_nbcores;
    if ~exist('nb_cores', 'var')
       nb_cores = GLOBAL_nbcores; 
    end
    if ~exist('k', 'var')
        k = 10; 
    end

    params = {};
    params.use_flann = 1;
    params.k = k;
    params.flann_params = flann_params(data.N, data.D, 'kdtree', nb_cores);
end

