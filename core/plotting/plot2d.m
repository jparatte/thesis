function [  ] = plot2d( Y, labels, mksize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %figure;
    if ~exist('mksize', 'var')
       mksize = 15; 
    end
    
    scatter(Y(:,1), Y(:,2), mksize, labels, 'o', 'filled');
    colormap jet;


end

