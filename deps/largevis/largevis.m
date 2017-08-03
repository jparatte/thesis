function [ Y, t, tmt ] = largevis( data, nb_dims, type )
%LARGEVIS Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('type', 'var')
       type = 'features'; 
    end
    
    type = 'graph'; 
    
    if ~exist('nb_dims', 'var')
       nb_dims = 2; 
    end
    
    lv_path = which('largevis.m');
    lv_path = fileparts(lv_path);
    
    switch type
        case 'features'
            dlmwrite('indata.dat', [data.N, data.D], 'delimiter', ' ');
            dlmwrite('indata.dat', data.raw, '-append', 'delimiter', ' ','precision', 6);
            
            % Run the C++ implementation
            tic, system(fullfile(lv_path, sprintf('./LargeVis -input indata.dat -output outdata.dat -outdim %d', nb_dims))); toc

           
        case 'graph'
            if isfield(data, 'G')
                G = data.G;
            else
                G = knn_graph(data);
            end
            
            [idxi, idxj, val] = find(G.W);
            dlmwrite('indata.dat', [idxi, idxj, val], 'delimiter', ' ','precision', 6);
            
            % Run the C++ implementation
            tic, system(sprintf('time %s/LargeVis -fea 0 -input indata.dat -output outdata.dat -outdim %d',lv_path, nb_dims)); toc
            
        otherwise
            error('Invalid LargeVis type');
    end
    
    tt = dlmread('outdata.dat', ' ', [1 0 1 1]);
    t = tt(1);
    tmt = tt(2);
    outdata = dlmread('outdata.dat', ' ', 2, 0);
    [~, sorted_idx] = sort(outdata(:,1));
    Y = outdata(sorted_idx, 2:end);
    
    delete('indata.dat');
    delete('outdata.dat');
end

