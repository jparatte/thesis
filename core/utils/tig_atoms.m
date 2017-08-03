function [ atoms ] = tig_atoms( G, samples, g )
%TIG_ATOMS Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
       g = gsp_design_heat(G, get_heat_tau(0.001)); 
    end
    
    deltas = zeros(G.N, 10);
    for ii = 1:10
        deltas(samples(ii), ii) = 1;
    end
    
    paramfilter.order = 100;
    atoms = gsp_filter_analysis(G, g, deltas, paramfilter);

end

