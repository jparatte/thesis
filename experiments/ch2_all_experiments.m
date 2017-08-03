%% A : Synthetic data

experiments = {...
    'ch2_experiment_aci', ...
    'ch2_experiment_1nn', ...
    'ch2_experiment_acc', ...
    'ch2_experiment_acn', ...
    };

n = length(experiments);

fprintf('\nCH2 - Synthetic data\nRunning %d experiments.\n', n);

for ii = 1:n
    fprintf('[%d] - running %s ...', ii, experiments{ii});
    ts = tic;
    run(experiments{ii});
    te = toc(ts);
    fprintf(' finished. ( in %.2fs)\n', te);
end

%% B : Natural data