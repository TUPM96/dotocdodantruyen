function plotResults(results, SNR_values, method_names, save_path)
% PLOTRESULTS Create comprehensive results plots
%
% SYNTAX:
%   plotResults(results, SNR_values, method_names)
%   plotResults(results, SNR_values, method_names, save_path)
%
% INPUTS:
%   results      - Cell array of results structures (n_methods x n_SNR)
%   SNR_values   - Vector of SNR values in dB
%   method_names - Cell array of method names
%   save_path    - (Optional) Directory to save figures
%
% DESCRIPTION:
%   Creates 4 subplots showing RMSE, Bias, Variance, and Std vs SNR
%   for all methods.

%% Default save path
if nargin < 4
    save_path = '';
end

%% Extract metrics
n_methods = length(method_names);
n_SNR = length(SNR_values);

rmse_matrix = zeros(n_methods, n_SNR);
bias_matrix = zeros(n_methods, n_SNR);
var_matrix = zeros(n_methods, n_SNR);
std_matrix = zeros(n_methods, n_SNR);

for i = 1:n_methods
    for j = 1:n_SNR
        stats = results{i, j};
        rmse_matrix(i, j) = stats.rmse;
        bias_matrix(i, j) = stats.bias;
        var_matrix(i, j) = stats.variance;
        std_matrix(i, j) = stats.std;
    end
end

%% Create figure
fig = figure('Position', [100, 100, 1200, 800]);

%% Subplot 1: RMSE
subplot(2, 2, 1);
hold on;
for i = 1:n_methods
    plot(SNR_values, rmse_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('RMSE (samples)', 'FontWeight', 'bold');
title('Root Mean Square Error vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

%% Subplot 2: Bias
subplot(2, 2, 2);
hold on;
for i = 1:n_methods
    plot(SNR_values, bias_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Bias (samples)', 'FontWeight', 'bold');
title('Bias vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

%% Subplot 3: Variance
subplot(2, 2, 3);
hold on;
for i = 1:n_methods
    plot(SNR_values, var_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Variance (samples^2)', 'FontWeight', 'bold');
title('Variance vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

%% Subplot 4: Standard Deviation
subplot(2, 2, 4);
hold on;
for i = 1:n_methods
    plot(SNR_values, std_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Std (samples)', 'FontWeight', 'bold');
title('Standard Deviation vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

%% Save figure if requested
if ~isempty(save_path)
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    saveas(fig, fullfile(save_path, 'gcc_comparison.fig'));
    saveas(fig, fullfile(save_path, 'gcc_comparison.png'));
end

end
