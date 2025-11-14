function cfg = config()
% CONFIG Configuration parameters for GCC simulation
%
% SYNTAX:
%   cfg = config()
%
% OUTPUTS:
%   cfg - Configuration structure containing all simulation parameters
%
% DESCRIPTION:
%   Centralized configuration for muscle fiber conduction velocity
%   estimation using GCC methods.

%% Monte Carlo simulation parameters
cfg.Nm = 100;                    % Number of Monte Carlo iterations
cfg.SNR = [0 10 20];            % SNR levels in dB

%% Signal parameters
cfg.Duration = 0.125;            % Signal duration in seconds
cfg.Fs = 2048;                   % Sampling frequency in Hz
cfg.N = cfg.Duration * cfg.Fs;   % Number of samples
cfg.p = 40;                      % Filter order for delay modeling

%% Frequency analysis parameters
cfg.nfft = 2048;                 % FFT length
cfg.Bandwidth = [15 200];        % Bandwidth for analysis (Hz)
cfg.h_Length = 128;              % Window length for CPSD

%% Muscle fiber parameters
cfg.CV_Scale = [2 6];            % Min and Max conduction velocity (m/s)
cfg.DeltaE = 5e-3;               % Inter-electrode distance (m)

%% Calculate expected delay
% For constant CV at midpoint of range
cfg.CV_expected = mean(cfg.CV_Scale);  % Expected conduction velocity (m/s)
cfg.delay_expected = cfg.DeltaE * cfg.Fs / cfg.CV_expected;  % Expected delay (samples)

%% GCC methods to evaluate
cfg.methods = {
    'CC_time'   % Time-domain cross-correlation
    'GCC'       % Basic GCC (frequency domain)
    'PHAT'      % Phase Transform
    'ROTH'      % Roth processor
    'SCOT'      % Smoothed Coherence Transform
    'ECKART'    % Eckart filter
    'HT'        % Hannan-Thomson (Maximum Likelihood)
};

%% Output settings
cfg.save_results = true;         % Save results to file
cfg.results_dir = 'results';     % Results directory
cfg.show_plots = true;           % Display plots
cfg.verbose = true;              % Print progress messages

end
