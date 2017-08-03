function [  ] = plot_scores_synthetic( results, shifts, xl, yl )
%PLOT_SCORES_SYNTHETIC Summary of this function goes here
%   Detailed explanation goes here
    lw = 1.5;  
    
    K = size(results, 2);
    
    for jj = 1:K
        hold on;
        plot(shifts, results(:,jj), 'LineWidth',lw);
        xlabel(sprintf('$\\lambda$'), 'Interpreter', 'latex', 'FontSize', 16);
        ylabel(sprintf('%s', yl), 'Interpreter', 'latex','FontName','cmr10', 'FontSize', 16);
        set(gca, 'FontSize', 18)
        set(gca, 'FontName', 'cmr10')
    end
    
end

