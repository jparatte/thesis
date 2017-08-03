function [ nn, dd ] = knn_search_cosine( X, k, params )
%KNN_SEARCH Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('params', 'var')
       params = {}; 
    end

    if ~isfield(params, 'type'), params.type = 'full'; end;
    
    N = size(X, 1);
    switch params.type
        case 'full'
            if issparse(X)
                Xn = spdiags( 1 ./ sqrt(sum(X.^2, 2)), 0, N, N) * X;
            else
                Xn = X ./ sqrt(sum(X.^2, 2));
            end
            
            D = Xn * Xn';
            
            [D_sort,idx_sort] = sort(D,2,'descend');

            dd = full(abs(acos(D_sort(:,2:k+1))));
            nn = idx_sort(:,2:k+1);
        otherwise
            error('Unrecognized knn search type');
    end
end

