source_set = 'full';
cmdouts = cell(10, 1);
global GLOBAL_datalargeprefix;

%Timeouts
cmdouts{1} = run_timing('cdr:tsne', 'ilsvrc12-caffenet', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 0);
cmdouts{2} = run_timing('cdr:largevis', 'ilsvrc12-caffenet', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 0);
cmdouts{3} = run_timing('largevis', 'ilsvrc12-caffenet', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 0);
cmdouts{4} = run_timing('tsne', 'ilsvrc12-caffenet', source_set, 'gaussian', '100h', GLOBAL_datalargeprefix, 0);
cmdouts{5} = run_timing('fears', 'ilsvrc12-caffenet', source_set, 'gaussian', '24h',GLOBAL_datalargeprefix, 0);

save('export/cmdout_ch4_cdr_vis_large.mat', 'cmdouts');

%cmdouts{6} = run_timing('le', 'ilsvrc12-caffenet', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 1);