function stats = calculateStats(delays, expected_delay)
% CALCULATESTATS Calculate statistical performance metrics
%
% SYNTAX:
%   stats = calculateStats(delays, expected_delay)
%
% INPUTS:
%   delays         - Vector of estimated delays (Nm x 1)
%   expected_delay - True delay value
%
% OUTPUTS:
%   stats - Structure containing:
%           .mean     - Mean of estimates
%           .bias     - Bias (mean - expected)
%           .variance - Variance
%           .std      - Standard deviation
%           .rmse     - Root mean square error
%           .mse      - Mean square error
%
% DESCRIPTION:
%   Computes standard statistical metrics for evaluating delay estimation
%   performance in Monte Carlo simulations.

%% Calculate mean
stats.mean = mean(delays);

%% Calculate bias
stats.bias = stats.mean - expected_delay;

%% Calculate variance
stats.variance = var(delays);

%% Calculate standard deviation
stats.std = sqrt(stats.variance);

%% Calculate MSE (Mean Square Error)
% MSE = bias^2 + variance
stats.mse = stats.bias^2 + stats.variance;

%% Calculate RMSE (Root Mean Square Error)
stats.rmse = sqrt(stats.mse);

end
