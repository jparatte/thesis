%% Params
dataname = 'mnist';
source_set = 'full';

params = {};
params.algo = 'tsne';
params.sampling = 'uniform';
%params.ns = 1000;

diffusion = {'chd', 'tikhonov', 'rkhs'};
%diffusion = {'chd'};
nd = numel(diffusion);

embeddings = cell(nd, 1);

data = load_data(dataname, source_set, {'raw', 'nn'});
data.G = graph_from_nn(data.nn, data.dd, 'gaussian', 25);

for ii = 1:nd
    params.diffusion = diffusion{ii};
    [embeddings{ii}, t, tmt, sketch, samples] = dr_cdr(data, 2, params);
    fprintf('%d - %f\n', ii, t);
end

save('export/ch4_experiment_diffusion.mat', 'embeddings', 'sketch');

%%
figure;
for ii = 1:nd
    subplot(1, 3, ii)
   plot2d(embeddings{ii},data.labels);
   title(diffusion{ii});
end
%close;
%%

titles = {'CHD', 'Tikhonov', 'RKHS'};
for ii = 1:nd
    f2 = figure;
    plot2d(embeddings{ii}, data.labels, 2);
        
%legend('uniform', 'ntig', 'active', 'Location', 'NorthEast');
%xlabel(sprintf('$N_s$'), 'Interpreter', 'latex', 'FontSize', 16);
%ylabel(sprintf('$ACI$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
    
    title(sprintf('%s', titles{ii}), 'FontName', 'cmr10');
    set(gca, 'FontSize', 12);
    set(gca, 'FontName', 'cmr10');
    axis off;
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch4_experiment_diffusion_%s.pdf', lower(titles{ii})));
    close(f2);
end
%% Show sketch
f2 = figure;
plot2d(sketch, data.labels(samples))
title(sprintf('Sketch'), 'FontName', 'cmr10');
set(gca, 'FontSize', 12);
set(gca, 'FontName', 'cmr10');
axis off;
set(f2, 'Position', [0 0 600 400]);
set(f2, 'Color', 'w');
export_fig(sprintf('export/ch4_experiment_diffusion_sketch.pdf'));
close(f2);

%% Zoomed-in

for ii = 2:nd
    f2 = figure;
    plot2d(embeddings{ii}, data.labels, 2);
    
    xx = embeddings{ii}(:,1);
    yy = embeddings{ii}(:,2);
    xlim([prctile(xx, 0.2), prctile(xx, 99.8)])
    ylim([prctile(yy, 0.2), prctile(yy, 99.8)])

%legend('uniform', 'ntig', 'active', 'Location', 'NorthEast');
%xlabel(sprintf('$N_s$'), 'Interpreter', 'latex', 'FontSize', 16);
%ylabel(sprintf('$ACI$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
    
    title(sprintf('%s (zoom)', titles{ii}), 'FontName', 'cmr10');
    set(gca, 'FontSize', 12);
    set(gca, 'FontName', 'cmr10');
    axis off;
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    export_fig(sprintf('export/ch4_experiment_diffusion_%s_zoom.pdf', lower(titles{ii})));
    close(f2);
end


%% compute scores
for ii = 1:nd
   data.embedding = embeddings{ii};
   aci = compute_quality(data, 'aci', 'ncut');
   %acc = compute_quality(data, 'acc');
   acc = 0;
   acn = compute_quality(data, 'acn');
   fprintf('[%d] - %s : aci %.3f acc %.3f acn %.3f\n', ii, diffusion{ii}, aci, acc, acn );
end
