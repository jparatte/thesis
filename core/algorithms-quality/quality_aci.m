function [ score_aci, ci_hist ] = quality_aci( data, type )
%SCORE_BCUTS Compute ACI score
%   type : ['cheeger', 'ncut']
    
    if nargin < 2
        type = 'ncut';
    end

    if ~isfield(data, 'Ge')
        data.Ge = knn_graph(data, 'embedding');
    end
    
    switch type
        case 'cheeger'
            [score_aci, ci_hist] = cheeger(data.Ge, data.labels);
        case 'ncut'
            [score_aci, ci_hist] = ncut(data.Ge, data.labels);
        otherwise
            error('Unknown type for score_aci');
    end
end

