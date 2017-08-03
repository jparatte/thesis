
%% Create random sensor graph
N = 1000;
G = gsp_sensor(N);
G = gsp_estimate_lmax(G);

%% Compute the two measures and report mean values

gammas = 0:0.05:2.5;
K = length(gammas);
prct = zeros(K,1);
mus=zeros(K,1);
nr = 2000;
epsilon = 1e-4;

for kk = 1:K
    mu = 0;
    prc_miss = 0;
    for ii = 1:nr
        [samples, atoms, ntig] = sampling_active(G, 10, gammas(kk));
        prc_miss = prc_miss + length(find(sum(atoms, 2)./ntig < epsilon)) / G.N;
        mu = mu + min(sum(atoms, 2)./ntig);
    end
    prct(kk)=prc_miss/nr;
    mus(kk)=mu/nr;
end

%%
lw = 3;
f1 = figure;
plot(gammas, mus, 'LineWidth', lw);
ylabel(sprintf('$\\epsilon$'), 'Interpreter', 'latex', 'FontName','cmr10', 'FontSize', 16);
xlabel(sprintf('$\\gamma$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
set(gca, 'FontSize', 24)
set(gca, 'FontName', 'cmr10')
set(gca,'LooseInset',get(gca,'TightInset'))
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
save('export/ch2_example_active_regularization_epsilon.mat', 'gammas', 'mus');
export_fig('export/ch2_example_active_regularization_epsilon.pdf');
close(f1);


%%
f1 = figure;plot(gammas, prct, 'LineWidth', lw)
ylabel(sprintf('$| V_{\\epsilon_t} | / N$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
xlabel(sprintf('$\\gamma$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
set(gca, 'FontSize', 24)
set(gca, 'FontName', 'cmr10')
set(gca,'LooseInset',get(gca,'TightInset'))
set(f1, 'Position', [0 0 600 400])
set(f1, 'Color', 'w');
save('export/ch2_example_active_regularization_error.mat', 'gammas', 'prct');
export_fig('export/ch2_example_active_regularization_error.pdf');
close(f1);



%%

