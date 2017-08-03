global GLOBAL_datasparseprefix;
prefix = GLOBAL_datasparseprefix;

timeout = '2h';
target_dim = 2;
source_set = 'full';
%methods = {'le', 'pca', 'lle', 'tsne', 'largevis', 'fears', 'cdr:tsne', 'cdr:largevis'};
methods = {'cgt:tsne', 'cgt:largevis'};
data_names = load_all_names(source_set, prefix);

num_data = numel(data_names);
num_methods = numel(methods);

fprintf('Running %d algos on %d datasets in %s :\n', num_methods, num_data, prefix ); 

for ii = 1:num_data
    
    fprintf('[%d] - processing %s ... \n', ii, data_names{ii});
    
    for jj = 1:num_methods
       run_timing(methods{jj}, data_names{ii},source_set, 'perplexity',timeout,prefix);
    end
end