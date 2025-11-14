function printResultsTable(results, SNR_values, method_names)
% PRINTRESULTSTABLE Print formatted results table
%
% SYNTAX:
%   printResultsTable(results, SNR_values, method_names)
%
% INPUTS:
%   results      - Cell array of results structures (n_methods x n_SNR)
%   SNR_values   - Vector of SNR values in dB
%   method_names - Cell array of method names
%
% DESCRIPTION:
%   Prints a formatted table showing RMSE, Bias, and Std for each method
%   at each SNR level.

fprintf('\n');
fprintf('========================================================================\n');
fprintf('                    DELAY ESTIMATION RESULTS\n');
fprintf('========================================================================\n\n');

%% Print results for each SNR
for iSNR = 1:length(SNR_values)
    fprintf('SNR = %d dB\n', SNR_values(iSNR));
    fprintf('------------------------------------------------------------------------\n');
    fprintf('%-15s %12s %12s %12s %12s\n', 'Method', 'Mean', 'Bias', 'Std', 'RMSE');
    fprintf('------------------------------------------------------------------------\n');

    for iMethod = 1:length(method_names)
        stats = results{iMethod, iSNR};
        fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', ...
                method_names{iMethod}, ...
                stats.mean, ...
                stats.bias, ...
                stats.std, ...
                stats.rmse);
    end

    fprintf('\n');
end

fprintf('========================================================================\n\n');

end
