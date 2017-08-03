function [result_matrix,  status_matrix] = datasets_reporting_table(source_set, metric, methods, prefix)
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    if ~exist('metric', 'var')
       metric = 'time'; 
    end
    
    if ~exist('methods', 'var')
        methods = {'pca', 'lle', 'le', 'tsne', 'largevis'};
    end

    num_methods = numel(methods);
    
    datapath = sprintf('%s/raw/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    result_matrix = zeros(num_data, num_methods);
    status_matrix = cell(num_data, num_methods);
    
    data_names = cell(num_data, 1);
    
    for ii = 1:num_data
        dataname = name_from_path(paths{ii});
        data_names{ii} = dataname;
        
        for jj = 1:num_methods
            
            str_elems = strsplit(methods{jj}, ':');
           if numel(str_elems) > 1
                epath = sprintf('%s/embedding/%s/%s_%s_%s.mat', prefix, source_set, dataname, str_elems{1}, str_elems{2});
           else
                epath = sprintf('%s/embedding/%s/%s_%s.mat', prefix, source_set, dataname, methods{jj});
           end

            if ~exist(epath, 'file')
               result_matrix(ii, jj) = NaN;
               status_matrix{ii, jj} = 'NA';
            else
                chunk = load(epath);
                
                if strcmp(metric, 'time')                        
                    if chunk.data.embedding_time < 0
                        result_matrix(ii, jj) = Inf;
                    else
                        result_matrix(ii, jj) = chunk.data.embedding_time;
                    end
                else
                    metric_field = sprintf('embedding_%s', metric);
                    if ~isfield(chunk.data, metric_field)
                        result_matrix(ii, jj) = NaN;
                    else
                        result_matrix(ii, jj) = getfield(chunk.data, metric_field);
                    end
                end
                status_matrix{ii, jj} = chunk.data.embedding_status;
            end
        end
        
    end
    
    params = {};
    params.hl = 'line';
    params.hl_order = 'low';
    params.hl_pos = [1 1 1 1];
    params.status_matrix = status_matrix;
    export_latex_tabular(result_matrix, methods, data_names, 'Time [s]', params);
end

