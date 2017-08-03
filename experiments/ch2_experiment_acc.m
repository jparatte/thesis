%% D : ACC

params.step = 0.05; %fine grained ! leave default for faster results
params.nb_runs = 20;
score = 'acc';

%% a) Noiseless case ACC - OneShot / Euclidean

params.type = 'oneshot';
params.dist_type = 'euclidean';
ch2_run_experiment(score, params, '$ACC$', 'acc_a');

%% b) Noiseless case ACC - Randomized / Euclidean

params.type = 'randomized';
params.dist_type = 'euclidean';
ch2_run_experiment(score, params, '$ACC$', 'acc_b');

%% c) Noiseless case ACC - OneShot / Geodesic

params.type = 'oneshot';
params.dist_type = 'geodesic';
ch2_run_experiment(score, params, '$ACC$', 'acc_c');

%% d) Noiseless case ACC - Randomized / Geodesic

params.type = 'randomized';
params.dist_type = 'geodesic';
ch2_run_experiment(score, params, '$ACC$', 'acc_d');

%% e) Noiseless case ACC - OneShot / KDD

params.type = 'oneshot';
params.dist_type = 'kdd';
ch2_run_experiment(score, params, '$ACC$', 'acc_e');

% f) Noiseless case ACC - Randomized / KDD

params.type = 'randomized';
params.dist_type = 'kdd';
ch2_run_experiment(score, params, '$ACC$', 'acc_f');


%% Noisy case

params.noise_level = 1;
params.noise_fraction = 0.1;

%% a) Noisy case ACC - OneShot / Euclidean

params.type = 'oneshot';
params.dist_type = 'euclidean';
ch2_run_experiment(score, params, '$ACC$', 'acc_noise_a');

%% b) Noisy case ACC - Randomized / Euclidean

params.type = 'randomized';
params.dist_type = 'euclidean';
ch2_run_experiment(score, params, '$ACC$', 'acc_noise_b');