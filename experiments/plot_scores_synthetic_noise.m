function [  ] = plot_scores_synthetic_noise( results, nl_range, nf_range, yl, variability )
%PLOT_SCORES_SYNTHETIC Summary of this function goes here
%   Detailed explanation goes here
    lw = 1.5;  
    
    if ~exist('variability', 'var')
        variability = 'noise_level';
    end
    
    if strcmp(variability, 'noise_level')
       K = length(nf_range);
       results = transpose(results);
       range = nl_range;
       xl = '$\sigma_n$';
    else
       K = length(nl_range);
       range = nf_range;
       xl = 'noise \%';
    end
    
    for jj = 1:K
        hold on;
        plot(range, results(jj,:), 'LineWidth',lw);
        ylabel(sprintf('%s', yl), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
        xlabel(sprintf('%s', xl), 'Interpreter', 'latex', 'FontSize', 16);
        set(gca, 'FontSize', 18)
        set(gca, 'FontName', 'cmr10')
    end
    
end

