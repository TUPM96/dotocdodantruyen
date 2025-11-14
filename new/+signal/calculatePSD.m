function PSD = calculatePSD(N, Fs)
% CALCULATEPSD Calculate Farina-Merletti PSD model for sEMG signals
%
% SYNTAX:
%   PSD = calculatePSD(N, Fs)
%
% INPUTS:
%   N   - Number of samples
%   Fs  - Sampling frequency in Hz
%
% OUTPUTS:
%   PSD - Power spectral density (normalized, length N)
%
% DESCRIPTION:
%   Implements the Farina-Merletti model for sEMG power spectral density.
%   This model is widely used in sEMG simulation for muscle fiber conduction
%   velocity estimation.
%
%   PSD(f) = k * fh^4 * f^2 / ((f^2 + fl^2) * (f^2 + fh^2)^2)
%
% REFERENCE:
%   D. Farina and R. Merletti, "Comparison of algorithms for estimation of
%   EMG variables during voluntary contractions", Journal of
%   Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.

%% Parameters
fh = 120;       % High frequency parameter (Hz)
fl = 60;        % Low frequency parameter (Hz)
k = 1;          % Scaling factor

%% Frequency axis
f = linspace(0, Fs, N);

%% Farina-Merletti PSD model
PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);

%% Create symmetric spectrum for real-valued signal
% Keep positive frequencies + DC, then mirror for negative frequencies
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

%% Normalize to unit maximum
PSD = PSD ./ max(PSD);

end
