function [  ] = datasets_components_reporting_all( source_set, prefix)
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    datapath = sprintf('%s/raw/%s', prefix, source_set);
    paths = load_all_paths(datapath);
    
    num_data = numel(paths);
    
    components = {'metadata', 'raw', 'nn', 'embedding'};
    num_comp = numel(components);
    
    methods = {'le', 'pca', 'lle', 'tsne', 'largevis'};
    num_methods = numel(methods);
    
    fprintf('Reporting components for %d datasets in %s :\n', num_data, datapath ); 
    
    for ii = 1:num_data
        dataname = name_from_path(paths{ii});
        fprintf('[%d] - %s (', ii, dataname);
        
        for jj = 1:num_comp
           
           
           fprintf('%s:',components{jj})
           
           if strcmp(components{jj}, 'embedding')
              nb_meth = 0;
               for kk = 1:num_methods
                   method = methods{kk};
                   cpath = sprintf('%s/%s/%s/%s_%s.mat', prefix, components{jj}, source_set, dataname, method);
                   if exist(cpath, 'file')
                      fprintf('%s ', method);
                   end
                   nb_meth = nb_meth + 1;
               end
                if nb_meth == 0
                       fprintf('NO ');
               end
               continue;
           end
           
           
           cpath = sprintf('%s/%s/%s/%s.mat', prefix, components{jj}, source_set, dataname);
           if exist(cpath, 'file')
               %chunk = load(cpath);
              fprintf('YES ');
               
           else
               fprintf('NO ');
           end
        end
        
        fprintf(')\n');
        
        
    end
end

