% ==============================================================================
% TEN FILE: generateSEMG.m
% CHUC NANG: Tao tin hieu sEMG gia lap voi cac kenh co do tre khac nhau
% MODULE: signal
% ==============================================================================
%
% Mo ta: Tao tin hieu sEMG (surface Electromyography) gia lap
%        voi cac kenh co do tre thoi gian khac nhau
%
function [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, Signal_Name)

% Kiem tra tham so dau vao
if nargin < 5
    error('signal:generateSEMG:NotEnoughInputs', ...
          'Can it nhat 5 tham so dau vao');
end

% Tao vector do tre
if size(D) == size(1)
    Delay = ones(1, N) * D;
else
    Delay = D;
end

% Tinh do dai tin hieu mo rong
n = 1:N;
DeltaStart = max([0 (p - n - floor(Delay))]);
DeltaStop = max([0 (n + floor(Delay) + p - N)]);

if DeltaStart < 0
    DeltaStart = 0;
end

if DeltaStop < 0
    DeltaStop = 0;
end

Np = N + 3 * (DeltaStart + DeltaStop);

% Khoi tao cac bien dau ra
b = [];
M = 4;
Vec_Signal = zeros(N, M);

% Tao tin hieu goc theo loai duoc chon
switch lower(Signal_Type)
    case 'gwn'
        Signal = randn(1, Np);
        
    case 'simu_semg'
        fh = 120;
        fl = 60;
        k = 1;
        Fs = Fe;
        
        f = linspace(0, Fs, N);
        
        PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);
        PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
        PSD = PSD ./ max(PSD);
        
        Signal = randn(1, Np);
        
        b = fftshift(real(ifft(sqrt(PSD))));
        Ncoef = round(Fs / 4096 * 100);
        b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);
        
        Signal = filtfilt(b, 1, Signal);
        
    case 'real_semg'
        if nargin < 6 || isempty(Signal_Name)
            error('signal:generateSEMG:MissingSignalName', ...
                  'Signal_Name can thiet cho real_semg option');
        end
        
        load(Signal_Name, 'sEMG');
        Signal = sEMG(1:round(4096/Fe):Np*round(4096/Fe));
        
    otherwise
        error('signal:generateSEMG:InvalidSignalType', ...
              'Signal_Type phai la: gwn, simu_semg, hoac real_semg');
end

% Tao vector thoi gian
T = linspace(0, N, N) ./ Fe;

% Tao cac tin hieu co do tre
Vec_Signal(:, 1) = Signal(1:N);
Vec_Signal(:, 2) = utils.Delay_Modeling_Var(Signal, 1, p, Delay, N);
Vec_Signal(:, 3) = utils.Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);
Vec_Signal(:, 4) = utils.Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);

end

