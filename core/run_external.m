function [] = run_external(data_name, source_set, method, data_kernel, prefix, graph_only)
    
    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    if ~exist('graph_only', 'var')
       graph_only = 0; 
    end
    
    if ~exist('data_kernel', 'var')
       data_kernel = 'perplexity'; 
    end
    
    target_dim = 2;

    str_elems = strsplit(method, ':');
    if numel(str_elems) > 1
        method = str_elems{1};
        inner_algo = str_elems{2};
    end


    if numel(str_elems) > 1
        epath = sprintf('%s/embedding/%s/%s_%s_%s.mat', prefix, source_set, data_name, str_elems{1}, str_elems{2});
    else
        epath = sprintf('%s/embedding/%s/%s_%s.mat', prefix, source_set, data_name, method);
    end

    if graph_only
        components = {'raw'};
    else
        components = {'nn'};
        if strcmp(method, 'lle') || strcmp(method, 'cdr') || strcmp(method, 'cgt')
            components = {'nn', 'raw'};
        end

        if strcmp(method, 'pca')
            components = {'raw'};
        end
    end

    data = {};
    
    try 
        indata = load_data(data_name, source_set, components, prefix);
        
        if ~strcmp(method, 'pca')
            if isfield(indata, 'nn')
                max_k = 0;
                if strcmp(method, 'fears')
                   max_k = 50;
                   data_kernel = 'gaussian';
                end
                if strcmp(method, 'cdr') || strcmp(method, 'cgt')
                   max_k = 20; 
                   data_kernel = 'gaussian';
                end
                
                if max_k > 0
                    indata.G = graph_from_nn(indata.nn, indata.dd, data_kernel, max_k);
                else
                    indata.G = graph_from_nn(indata.nn, indata.dd, data_kernel);
                end
            else
                indata.G = gsp_graph(indata.W);
            end
        end
        if indata.N > 4000000
            fprintf('Too big for batch processing');
            return
        end
        if ~isfield(indata, 'raw') && (strcmp(method, 'pca') || strcmp(method, 'lle'))
            data.embedding_time = -1;
            data.embedding_status = 'NA';
            data.embedding_exception = 'Embedding method unable to process graph-only data';
            save(epath, 'data');
            return
        end
    catch ME
        fprintf('Error when preparing data\n');
        fprintf('%s', ME.message);
        
        data.embedding_time = -1;
        data.embedding_status = 'RE';
        data.embedding_exception = ME.message;
        
        save(epath, 'data');
        return
    end
    
    try
        if strcmp(method, 'cdr') || strcmp(method, 'cgt')
            paramsdr.algo = inner_algo;
            [data.embedding, data.embedding_time] = compute_dr(indata, method, target_dim, paramsdr);
        else
            [data.embedding, data.embedding_time] = compute_dr(indata, method, target_dim);
        end
        data.embedding_status = 'OK';
    catch ME
        data.embedding_time = -1;
        if strcmp(ME.identifier, 'MATLAB:nomem') || strcmp(ME.identifier, 'MATLAB:pmaxsize') 
            data.embedding_status = 'OM';
        else
            data.embedding_status = 'RE';
        end
        data.embedding_exception = ME.message;
        
    end
    save(epath, 'data');
end


%MException('MATLAB:nomem','Out of memory. Type HELP MEMORY for your options.') and MException('MATLAB:pmaxsize','Maximum variable size allowed by the program is exceeded.')