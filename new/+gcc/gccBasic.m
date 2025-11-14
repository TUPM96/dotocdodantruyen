function [delay, correlation] = gccBasic(Pxy, N)
% GCCBASIC Basic GCC method (frequency domain cross-correlation)
%
% SYNTAX:
%   [delay, correlation] = gccBasic(Pxy, N)
%
% INPUTS:
%   Pxy - Cross power spectral density
%   N   - Signal length
%
% OUTPUTS:
%   delay       - Estimated delay in samples
%   correlation - GCC function
%
% DESCRIPTION:
%   Basic GCC method using unweighted cross-spectrum.
%   Equivalent to time-domain cross-correlation but computed in frequency domain.
%
%   R_GCC(tau) = IFFT(Pxy(f))
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% Compute GCC function (inverse FFT of cross-spectrum)
correlation = fftshift(ifft(Pxy));

%% Estimate delay with parabolic interpolation
delay = gcc.estimateDelay(correlation, N, true);

end
