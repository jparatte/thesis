function [  ] = datasets_compute_embedding_scores(methodname, source_set, scores, force, prefix)
%DATASETS_COMPUTE_EMBEDDING_SCORES Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    if ~exist('force', 'var')
       force = 0; 
    end

    if ~exist('scores', 'var')
        scores = {'aci', '1nn', 'acc', 'acn'}; 
    end
    
    datapath = sprintf('%s/embedding/%s', prefix, source_set);
    paths = load_all_paths(datapath);

    num_data = numel(paths);
    
    
    fprintf('Computing embedding scores for %d datasets in %s :\n', num_data, datapath ); 

    for ii = 1:num_data
        dataname = name_from_path(paths{ii});
        elems = strsplit(dataname, '_');
        if numel(elems) == 2
            method = elems{2};
        else
            method = sprintf('%s:%s', elems{2}, elems{3});
        end
        
        if (~strcmp(method, methodname))
            fprintf('[%d] - skipping %s ... (not %s)\n', ii, dataname, methodname);
            continue
        end
        chunk = load(paths{ii});
        
        
        data = chunk.data; %copy data
        if ~isfield(data, 'labels')
            
            mpath = sprintf('%s/metadata/%s/%s.mat', prefix, source_set, elems{1});
            chunk = load(mpath);
            data.labels = chunk.data.labels;
            data.N = chunk.data.N;
            if isfield(chunk.data, 'D')
                data.D = chunk.data.D;
            end
        end
        
        
        
        fprintf('[%d] - processing %s ... ', ii, dataname);
        
        if isfield(data, 'embedding_status') && strcmp(data.embedding_status, 'OK')

            if (length(data.labels) ~= data.N) || (size(data.embedding, 1) ~= data.N)
                fprintf('... wrong embedding size, skipping.\n'); 
                continue;
            end
            
            if any(isnan(data.embedding))
                warning('embedding contains NaN!'); 
            end
            
            ns = numel(scores);
            
            for ss = 1:ns
                fprintf('\n# %s ...', scores{ss});
                field_name = sprintf('embedding_%s', scores{ss});
                if ~isfield(data, field_name) || force
                    data = setfield(data, field_name, compute_quality(data, scores{ss}));
                    fprintf('done.\n');
                else
                    fprintf('skipping.\n');
                end
            end
            
            save(paths{ii}, 'data');
        else
           fprintf(' skipping');
           if isfield(data, 'embedding_status')
                fprintf('(%s)\n', data.embedding_status);
           else
               fprintf('(NA)\n');
           end
        end
    end

end

