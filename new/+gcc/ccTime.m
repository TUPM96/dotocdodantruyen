function [delay, correlation] = ccTime(s1, s2, N)
% CCTIME Time-domain cross-correlation method
%
% SYNTAX:
%   [delay, correlation] = ccTime(s1, s2, N)
%
% INPUTS:
%   s1 - First signal (vector)
%   s2 - Second signal (vector)
%   N  - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - Cross-correlation function
%
% DESCRIPTION:
%   Basic time-domain cross-correlation method for delay estimation.
%   Computes xcorr(s1, s2) and finds the peak.
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% Compute cross-correlation
[Rx1x2, ~] = xcorr(s1, s2, length(s1)/2);
Rx1x2 = Rx1x2(1:end-1);

%% Store correlation
correlation = Rx1x2;

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
