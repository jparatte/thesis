data.raw  = randn(200, 50);
data.N = 200;
data.D = 50;

fprintf('testing largevis...');
try
    T = evalc('largevis(data, 2)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');
