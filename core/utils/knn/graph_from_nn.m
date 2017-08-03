function [ G ] = graph_from_nn( nn, dd, kernel_type, max_k )
%GRAPH_FROM_NN Summary of this function goes here
%   Detailed explanation goes here
    
    if ~exist('kernel_type', 'var')
        kernel_type = 'gaussian';
    end
    
    k = size(nn, 2);
    if exist('max_k', 'var')
       if k > max_k 
          k = max_k;
          nn = nn(:,1:k);
          dd = dd(:,1:k);
       end
    end
    
    if ( (mean(dd(:)) / prctile(dd(:), 95)) > 10e5)
        max_clip = prctile(dd(:), 95);
        dd = min(dd, max_clip);
    end
    
    N = size(nn, 1);
    
    indx = reshape(nn', k*N, 1);
    indy = kron((1:N)', ones(k, 1));
    
    switch kernel_type
        case 'gaussian'
            dd = dd / max(max(dd));
            sigma = mean(dd(:));
            dd = exp(-(dd.^2)/sigma.^2);
        case 'perplexity'
            dd = fix_perplexity(dd, 50);
        otherwise
            error('unknown kernel type');
    end
    
    min_weight = max(min(dd(:))/10, 1e-5);
    
    weights = reshape(dd', k*N, 1);
    %ensure full connectivity
    indx = [indx; (1:N-1)'];
    indy = [indy; (2:N)'];
    weights = [weights ; repmat(min_weight, N-1, 1)];
    
    W = sparse(indx, indy, weights, N, N);
    
    W = max(W, W');
    W(1:(N+1):end) = 0; %set diagonal to zero
    
    G = gsp_graph(W);
end

