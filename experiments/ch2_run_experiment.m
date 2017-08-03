function [  ] = ch2_run_experiment( score, params, yl, exp_name, exp_noise )
%CH2_RUN_EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 5
        exp_noise = 0;
    end
    
    if ~exp_noise
        [res_band, shifts] = benchmark_scores_synthetic(score, 'band', params);
        [res_circle, ~] = benchmark_scores_synthetic(score, 'circle', params);
        [res_square, ~] = benchmark_scores_synthetic(score, 'square', params);
        
        save(sprintf('export/ch2_experiment_%s.mat', exp_name), 'res_band', 'res_circle', 'res_square', 'shifts');
        
        f2 = figure;
        
        subplot(1,3,1);
        plot_scores_synthetic(res_band, shifts, '$\\lambda$', yl);

        subplot(1,3,2);
        plot_scores_synthetic(res_circle, shifts, '$\\lambda$', yl);

        subplot(1,3,3);
        plot_scores_synthetic(res_square, shifts, '$\\lambda$', yl);
        
        %% Plot the result

        set(f2, 'Position', [0 0 1000 250])
        set(f2, 'Color', 'w');

        export_fig(sprintf('export/ch2_experiment_%s.pdf', exp_name));
        close(f2);
    else
       [res_band, nl_range, nf_range] = benchmark_scores_synthetic_noise(score, 'band', params);
       [res_circle, ~] = benchmark_scores_synthetic_noise(score, 'circle', params);
       [res_square, ~] = benchmark_scores_synthetic_noise(score, 'square', params); 
       
       save(sprintf('export/ch2_experiment_%s.mat', exp_name), 'res_band', 'res_circle', 'res_square', 'nl_range', 'nf_range');
       
        f2 = figure;

        variability = 'noise_level';
        subplot(1,3,1);
        plot_scores_synthetic_noise(res_band, nl_range, nf_range, yl, variability);

        subplot(1,3,2);
        plot_scores_synthetic_noise(res_circle, nl_range, nf_range, yl, variability);

        subplot(1,3,3);
        plot_scores_synthetic_noise(res_square, nl_range, nf_range, yl, variability);

        set(f2, 'Position', [0 0 1000 250])
        set(f2, 'Color', 'w');

        export_fig(sprintf('export/ch2_experiment_%s_%s.pdf', exp_name, variability));
        close(f2);
        
        f2 = figure;

        variability = 'noise_fraction';
        subplot(1,3,1);
        plot_scores_synthetic_noise(res_band, nl_range, nf_range, yl, variability);

        subplot(1,3,2);
        plot_scores_synthetic_noise(res_circle, nl_range, nf_range, yl, variability);

        subplot(1,3,3);
        plot_scores_synthetic_noise(res_square, nl_range, nf_range, yl, variability);

        set(f2, 'Position', [0 0 1000 250])
        set(f2, 'Color', 'w');

        export_fig(sprintf('export/ch2_experiment_%s_%s.pdf', exp_name, variability));
        close(f2);
    end

    
end

