function [ pp ] = fix_perplexity( dd, u, tol )
%FIX_PERPLEXITY Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('u', 'var') || isempty(u)
        u = 50;
    end
    if ~exist('tol', 'var') || isempty(tol)
        tol = 1e-5; 
    end
    
    %normalize distance
    dd = dd / max(max(dd));
    dd = dd.^2;
    
    % Initialize some variables
    k = size(dd, 2);
    n = size(dd, 1);                     % number of instances
    pp = zeros(n, k);                    % empty probability matrix
    beta = ones(n, 1);                  % empty precision vector
    logU = log(u);                      % log of perplexity (= entropy)

    % Run over all datapoints
    for i=1:n
        
        if ~rem(i, 500)
            disp(['Computed P-values ' num2str(i) ' of ' num2str(n) ' datapoints...']);
        end
        
        % Set minimum and maximum values for precision
        betamin = -Inf; 
        betamax = Inf;

        % Compute the Gaussian kernel and entropy for the current precision
        [H, thisP] = Hbeta(dd(i, :), beta(i));
        
        % Evaluate whether the perplexity is within tolerance
        Hdiff = H - logU;
        tries = 0;
        while abs(Hdiff) > tol && tries < 200
            
            % If not, increase or decrease precision
            if Hdiff > 0
                betamin = beta(i);
                if isinf(betamax)
                    beta(i) = beta(i) * 2;
                else
                    beta(i) = (beta(i) + betamax) / 2;
                end
            else
                betamax = beta(i);
                if isinf(betamin) 
                    beta(i) = beta(i) / 2;
                else
                    beta(i) = (beta(i) + betamin) / 2;
                end
            end
            
            % Recompute the values
            [H, thisP] = Hbeta(dd(i,:), beta(i));
            Hdiff = H - logU;
            tries = tries + 1;
        end
        
        % Set the final row of P
        pp(i, :) = thisP;
    end
    
    disp(['Mean value of sigma: ' num2str(mean(sqrt(1 ./ beta)))]);
    disp(['Minimum value of sigma: ' num2str(min(sqrt(1 ./ beta)))]);
    disp(['Maximum value of sigma: ' num2str(max(sqrt(1 ./ beta)))]);
end
    


% Function that computes the Gaussian kernel values given a vector of
% squared Euclidean distances, and the precision of the Gaussian kernel.
% The function also computes the perplexity of the distribution.
function [H, P] = Hbeta(D, beta)
    P = exp(-D * beta);
    sumP = sum(P);
    H = log(sumP) + beta * sum(D .* P) / sumP;
    % why not: H = exp(-sum(P(P > 1e-5) .* log(P(P > 1e-5)))); ???
    P = P / sumP;
end
