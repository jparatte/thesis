fprintf('testing basic graph...');
try
    T = evalc('gsp_sensor(100)');
    fprintf('[OK]');
catch
    fprintf('[FAIL]');
end
fprintf('\n');

