function [ v ] = fast_wrs( x, k, w, vidx )
%FAST_WRS Fast Weighted Random Sampling Without Replacement
%   Reservoir sampling technique : https://en.wikipedia.org/wiki/Reservoir_sampling#Weighted_Random_Sampling_using_Reservoir
%   From M.T.Chao [A general purpose unequal probability sampling plan]

    if k>length(x), error('k must be smaller than length(x)'), end
    if ~isequal(length(x),length(w)),error('the weight W must have the length of X'),end
    
    if nargin < 4
        vidx = [];
        nsubs = round(k / 10);
    else
        if k < length(vidx), error('already enough samples'); end
        nsubs = round((k - length(vidx)) / 10);
    end
    
% SLOW version
%     v=zeros(1,k);
%     for i=1:k
%         v(i)=randsample(x,1,true,w);
%         w(x==v(i))=0;
%     end

    
    
%     % Accelerated 'without replacement' from 'with replacement'
    
    
    idx = 1:length(x);

    while 1
        is = randsample(idx, nsubs, true, w);
        is = unique(is);
        
        w(is) = 0;
        vidx = [vidx, is];
        
        if length(vidx) >= k
           v = x(vidx(1:k));
           break;
        end
        
    end

    % Reservoir sampling : ideally the fastest, but non-working
    % Also to adapt to new function params
%     N = length(weights);
%     wn = weights ./ sum(weights);
%     wsum = cumsum(wn);
%     
%     %filling reservoir
%     samples = 1:k;
%     
%     for ii = k+1:N
%         p = wn(ii) / wsum(ii)
%         if p >= rand(0, 1)
%             samples(randi(k)) = ii;
%         end
%     end


end

