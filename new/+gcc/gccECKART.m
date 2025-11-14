function [delay, correlation] = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)
% GCCECKART Eckart filter GCC method
%
% SYNTAX:
%   [delay, correlation] = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density
%   Gss   - Clean signal power spectrum
%   Gn1n1 - Noise variance for first signal
%   Gn2n2 - Noise variance for second signal
%   N     - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - Eckart correlation function
%
% DESCRIPTION:
%   Eckart filter is designed to maximize output SNR when both channels
%   have additive noise. Requires knowledge of signal and noise spectra.
%
%   Weighting: Psi_ECKART(f) = Gss(f) / (Gn1n1 * Gn2n2)
%   R_ECKART(tau) = IFFT(Pxy(f) * Gss(f) / (Gn1n1 * Gn2n2))
%
% REFERENCE:
%   C. Eckart, "Optimal rectifier systems for the detection of steady
%   signals", SIO Ref. 52-11, Scripps Inst. Oceanogr., Univ. Calif.,
%   La Jolla, 1952.

%% Apply Eckart weighting
weighted_spectrum = Pxy .* Gss ./ (Gn1n1 .* Gn2n2);

%% Compute correlation
correlation = fftshift(ifft(weighted_spectrum));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
