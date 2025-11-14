function delay = estimateDelay(correlation, N, use_interpolation)
% ESTIMATEDELAY Estimate time delay from correlation function
%
% SYNTAX:
%   delay = estimateDelay(correlation, N)
%   delay = estimateDelay(correlation, N, use_interpolation)
%
% INPUTS:
%   correlation        - Correlation function (vector)
%   N                  - Signal length
%   use_interpolation  - (Optional) true to use parabolic interpolation, default: true
%
% OUTPUTS:
%   delay - Estimated delay in samples
%
% DESCRIPTION:
%   Finds the peak of the correlation function and estimates the delay.
%   Optionally uses parabolic interpolation for sub-sample accuracy.

%% Default parameters
if nargin < 3
    use_interpolation = true;
end

%% Find peak
[~, peak_idx] = max(correlation);

%% Calculate basic delay estimate
delay_basic = abs(N/2 - peak_idx + 1);

%% Apply parabolic interpolation if requested
if use_interpolation && peak_idx > 1 && peak_idx < length(correlation)
    % Parabolic interpolation using 3 points around peak
    y1 = correlation(peak_idx - 1);
    y2 = correlation(peak_idx);
    y3 = correlation(peak_idx + 1);

    % Interpolation formula
    delta = 0.5 * (y3 - y1) / (y3 - 2*y2 + y1);
    delay = delay_basic - delta;
else
    delay = delay_basic;
end

end
