function [ score_acc, cc_hist ] = quality_acc( data, params )
%QUALITY_ACN Summary of this function goes here
%   Detailed explanation goes here
    
    cats = unique(data.labels);
    K = length(cats);
   
    if ~isfield(data, 'Ge')
        data.Ge = knn_graph(data, 'embedding');
    end
    data.Ge = gsp_estimate_lmax(data.Ge);
    
    if nargin < 2
       params = {}; 
    end
    
    if ~isfield(params, 'type')
        path_type = 'oneshot';
    else
        path_type = params.type;
    end
    
    if ~isfield(params, 'nr')
        nr = 10;
    else
        nr = params.nr;
    end
    
    if ~isfield(params, 'as_gamma')
        gamma = 0.2;
    else
        gamma = params.as_gamma;
    end
    
    if ~isfield(params, 'dist_type')
       dist_type = 'euclidean'; 
    else 
        dist_type = params.dist_type;
    end
    
    
    G = data.Ge;
    N = data.N;
    d = size(data.embedding, 2);
    
    [outliers, ntig] = detect_outliers(G);
    inliers = setdiff(1:N, outliers);
    
    
    
     switch dist_type
        case 'euclidean'
            pmin = min(data.embedding(inliers, :));
            pmax = max(data.embedding(inliers, :));
            diam = norm(pmin - pmax);
        case 'geodesic'
            diam = compute_diameter(G, struct('type', 'roditty'));
        case 'kdd'
            diam = mean(ntig);
            %diam = 1;
            max_kdd = max(ntig);
        otherwise
            error('unknown distance type');
     end
    
     diam = nthroot(diam, d);
    
    ns = 10;
    
    cc_hist = zeros(K, 1);
    
    score_acc = 0;
    
    for k = 1:K
        vci = find(data.labels == cats(k));
        nci = length(vci);
        
        if 1
            Gvci = gsp_graph(G.W(vci, vci));
            Gvci = gsp_estimate_lmax(Gvci);
            outliers = detect_outliers(Gvci);
            outliers = vci(outliers); %remap in global index
            inliers = setdiff(vci, outliers);

            [samples, atoms] = sampling_active(G, ns, 0, inliers);
        else
            [samples, atoms] = sampling_active(G, ns, gamma);    
        end
        
        atoms = tig_atoms(G, samples);
        
        switch path_type
            case 'oneshot'
                if strcmp(dist_type, 'kdd')
                    paths = [1:ns]';
                else
                    paths = samples;
                end
            case 'randomized'
                paths = zeros(ns, nr);
                for ii = 1:nr
                    if strcmp(dist_type, 'kdd')
                        paths(:,ii) = randperm(ns, ns);
                    else
                        paths(:,ii) = samples(randperm(ns, ns));
                    end
                end
            otherwise
                error('unknown path type');
        end
        np = size(paths, 2);
        len = 0;
        for ii = 1:np
            switch dist_type
                case 'euclidean'
                    len = len + euclidean_path(data.embedding(paths(1:ns-1, ii), :), data.embedding(paths(2:ns, ii), :));
                case 'geodesic'
                    len = len + geodesic_path(G.A, paths(1:ns-1, ii), paths(2:ns, ii));
                case 'kdd'
                    len = len + min(max_kdd, kdd_path(atoms(:, paths(1:ns-1, ii)), atoms(:,paths(2:ns, ii))));
                otherwise
                    error('unknown distance type');
            end
        end
        
        len = len/np;
        
        cc_hist(k) = len/diam;
        
        score_acc = score_acc + len*nci;
    end
    
    score_acc = score_acc / (diam*N);

end

function [ len ] = euclidean_path(x1, x2)
    len = 0;
    for ii = 1:size(x1, 1)
        len = len + norm(x1(ii, :) - x2(ii, :));
    end
end

function [ len ] = geodesic_path(A, x1, x2)
    len = 0;
    for ii = 1:length(x1)
        [d, ~, ~] = bfs(A, x1(ii), x2(ii));
        len = len + d(x2(ii));
    end
end

function [ len ] = kdd_path(x1, x2)
    len = 0;
    for ii = 1:size(x1, 2)
        len = len + norm(x1(:, ii) - x2(:, ii));
    end
end