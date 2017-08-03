function [ Y, t, tmt, cembed, samples ] = dr_cdr( data, nb_dim, params )
%DR_COMPRESSIVE Summary of this function goes here
%   Detailed explanation goes here
    if isfield(data, 'G')
        G = data.G;
    else
        G = knn_graph(data);
    end
    
    G = gsp_estimate_lmax(G);
    
    if ~exist('params', 'var')
        params = {};
    end
    
    if ~isfield(params, 'algo')
        params.algo = 'tsne';
    end
    
    if ~isfield(params, 'diffusion')
       params.diffusion = 'chd'; % ['chd', 'tikhonov', 'rkhs']
    end
    
    if ~isfield(params, 'sampling')
       params.sampling = 'uniform'; % ['uniform', 'tig', 'active']
    end
    
    if ~isfield(params, 'ns')
        params.ns = round(75*log(G.N));
    end
    
    if ~isfield(params, 'filtering_order')
        params.filtering.order = 100;   
    else
       params.filtering.order = params.filtering_order;
    end
    
    if ~isfield(params, 'cutoff')
        params.cutoff = 0.05;
    end
    
    %params.diffusion.kernel = gsp_design_expwin(G, params.diffusion.cutoff);
    params.kernel = gsp_design_heat(G, get_heat_tau(params.cutoff));
    params.kernel_squared = @(x) params.kernel(x).^2;
    
    ts1 = tic;
    
    %Graph Sampling
    switch params.sampling
        case 'uniform'
            samples = sampling_uniform(G, params.ns);
        case 'ntig'
            samples = sampling_ntig(G, params.ns);
        case 'active'
            samples = sampling_active(G, params.ns, 0.05);
        otherwise
            error('unknown sampling type');
    end
    
    %Sample data
    cdata = {};
    cdata.raw = data.raw(samples, :);
    cdata.N = size(cdata.raw, 1);
    cdata.D = size(cdata.raw, 2);
    
    params.ke = min(150, cdata.N/2);
    
    if issparse(data.raw)
    %   fprintf('sparse), using cosine ...'); 
        [cdata.nn, cdata.dd] = knn_search_cosine(cdata.raw, params.ke);
    else
    %   fprintf('dense), using l2 ...');
       paramsnn = knn_graph_params(cdata, params.ke);
       [cdata.nn, cdata.dd] = knn_search(cdata.raw, params.ke, paramsnn);
    end
    
    cdata.G = graph_from_nn(cdata.nn, cdata.dd, 'perplexity');
    
    t1 = toc(ts1);
    
    %Sketch embedding
%     if strcmp(params.algo, 'tsne')
%         paramstsne.method = 'exact';
%         [cembed, t2, t2mt] = compute_dr(cdata, params.algo, nb_dim, paramstsne);
%     else
        [cembed, t2, t2mt] = compute_dr(cdata, params.algo, nb_dim);    
%    end
    ts3 = tic;
    
    switch params.diffusion
        case 'chd'
            diracs = zeros(G.N, params.ns);
            %optimize this
            for ii = 1:params.ns
               diracs(samples(ii), ii) = 1; 
            end

            ntig = gsp_norm_tig(G, params.kernel, 0);
            tig2 = gsp_filter_analysis(G, params.kernel_squared, diracs, params.filtering);

            [n, k] = size(tig2);
            lkd = tig2 ./ repmat(ntig, 1, k);
            lkd = lkd ./ repmat(ntig(samples)', n, 1);

            %weights_chd = (tanh( (lkd - 0)*3 ) + 1)/2;
            weights_chd = lkd;
            %weights_chd = abs(gsp_filter_analysis(G, gsp_design_expwin(G,0.05), diracs, params.filtering));
            nweights_chd = bsxfun(@rdivide, weights_chd, sum(weights_chd, 2));
            Y = nweights_chd*cembed;
        case 'tikhonov'
            t1 = tic;
            M = zeros(G.N, 1);
            M(samples) = 1;
            cembed_ext = zeros(G.N, 2);
            cembed_ext(samples, :) = cembed;
            Y = gsp_regression_tik(G, M, cembed_ext, 1);
            
        case 'rkhs'
            diracs = zeros(G.N, params.ns);
            %optimize this
            for ii = 1:params.ns
               diracs(samples(ii), ii) = 1; 
            end
            
            K = abs(gsp_filter_analysis(G, params.kernel, diracs, params.filtering));
            rkhs_lambda = 0.1;
            Kt = K(samples, :);

            M = (Kt + rkhs_lambda*eye(size(Kt, 1)));
            beta_x = M \ cembed(:,1);
            beta_y = M \ cembed(:,2);

            dx = K*beta_x;
            dy = K*beta_y;

            Y = [dx, dy];
            
        otherwise
            error('unknown diffusion type');
    end
    
    t3 = toc(ts3);
    
    t = t1 + t2 + t3;
    tmt = t1 + t2mt + t3;
    
end

