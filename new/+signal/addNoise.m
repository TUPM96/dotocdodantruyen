function signal_noisy = addNoise(signal_clean, SNR_dB)
% ADDNOISE Add Gaussian white noise to signal at specified SNR
%
% SYNTAX:
%   signal_noisy = addNoise(signal_clean, SNR_dB)
%
% INPUTS:
%   signal_clean - Clean signal (vector)
%   SNR_dB       - Signal-to-noise ratio in dB
%
% OUTPUTS:
%   signal_noisy - Noisy signal (same size as input)
%
% DESCRIPTION:
%   Adds Gaussian white noise to the input signal to achieve the
%   specified signal-to-noise ratio (SNR) in decibels.
%
%   SNR_dB = 10 * log10(signal_power / noise_power)
%
% EXAMPLE:
%   clean_sig = randn(1000, 1);
%   noisy_sig = addNoise(clean_sig, 20);  % 20 dB SNR

%% Input validation
if nargin < 2
    error('signal:addNoise:NotEnoughInputs', ...
          'Both signal_clean and SNR_dB are required');
end

%% Calculate noise variance
signal_var = var(signal_clean);
noise_var = signal_var * 10^(-SNR_dB / 10);

%% Generate and add noise
noise = sqrt(noise_var) * randn(size(signal_clean));
signal_noisy = signal_clean + noise;

end
