function [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)
% GCCSCOT Smoothed Coherence Transform (SCOT) GCC method
%
% SYNTAX:
%   [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density
%   Gx1x1 - Auto power spectrum of first signal
%   Gx2x2 - Auto power spectrum of second signal
%   N     - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - SCOT correlation function
%
% DESCRIPTION:
%   SCOT normalizes by the geometric mean of both auto-spectra.
%   Effectively computes smoothed cross-coherence.
%
%   Weighting: Psi_SCOT(f) = 1 / sqrt(Gx1x1(f) * Gx2x2(f))
%   R_SCOT(tau) = IFFT(Pxy(f) / sqrt(Gx1x1(f) * Gx2x2(f)))
%
% REFERENCE:
%   G.C. Carter et al., "Coherence and time delay estimation",
%   Proc. IEEE, vol. 75, pp. 236-255, Feb. 1987.

%% Apply SCOT weighting
weighted_spectrum = Pxy ./ sqrt(Gx1x1 .* Gx2x2);

%% Compute correlation
correlation = fftshift(ifft(weighted_spectrum));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
