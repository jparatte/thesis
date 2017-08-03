
%dataset = 'mnist'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 1];pdiff = 2.0;mksize = 2;
%dataset = 'caltech101-caffenet'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 1, 1];pdiff = 4.0;mksize = 5;
dataset = 'nova'; prefix = GLOBAL_datasparseprefix; zoom = [0, 0, 0, 0];pdiff = 0.5;mksize = 5;


%dataset = 'usps'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 1];pdiff = 3.0;mksize = 5;
%dataset = 'coil20'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0, 0];pdiff = 3.0;mksize = 25;

export_on = 1;

methods = {'tsne', 'largevis', 'le', 'fears'};
titles = {'t-SNE', 'LargeVis', 'LE', 'FEARS'};
nm = numel(methods);

for ii = 1:nm
    f2 = figure;
    data = load_data(dataset, 'full', {sprintf('embedding:%s', methods{ii})}, prefix);
    
    plot2d(data.embedding, data.labels, mksize);
    
    if zoom(ii)
        xx = data.embedding(:,1);
        yy = data.embedding(:,2);
        xlim([prctile(xx, pdiff), prctile(xx, 100-pdiff)])
        ylim([prctile(yy, pdiff), prctile(yy, 100-pdiff)])
        title(sprintf('%s (zoom, p=%.2f)', titles{ii}, pdiff), 'FontName', 'cmr10');
    else
       title(sprintf('%s', titles{ii}), 'FontName', 'cmr10'); 
    end
    
    %legend('uniform', 'ntig', 'active', 'Location', 'NorthEast');
    %xlabel(sprintf('$N_s$'), 'Interpreter', 'latex', 'FontSize', 16);
    %ylabel(sprintf('$ACI$'), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
    
    
    
    set(gca, 'FontSize', 12);
    set(gca, 'FontName', 'cmr10');
    set(gca,'LooseInset',get(gca,'TightInset'))
    axis off;
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    if export_on
    export_fig(sprintf('export/ch3_experiment_vis_%s_%s.pdf', dataset, methods{ii}));
    close(f2);
    end
    
end