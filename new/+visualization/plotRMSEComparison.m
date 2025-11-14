function plotRMSEComparison(results, SNR_values, method_names, save_path)
% PLOTRMSECOMPARISON Create bar chart comparing RMSE across methods
%
% SYNTAX:
%   plotRMSEComparison(results, SNR_values, method_names)
%   plotRMSEComparison(results, SNR_values, method_names, save_path)
%
% INPUTS:
%   results      - Cell array of results structures (n_methods x n_SNR)
%   SNR_values   - Vector of SNR values in dB
%   method_names - Cell array of method names
%   save_path    - (Optional) Directory to save figure
%
% DESCRIPTION:
%   Creates grouped bar chart comparing RMSE of all methods at each SNR.

%% Default save path
if nargin < 4
    save_path = '';
end

%% Extract RMSE values
n_methods = length(method_names);
n_SNR = length(SNR_values);

rmse_matrix = zeros(n_methods, n_SNR);

for i = 1:n_methods
    for j = 1:n_SNR
        rmse_matrix(i, j) = results{i, j}.rmse;
    end
end

%% Create figure
fig = figure('Position', [100, 100, 1000, 600]);

%% Create bar chart
bar(SNR_values, rmse_matrix');
xlabel('SNR (dB)', 'FontWeight', 'bold', 'FontSize', 12);
ylabel('RMSE (samples)', 'FontWeight', 'bold', 'FontSize', 12);
title('RMSE Comparison of GCC Methods', 'FontWeight', 'bold', 'FontSize', 14);
legend(method_names, 'Location', 'best');
grid on;
set(gca, 'XTickLabel', arrayfun(@num2str, SNR_values, 'UniformOutput', false));

%% Save figure if requested
if ~isempty(save_path)
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    saveas(fig, fullfile(save_path, 'rmse_comparison.fig'));
    saveas(fig, fullfile(save_path, 'rmse_comparison.png'));
end

end
