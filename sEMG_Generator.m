%% ================== sEMG_Generator.m ==================
function [Vec_Signal, T, b] = sEMG_Generator(Signal_Type, N, p, D, Fe)
% Sinh tin hieu sEMG mo phong voi tre D giua cac kenh
% Dau vao:
%   - Signal_Type : kieu tin hieu ('simu_semg')
%   - N           : so diem mau
%   - p           : he so tuong quan (khong dung o day nhung giu cho dong nhat)
%   - D           : do tre (mau)
%   - Fe          : tan so lay mau
% Dau ra:
%   - Vec_Signal  : ma tran [N x 2] gom 2 kenh tin hieu sEMG
%   - T           : vector thoi gian
%   - b           : bo loc pho cong suat dung de tao tin hieu

    % ---- Xu ly do tre ----
    if numel(D) == 1
        Delay = ones(1, N) * D;
    else
        Delay = D;
    end

    M = 2;                 % So kenh (2 kenh: s1, s2)
    Vec_Signal = zeros(N, M);
    b = [];

    switch lower(Signal_Type)
        case 'simu_semg'
            % ---- Pho cong suat Farina–Merletti ----
            fh = 120; fl = 60; k = 1;
            Fs = Fe;
            f = linspace(0, Fs, N);
            PSD = k * fh^4 .* f.^2 ./ ((f.^2 + fl^2) .* (f.^2 + fh^2).^2);
            PSD = [PSD(1:N/2+1), fliplr(PSD(2:N/2))];
            PSD = PSD ./ max(PSD);

            % ---- Tao tin hieu sEMG (bang loc trong mien tan so) ----
            Signal = randn(1, N);                        % tin hieu trang
            b = fftshift(real(ifft(sqrt(PSD))));         % bo loc pho cong suat
            Ncoef = round(Fs / 4096 * 100);              % so he so loc (thich nghi)
            b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);        % cat phan giua pho
            Signal = filter(b, 1, Signal);               % loc tin hieu
            Signal = Signal / max(abs(Signal));          % chuan hoa

        otherwise
            error('Signal_Type khong hop le!');
    end

    % ---- Vector thoi gian ----
    T = (0:N-1)' / Fe;

    % ---- Tao kenh tre ----
    Vec_Signal(:, 1) = Signal(1:N)';                     % Kenh 1 goc
    shift = round(mean(Delay));                          % Do tre trung binh
    Vec_Signal(:, 2) = [zeros(shift,1); ...
                        Signal(1:end-shift)'] + ...
                        0.001 * randn(N,1);              % Kenh 2 co tre + nhieu nhe
end
