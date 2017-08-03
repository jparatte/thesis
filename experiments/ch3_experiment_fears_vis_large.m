source_set = 'full';
cmdouts = cell(10, 1);
global GLOBAL_datalargeprefix;

%Timeouts
cmdouts{1} = run_timing('largevis', 'livejournal', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 1);
cmdouts{2} = run_timing('fears', 'livejournal', source_set, 'gaussian', '24h',GLOBAL_datalargeprefix, 1);
cmdouts{3} = run_timing('tsne', 'livejournal', source_set, 'gaussian', '100h', GLOBAL_datalargeprefix, 1);
cmdouts{4} = run_timing('le', 'livejournal', source_set, 'gaussian', '24h', GLOBAL_datalargeprefix, 1);