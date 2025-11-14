function [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR_dB)
% COMPUTETHEORETICALSPECTRA Compute theoretical spectra for GCC methods
%
% SYNTAX:
%   [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR_dB)
%
% INPUTS:
%   PSD    - Theoretical power spectral density of clean signal
%   s1     - First noisy signal (vector)
%   s2     - Second noisy signal (vector)
%   SNR_dB - Signal-to-noise ratio in dB
%
% OUTPUTS:
%   Gx1x1  - Theoretical auto-spectrum of signal 1 (signal + noise)
%   Gx2x2  - Theoretical auto-spectrum of signal 2 (signal + noise)
%   Gss    - Theoretical spectrum of clean signal
%   Gn1n1  - Noise variance for signal 1
%   Gn2n2  - Noise variance for signal 2
%
% DESCRIPTION:
%   Computes theoretical spectra assuming additive white Gaussian noise.
%   Used by GCC methods that require noise statistics (e.g., Eckart, HT).

%% Calculate noise variances
Gn1n1 = var(s1) * 10^(-SNR_dB / 10);
Gn2n2 = var(s2) * 10^(-SNR_dB / 10);

%% Compute signal auto-spectra (signal + noise)
Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
Gx1x1 = Gx1x1';  % Column vector

Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
Gx2x2 = Gx2x2';  % Column vector

%% Clean signal spectrum
Gss = PSD';  % Column vector

end
