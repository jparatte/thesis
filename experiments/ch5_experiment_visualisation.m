
%dataset = 'mnist'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 2.0;mksize = 2;
%dataset = 'cifar10-cnn'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 2.0;mksize = 2;
%dataset = 'caltech256-caffenet'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 0.5;mksize = 5;
%dataset = 'norb'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 4.0;mksize = 5;
%dataset = 'usps'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 4.0;mksize = 5;


%dataset = 'caltech101-caffenet'; prefix = GLOBAL_dataprefix; zoom = [0, 0, 0, 0];pdiff = 4.0;mksize = 5;

export_on = 1;

methods = {'tsne', 'largevis', 'cgt:tsne', 'cgt:largevis'};
titles = {'t-SNE', 'LargeVis', 'CGT - t-SNE', 'CGT - LargeVis'};

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
    %set(f2, 'Position', [0 0 1200 800]);
    set(f2, 'Position', [0 0 600 400]);
    set(f2, 'Color', 'w');
    
    axis off;
    
    if export_on
        %elems = strsplit(methods{ii},':');
        export_fig(sprintf('export/ch5_experiment_vis_%s_%s.pdf', dataset, methods{ii}));
    close(f2);
    end
    
end