function [delay, correlation] = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)
% GCCHT Hannan-Thomson (Maximum Likelihood) GCC method
%
% SYNTAX:
%   [delay, correlation] = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)
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
%   correlation - HT correlation function
%
% DESCRIPTION:
%   Hannan-Thomson processor is the maximum likelihood estimator for
%   Gaussian signals with additive Gaussian noise. Optimal when signal
%   and noise statistics are known.
%
%   Weighting: Psi_HT(f) = Gss(f) / (Gss(f)*(Gn1n1 + Gn2n2) + Gn1n1*Gn2n2)
%   R_HT(tau) = IFFT(Pxy(f) * Psi_HT(f))
%
% REFERENCE:
%   E.J. Hannan and E.J. Thomson, "The estimation of coherence and group
%   delay", Biometrika, vol. 58, pp. 469-481, 1971.

%% Apply Hannan-Thomson weighting
denominator = Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2;
weighted_spectrum = Pxy .* Gss ./ denominator;

%% Compute correlation
correlation = fftshift(ifft(weighted_spectrum));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
