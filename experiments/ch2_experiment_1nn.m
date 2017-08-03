%% B : 1NN

params.step = 0.05; %fine grained ! leave default for faster results
params.nb_runs = 20;

%% Compute benchmark for 1NN (noiseless)

score = '1nn';
ch2_run_experiment(score, params, '$1NN$', '1nn');

%% Compute benchmark for 1NN (noisy)

params.noise_level = 1;
params.noise_fraction = 0.1;

ch2_run_experiment(score, params, '$1NN$', '1nn_noise');
