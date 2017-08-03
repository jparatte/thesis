function [ d, ecc ] = compute_diameter( G, params )
%COMPUTE_DIAMETER Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2
       params = {}; 
    end
    
    A = G.A - diag(diag(G.A));
    N = G.N;

    if ~isfield(params, 'type'), params.type = 'exact'; end % possible values are 'exact', 'roditty'
    
    switch params.type
        case 'exact'
            %% Compute exact ecc with APSP
            ecc = zeros(N, 1);
            
            for ii = 1:N
                ecc(ii) = max(bfs(A, ii));
            end

            d = max(ecc);
            
        case 'roditty'
            %% Compute approx ecc

            % Step 1 : random sample 

            ecc_approx = zeros(N, 1);

            s = round(sqrt(N));
            ns = round(s*log(N));

            [~, samples] = sampling_uniform(G, ns);

            % Step 2 : finding w

            dist_s = zeros(N, ns);

            for ii = 1:ns
                dist_s(:,ii) = bfs(A, samples(ii));
                ecc_approx(samples(ii)) = max(dist_s(:,ii));
            end

            [~, mm_idx] = max(min(dist_s, [], 2));

            w_idx = mm_idx(1);

            % Step 3 : finding Ns(w)

            [d_w, ~, pred_w] = bfs(A, w_idx);

            [~, nsw_idx] = sort(d_w);

            nsw_idx = nsw_idx(1:s);

            dist_nsw = zeros(N, s);

            for ii = 1:s
                dist_nsw(:,ii) = bfs(A, nsw_idx(ii));
                ecc_approx(nsw_idx(ii)) = max(dist_nsw(:,ii));
            end

            % Step 4 : approximate ecc

            oidx = setdiff(1:N, [samples'; nsw_idx]);

            for ii = 1:length(oidx)
                v = oidx(ii);
                % Find vt
                vt = pred_w(v);
                dvvt = 1;
                while ~any(nsw_idx==vt)
                    vt = pred_w(vt);
                    dvvt = dvvt + 1;
                end

                dvtw = d_w(vt);

                % Choose side
                if dvvt <= dvtw
                   ecc_approx(v) = max([max(dist_s(v, :)), d_w(v), ecc_approx(vt)]); 
                else
                   ecc_approx(v) = max([max(dist_s(v, :)), d_w(v), min(ecc_approx(samples))]);
                end

            end
            ecc = ecc_approx;
            d = max(ecc_approx);
            
        otherwise
            disp('not implemented');
    end

end

