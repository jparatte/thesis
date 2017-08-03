function [ quality ] = compute_quality( data, name, params )
%COMPUTE_DR Main function to compute embedding quality scores
%   name : ['aci', ]

    if ~isstruct(data) || ~isfield(data, 'embedding') || ~isfield(data, 'labels')
       error('The input parameters data.embedding and data.labels need to be present'); 
    end

    fct_name = sprintf('quality_%s', name);
    
    try
        if nargin < 3
            [quality, ~] = feval(fct_name, data);
        else
            [quality, ~] = feval(fct_name, data, params);
        end
    catch
        fprintf('An error occurred or the function %s is not available.\n', name);
    end

end

