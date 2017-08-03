%% A : display synthetic data

k = 4;
n = 200;
N = 2*k*n;
params.data.name = 'band';

lbd = [0, 0.3, 0.6, 1];

f1 = figure;
for ii = 1:4
    params.lambda = lbd(ii);

    subplot(3,4,ii)
    data = generate_data(N, k, params);
    plot_synthetic_data(data);
    xlim([-8, 0])
    %xlabel(sprintf('$\\lambda = %0.1f$', lbd(ii)), 'Interpreter', 'latex', 'FontSize', 16);
end


params.data.name = 'circle';
for ii = 1:4
    params.lambda = lbd(ii);

    subplot(3,4,ii+4)
    data = generate_data(N, k, params);
    plot_synthetic_data(data);
    %xlabel(sprintf('$\\lambda = %0.1f$', lbd(ii)), 'Interpreter', 'latex', 'FontSize', 16);
end

params.data.name = 'square';
for ii = 1:4
    params.lambda = lbd(ii);

    subplot(3,4,ii+8)
    data = generate_data(N, k, params);
    plot_synthetic_data(data);
    ylim([0, 4])
    xlim([0, 4])
    xlabel(sprintf('$\\lambda = %0.1f$', lbd(ii)), 'Interpreter', 'latex', 'FontSize', 16);
end
set(f1, 'Position', [0 0 1000 600])
set(f1, 'Color', 'w');
%export_fig 'synthetic_data.pdf';
%close(f1);
