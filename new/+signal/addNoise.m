% ==============================================================================
% TEN FILE: addNoise.m
% CHUC NANG: Them nhieu trang Gaussian vao tin hieu theo SNR mong muon
% MODULE: signal
% ==============================================================================
%
% Mo ta: Them nhieu trang Gaussian vao tin hieu sach de dat ti so
%        tin hieu tren nhieu (SNR) mong muon
%
% SNR (Signal-to-Noise Ratio): Ti so giua cong suat tin hieu va cong suat nhieu
% Don vi: decibel (dB)
% SNR cao: Tin hieu manh hon nhieu -> Chat luong tot
% SNR thap: Nhieu manh gan bang tin hieu -> Chat luong kem
%
% Cong thuc: SNR_dB = 10 * log10(P_signal / P_noise)
%
% Ung dung: Mo phong moi truong do luong thuc te co nhieu
%
function signal_noisy = addNoise(signal_clean, SNR_dB)

% Kiem tra tham so dau vao
% Dam bao ca hai tham so deu duoc cung cap
if nargin < 2
    error('signal:addNoise:NotEnoughInputs', ...
          'Both signal_clean and SNR_dB are required');
end

% Tinh phuong sai nhieu can thiet
% Tinh phuong sai tin hieu sach (signal power)
% Tu SNR_dB, suy ra phuong sai nhieu can them
% Cong thuc nguoc: noise_var = signal_var / 10^(SNR_dB/10)
signal_var = var(signal_clean);
noise_var = signal_var * 10^(-SNR_dB / 10);

% Tao va them nhieu vao tin hieu
% Tao nhieu Gaussian voi do lech chuan = sqrt(noise_var)
% Kich thuoc nhieu giong kich thuoc tin hieu
% Cong nhieu vao tin hieu sach de co tin hieu nhieu
noise = sqrt(noise_var) * randn(size(signal_clean));
signal_noisy = signal_clean + noise;

end
