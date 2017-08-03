function [ Y, t, tmt ] = dr_tsne( data, dim, params )
%BHTSNE Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('params','var')
       params = {}; 
    end

    if ~isfield(params, 'method')
       params.method = 'fast'; 
    end
    
    t = -1;
    
    switch params.method
        case 'fast'
            if isfield(data, 'G')
                [Y, t, tmt] = sparse_tsne(data.G.W, dim);
            else 
                [Y, t, tmt] = fast_tsne(double(data.raw), dim);
            end
        case 'exact'
            ts = tic;
            if isfield(data, 'G')
                Y = tsne_p(full(data.G.W), [], dim);
            else 
                Y = tsne(double(data.raw), [], dim);
            end
            t = toc(ts);
            tmt = t;
        otherwise
            error('unknown method for tsne');
    end
end