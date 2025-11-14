function [delay, correlation] = gccROTH(Pxy, Gx1x1, N)
% GCCROTH Roth processor GCC method
%
% SYNTAX:
%   [delay, correlation] = gccROTH(Pxy, Gx1x1, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density
%   Gx1x1 - Auto power spectrum of first signal
%   N     - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - Roth correlation function
%
% DESCRIPTION:
%   Roth processor normalizes by the auto-spectrum of the first signal.
%   Simple whitening approach that works well when first signal has
%   better SNR than the second.
%
%   Weighting: Psi_ROTH(f) = 1 / Gx1x1(f)
%   R_ROTH(tau) = IFFT(Pxy(f) / Gx1x1(f))
%
% REFERENCE:
%   P.R. Roth, "Effective measurements using complex correlation and
%   complex coherence", IEEE Trans. Instrumentation and Measurement,
%   vol. 20, pp. 83-92, 1971.

%% Apply Roth weighting
weighted_spectrum = Pxy ./ Gx1x1;

%% Compute correlation
correlation = fftshift(ifft(weighted_spectrum));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
