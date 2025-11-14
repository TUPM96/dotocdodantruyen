function [delay, correlation] = gccPHAT(Pxy, Gss, N)
% GCCPHAT Phase Transform (PHAT) GCC method
%
% SYNTAX:
%   [delay, correlation] = gccPHAT(Pxy, Gss, N)
%
% INPUTS:
%   Pxy - Cross power spectral density
%   Gss - Clean signal power spectrum
%   N   - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - PHAT correlation function
%
% DESCRIPTION:
%   PHAT (PHase Transform) whitens the cross-spectrum, emphasizing phase
%   information over magnitude. Performs well in reverberant environments.
%
%   Weighting: Psi_PHAT(f) = 1 / |Gss(f) + epsilon|
%   R_PHAT(tau) = IFFT(Pxy(f) / |Gss(f) + epsilon|)
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% Apply PHAT weighting
% Add small constant to avoid division by zero
epsilon = 0.1;
weighted_spectrum = Pxy ./ (Gss + epsilon);

%% Compute correlation
correlation = fftshift(ifft(weighted_spectrum));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
