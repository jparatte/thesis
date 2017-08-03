
X  = randn(200, 50);

fprintf('testing fast_tsne...');
try
    T = evalc('fast_tsne(X, 2)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');

%%
X  = randn(100, 20);
fprintf('testing tsne...');
try
    T = evalc('tsne(X, 2)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');


%%
X = randn(400, 3);
W = sparse(squareform(pdist(X)));
fprintf('testing sparse_tsne...');
try
    T = evalc('sparse_tsne(W, 2)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');

%%

X = randn(100, 3);
W = sparse(squareform(pdist(X)));
fprintf('testing p_tsne...');
try
    T = evalc('tsne_p(W, 2)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');
