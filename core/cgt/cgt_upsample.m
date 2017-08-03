function [ signal_out ] = cgt_upsample( tree, signal_in, from_lvl, to_lvl, gamma )
%CGT_UPSAMPLE Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('to_lvl', 'var')
       to_lvl = tree.depth + 1; 
    end
    
    if ~exist('gamma', 'var')
        gamma = 1;
    end
    
    mdata = tree.data{from_lvl};
    
    if (mdata.N ~= size(signal_in, 1))
       error('Level size and signal size incompatible'); 
    end
    
    %1) simple copying from parents
    xt = signal_in(mdata.level_idx, :);
    
    %2) Diffuse with Tik
    if ~isfield(tree.data{to_lvl}, 'G')
       error('No graph at target level'); 
    end
    signal_out = gsp_prox_tik(xt, gamma, tree.data{to_lvl}.G);
    
end

