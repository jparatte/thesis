function [ cmdout ] = run_timing(method, dataname, source_set, kernel_type, timeout, prefix, graph_only )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end

    if ~exist('source_set', 'var')
       source_set = 'full'; 
    end
    
    if ~exist('timeout', 'var')
        timeout = '2h';
    end
    
    if ~exist('kernel_type', 'var')
        kernel_type = 'gaussian';
    end

    if ~exist('graph_only', 'var')
        graph_only = 0;
    end
    
        fprintf('# %s:%s ...', dataname, method);
       str_elems = strsplit(method, ':');
       if numel(str_elems) > 1
            epath = sprintf('%s/embedding/%s/%s_%s_%s.mat', prefix, source_set, dataname, str_elems{1}, str_elems{2});
       else
            epath = sprintf('%s/embedding/%s/%s_%s.mat', prefix, source_set, dataname, method);
       end
       
       if exist(epath, 'file')
          chunk = load(epath);
          if isfield(chunk.data, 'embedding_status') && strcmp(chunk.data.embedding_status, 'OK')
              fprintf('already OK, skipping.\n');
              return;
          end
       end
       
       data = {};
       data.embedding_time = -1;
       data.embedding_status = 'TO';
       save(epath, 'data');
       
       [status, cmdout] = system(sprintf('timeout %s matlab -nodisplay -nosplash -nodesktop -r "init;run_external(''%s'',''%s'',''%s'',''%s'',''%s'',%d);exit;"',...
           timeout, dataname, source_set, method, kernel_type, prefix, graph_only));
       
       fprintf(' done.\n');
end

