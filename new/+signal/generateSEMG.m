function [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, varargin)
% GENERATESEMG Generate synthetic sEMG signals with specified delay
%
% SYNTAX:
%   [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe)
%   [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, Signal_Name)
%
% INPUTS:
%   Signal_Type  - Type of signal to generate: 'gwn', 'simu_semg', 'real_semg'
%   N            - Number of samples in the signal
%   p            - Filter order for delay modeling
%   D            - Delay in samples (scalar or vector)
%   Fe           - Sampling frequency in Hz
%   Signal_Name  - (Optional) Name of signal file for 'real_semg' option
%
% OUTPUTS:
%   Vec_Signal   - N x 4 matrix of delayed signals
%   T            - Time vector in seconds
%   b            - Filter coefficients (only for 'simu_semg')
%
% DESCRIPTION:
%   Generates 4-channel sEMG signals with delays D, 2*D, 3*D from the reference.
%   Uses Farina-Merletti PSD model for 'simu_semg' option.
%
% REFERENCE:
%   D. Farina and R. Merletti, "Comparison of algorithms for estimation of
%   EMG variables during voluntary contractions", Journal of
%   Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.
%
% See also: Delay_Modeling_Var

%% Input validation
if nargin < 5
    error('signal:generateSEMG:NotEnoughInputs', ...
          'At least 5 input arguments required');
end

Signal_Name = [];
if nargin > 5
    Signal_Name = varargin{1};
end

%% Create delay vector
if isscalar(D)
    Delay = ones(1, N) * D;  % Constant delay
else
    Delay = D;                % Variable delay
end

%% Calculate extended signal length to avoid edge effects
n = 1:N;
DeltaStart = max([0 (p - n - floor(Delay))]);
DeltaStop  = max([0 (n + floor(Delay) + p - N)]);

if DeltaStart < 0
    DeltaStart = 0;
end

if DeltaStop < 0
    DeltaStop = 0;
end

Np = N + 3 * (DeltaStart + DeltaStop);

%% Initialize outputs
b = [];                      % Filter coefficients (only for simu_semg)
M = 4;                       % Number of delayed signals
Vec_Signal = zeros(N, M);    % Output matrix

%% Generate original signal
switch lower(Signal_Type)
    case 'gwn'
        % Gaussian White Noise
        Signal = randn(1, Np);

    case 'simu_semg'
        % Simulated sEMG using Farina-Merletti PSD model
        fh = 120;       % High frequency parameter (Hz)
        fl = 60;        % Low frequency parameter (Hz)
        k = 1;          % Scaling factor
        Fs = Fe;

        % Frequency axis
        f = linspace(0, Fs, N);

        % Farina-Merletti PSD model
        PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);

        % Create symmetric spectrum
        PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

        % Normalize
        PSD = PSD ./ max(PSD);

        % Generate white noise
        Signal = randn(1, Np);

        % Design filter from PSD
        b = fftshift(real(ifft(sqrt(PSD))));
        Ncoef = round(Fs / 4096 * 100);  % Filter length depends on Fs
        b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);

        % Filter the white noise
        Signal = filtfilt(b, 1, Signal);

    case 'real_semg'
        % Load real sEMG signal
        if isempty(Signal_Name)
            error('signal:generateSEMG:MissingSignalName', ...
                  'Signal_Name required for real_semg option');
        end
        load(Signal_Name, 'sEMG');
        Signal = sEMG(1:round(4096/Fe):Np*round(4096/Fe));

    otherwise
        error('signal:generateSEMG:InvalidSignalType', ...
              'Signal_Type must be: gwn, simu_semg, or real_semg');
end

%% Create time vector
T = linspace(0, N, N) ./ Fe;

%% Generate delayed signals
Vec_Signal(:, 1) = Signal(1:N);                                % Channel 1 (reference)
Vec_Signal(:, 2) = Delay_Modeling_Var(Signal, 1, p, Delay, N);    % Channel 2 (delay = D)
Vec_Signal(:, 3) = Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);  % Channel 3 (delay = 2*D)
Vec_Signal(:, 4) = Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);  % Channel 4 (delay = 3*D)

end
