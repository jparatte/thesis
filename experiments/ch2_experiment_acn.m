%% C : ACN

params.step = 0.05; %fine grained ! leave default for faster results
params.nb_runs = 20;


%% Compute benchmark for different datasets

score = 'acn';
ch2_run_experiment(score, params, '$ACN$', 'acn', 1);
