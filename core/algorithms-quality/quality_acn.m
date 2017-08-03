function [ score_acn, cn_hist ] = quality_acn( data, type )
%QUALITY_ACN Summary of this function goes here
%   Detailed explanation goes here
    
    cats = unique(data.labels);
    K = length(cats);
   
    if ~isfield(data, 'Ge')
        data.Ge = knn_graph(data, 'embedding');
    end
    G = data.Ge;
    N = data.N;
    
    cn_hist = zeros(K, 1);
    
    score_acn = 0;
    
    for k = 1:K
        vci = find(data.labels == cats(k));
        nci = length(vci);
        
        Gwci = gsp_graph(G.W(vci, vci));
        Gwci = gsp_estimate_lmax(Gwci);
        outliers = detect_outliers(Gwci);
        
        cn_hist(k) = length(outliers) / nci;
        
        score_acn = score_acn + length(outliers);
    end
    
    score_acn =score_acn / N;

end

