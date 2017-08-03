function [ signal_out ] = cgt_downsample( tree, signal_in, from_lvl, to_lvl, signal_type)
%CGT_DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('from_lvl', 'var')
       from_lvl = tree.depth + 1; 
    end
    
    if ~exist('signal_type', 'var')
       signal_type = 'categorical'; %  
    end

    fdata = tree.data{from_lvl};
    
    if (fdata.N ~= size(signal_in, 1))
       error('Level size and signal size incompatible'); 
    end
    
    tdata = tree.data{to_lvl};
    
    parents = unique(tdata.level_idx);
    np = length(parents);
    signal_out = zeros(np, 1);
    
    switch signal_type
        case 'real'
            for pp = 1:np
                signal_out(pp) = mean(signal_in(find(tdata.level_idx == parents(pp))));
            end
        case 'categorical'
            for pp = 1:np
               signal_out(pp) = mode(signal_in(find(tdata.level_idx == parents(pp))));
            end
        otherwise
            error('unknown signal type');
    end
end

