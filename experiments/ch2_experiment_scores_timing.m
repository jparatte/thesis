%% ACI 

k = 2;

nn = (2.^(2:12)) * 1000;
M = length(nn);

time_vec_aci = zeros(M, 1);
time_vec_acc = zeros(M, 1);
time_vec_acn = zeros(M, 1);
time_vec_1nn = zeros(M, 1);

for ii = 1:M 
    %n = 200;
    n = nn(ii);
    data = {};
    data.embedding = randn(n, 2);
    data.labels = randi(k, n, 1);
    data.N = n;
    data.D = 2;
    ts = tic;
    aci = compute_quality(data, 'aci');
    te = toc(ts);
    time_vec_aci(ii) = te;
    ts = tic;
    acc = compute_quality(data, 'acc');
    te = toc(ts);
    time_vec_acc(ii) = te;
    ts = tic;
    acn = compute_quality(data, 'acn');
    te = toc(ts);
    time_vec_acn(ii) = te;
    ts = tic;
    nns = compute_quality(data, '1nn');
    te = toc(ts);
    time_vec_1nn(ii) = te;
end

save(sprintf('export/ch2_experiment_scores_timing.mat'), 'nn', 'time_vec_aci', 'time_vec_1nn', 'time_vec_acc', 'time_vec_acn'); 

%%
f2 = figure;
semilogy(nn, [time_vec_aci, time_vec_1nn, time_vec_acc, time_vec_acn], '-x', 'LineWidth', 1.5);
legend('acc', '1nn', 'acc', 'acn', 'Location','southeast');
xlabel(sprintf('$N$'), 'Interpreter', 'latex', 'FontSize', 16);
ylabel(sprintf('time $\\log(s)$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
ylim([10^-3, 10^4]);
set(gca, 'FontSize', 18)
set(gca, 'FontName', 'cmr10')
set(f2, 'Position', [0 0 600 400])
set(f2, 'Color', 'w');

export_fig(sprintf('export/ch2_experiment_scores_timing.pdf'));
close(f2);