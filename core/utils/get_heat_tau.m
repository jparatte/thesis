function tau = get_heat_tau( band, vcut )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 2
        vcut = 0.01;
    end
    tau = -1*log(vcut)/band;
end

