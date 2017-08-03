function [ data ] = load_data( name, source_set, components, prefix )
%LOAD_DATA Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('source_set', 'var')
        source_set = '1k';
    end
    
    if ~exist('components', 'var')
        components = {'raw'};
    end
    
    global GLOBAL_dataprefix;
    if ~exist('prefix', 'var')
        prefix = GLOBAL_dataprefix;
    end
    
    fprintf('Loading dataset %s (%s) \n', name, source_set);
    
    data = struct();
    %Load metadata
    fprintf('# metadata ... ');
    try
        chunk = load(sprintf('%s/metadata/%s/%s.mat', prefix, source_set, name));
        data = chunk.data;
        fprintf('[OK]\n');
    catch
        fprintf('[FAIL]\n');
    end
    
    
    %Load additional comps
    for ii=1:numel(components)
        fprintf('# %s ... ', components{ii});
        try
            %fprintf('(');
            elems = strsplit(components{ii},':');
            if numel(elems) == 1
                chunk = load(sprintf('%s/%s/%s/%s.mat', prefix, components{ii}, source_set, name));
            elseif numel(elems) == 2
                chunk = load(sprintf('%s/%s/%s/%s_%s.mat', prefix, elems{1}, source_set, name, elems{2}));
            elseif numel(elems) == 3
                chunk = load(sprintf('%s/%s/%s/%s_%s_%s.mat', prefix, elems{1}, source_set, name, elems{2}, elems{3}));
            end
            fnames = fieldnames(chunk.data);
            for jj = 1:numel(fnames)
               if ~isfield(data, fnames{jj}) %skip already present fields
                   data = setfield(data, fnames{jj}, getfield(chunk.data, fnames{jj}));
                   %fprintf(' %s', fnames{jj});
               end
            end
            fprintf('[OK]\n');
        catch
            fprintf('[FAIL]\n');
        end
    end
end
