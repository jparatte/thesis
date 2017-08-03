function [ G ] = cosine_graph( X, k )
%COSINE_GRAPH Summary of this function goes here
%   Detailed explanation goes here
    D = X * X';
    n = size(X, 1);
    
    [D_sort,idx_sort] = sort(D,2,'descend');
    
    Dcos = abs(acos(D_sort));
    Dist = Dcos;
    
    % Select k nearest neighbors (in k-NN)
    Dk = Dist(:,1:k);
    Idxk = idx_sort(:,2:k+1);
    
    % Compute scale parameter of graph weigth function
    sigma = Dk(:,k)';
    sigma = mean(sigma);
    
    % Compute graph
    idxi = zeros(k*n,1);
    idxj = zeros(k*n,1);
    entries = zeros(k*n,1);
    cpt = 1;
    for i = 1:n
        idxi(cpt:cpt+k-1) = Idxk(i,1);
        idxj(cpt:cpt+k-1) = Idxk(i,:);
        entries(cpt:cpt+k-1) = exp(-(Dk(i,:).^2)./ sigma^2); %  Gaussian weight function
        %entries(cpt:cpt+k-1) = 1; % Binary weight
        cpt = cpt+k;
    end
    W = sparse(idxi,idxj,entries,n,n);
    W = max(W,W');
    G = gsp_graph(W);

end

