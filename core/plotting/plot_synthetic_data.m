function [ ] = plot_synthetic_data( data )
%PLOT_SYNTHETIC_DATA Summary of this function goes here
%   Detailed explanation goes here

    cats = unique(data.labels);
    
    %figure;
    for cc = 1:length(cats)
        cat = find(data.labels == cats(cc));
        hold on;
        scatter(data.raw(cat, 1), data.raw(cat, 2), 'x');
    end
    hold off;
end

