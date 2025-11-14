function [best_method, best_rmse] = findBestMethod(results, method_names, iSNR)
% FINDBESTMETHOD Find method with lowest RMSE at given SNR
%
% SYNTAX:
%   [best_method, best_rmse] = findBestMethod(results, method_names, iSNR)
%
% INPUTS:
%   results      - Cell array of results structures (n_methods x n_SNR)
%   method_names - Cell array of method names
%   iSNR         - SNR index to evaluate
%
% OUTPUTS:
%   best_method - Name of best performing method
%   best_rmse   - RMSE value of best method
%
% DESCRIPTION:
%   Compares all methods and returns the one with lowest RMSE.

%% Extract RMSE values for all methods
n_methods = length(method_names);
rmse_values = zeros(n_methods, 1);

for i = 1:n_methods
    rmse_values(i) = results{i, iSNR}.rmse;
end

%% Find minimum
[best_rmse, best_idx] = min(rmse_values);
best_method = method_names{best_idx};

end
