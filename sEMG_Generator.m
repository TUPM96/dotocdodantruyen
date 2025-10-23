%% ================== sEMG_Generator.m ==================
function [Vec_Signal, T, b] = sEMG_Generator(Signal_Type, N, p, D, Fe)
% Sinh tín hiệu sEMG mô phỏng với trễ D giữa các kênh

if numel(D) == 1
    Delay = ones(1, N) * D;
else
    Delay = D;
end

M = 2;                 % Số kênh (2 kênh: s1, s2)
Vec_Signal = zeros(N, M);
b = [];

switch lower(Signal_Type)
    case 'simu_semg'
        fh = 120; fl = 60; k = 1;
        Fs = Fe;
        f = linspace(0, Fs, N);
        PSD = k * fh^4 .* f.^2 ./ ((f.^2 + fl^2) .* (f.^2 + fh^2).^2);
        PSD = [PSD(1:N/2+1), fliplr(PSD(2:N/2))];
        PSD = PSD ./ max(PSD);

        Signal = randn(1, N);
        b = fftshift(real(ifft(sqrt(PSD))));
        Ncoef = round(Fs / 4096 * 100);
        b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);
        Signal = filter(b, 1, Signal);
        Signal = Signal / max(abs(Signal));
    otherwise
        error('Signal_Type không hợp lệ!');
end

T = (0:N-1)' / Fe;

% Tạo kênh trễ
Vec_Signal(:, 1) = Signal(1:N)';
shift = round(mean(Delay));
Vec_Signal(:, 2) = [zeros(shift,1); Signal(1:end-shift)'] + 0.001*randn(N,1);
end
