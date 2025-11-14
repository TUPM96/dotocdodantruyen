function [Pxx, Pyy, Pxy] = computeSpectra(s1, s2, win, n_overlap, nfft, Fs)
% COMPUTESPECTRA Compute auto and cross power spectral densities
%
% SYNTAX:
%   [Pxx, Pyy, Pxy] = computeSpectra(s1, s2, win, n_overlap, nfft, Fs)
%
% INPUTS:
%   s1         - First signal (vector)
%   s2         - Second signal (vector)
%   win        - Window function (e.g., hanning(128))
%   n_overlap  - Number of overlapping samples
%   nfft       - FFT length
%   Fs         - Sampling frequency in Hz
%
% OUTPUTS:
%   Pxx - Auto power spectral density of s1
%   Pyy - Auto power spectral density of s2
%   Pxy - Cross power spectral density between s1 and s2
%
% DESCRIPTION:
%   Computes power spectral densities using Welch's method.
%   All PSDs are two-sided spectra.
%
% See also: cpsd

%% Compute auto-PSD of signal 1
[Pxx] = cpsd(s1, s1, win, n_overlap, nfft, Fs, 'twosided');

%% Compute auto-PSD of signal 2
[Pyy] = cpsd(s2, s2, win, n_overlap, nfft, Fs, 'twosided');

%% Compute cross-PSD between signals 1 and 2
[Pxy] = cpsd(s1, s2, win, n_overlap, nfft, Fs, 'twosided');

end
