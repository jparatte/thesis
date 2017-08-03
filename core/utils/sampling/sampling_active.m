function [ samples, atoms, ntig ] = sampling_active( G, ns, gamma, class_idx )
%SAMPLING_ACTIVE Summary of this function goes here
%   Detailed explanation goes here
    %Use heat kernel (for positivity)
    
    
    if ~exist('class_idx', 'var')
        subset = 0;
    else
        subset = 1;
    end
    
    samples = zeros(ns, 1);
    atoms = zeros(G.N, ns);
    
    band = 0.05;
    g = gsp_design_heat(G, get_heat_tau(band));
    g2 = gsp_design_heat(G, 2*get_heat_tau(band));
    
    ntig = gsp_norm_tig(G, g , 0);
    ntig2 = ntig.^2;
        
    weight = ones(G.N, 1);
    sn = weight ./ ntig;

    %For the initial sample, take the max spread
    if subset
        [~, sample] = max(sn(class_idx));
        sample = class_idx(sample);
    else
        [~, sample] = max(sn);
    end
    
    samples(1) = sample;
    
    dirac = zeros(G.N, 1);
    dirac(samples(1)) = 1;

    atoms(:,1) = abs(gsp_filter_analysis(G, g, dirac));
    %atoms(:,1) = abs(gsp_filter_analysis(G, g2, dirac));
    weight = atoms(:,1);
    if ~exist('gamma', 'var')
        gamma = 0.0;
    end
    
    for ii = 2:ns

        %sn = weight ./ ntig2;
        sn = weight./ntig + gamma*sqrt(ntig);
        
        ind = ones(G.N, 1);
        ind(samples(1:ii-1)) = NaN; %TODO make it nice

        %[~, sample] = min(sn.*ind); 
        
        sni = sn .* ind;
        if subset
            [~, sample] = min(sni(class_idx));
            sample = class_idx(sample);
        else
            [~, sample] = min(sni);
        end
        
        samples(ii) = sample;
       
        dirac = zeros(G.N, 1);
        dirac(samples(ii)) = 1;
        atoms(:,ii) = abs(gsp_filter_analysis(G, g, dirac));  
        %atoms(:,ii) = abs(gsp_filter_analysis(G, g2, dirac)); 
        weight = weight + atoms(:,ii);
    end

end
