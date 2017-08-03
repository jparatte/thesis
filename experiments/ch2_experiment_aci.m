%% A : ACI

params.step = 0.05; %fine grained ! leave default for faster results
params.nb_runs = 20;
score = 'aci';

%% Compute benchmark for ACI - Cheeger

params.aci = 'cheeger';
ch2_run_experiment(score, params, '$ACI$', 'aci_a');

%% Compute benchmark ACI - Ncut

params.aci = 'ncut';
ch2_run_experiment(score, params, '$ACI$', 'aci_b');

%% Compute benchmark for ACI - Cheeger (Noisy)
params.aci = 'cheeger';
params.noise_level = 1;
params.noise_fraction = 0.1;

ch2_run_experiment(score, params, '$ACI$', 'aci_noise');