% ==============================================================================
% TEN FILE: addNoise.m
% CHUC NANG: Them nhieu trang Gaussian vao tin hieu theo SNR mong muon
% MODULE: signal
% ==============================================================================
%
function signal_noisy = addNoise(signal_clean, SNR_dB)
% ADDNOISE Add Gaussian white noise to signal at specified SNR
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Them nhieu trang Gaussian vao tin hieu sach de dat ti so
%            tin hieu tren nhieu (SNR) mong muon
%
% Giai thich chi tiet:
% - SNR (Signal-to-Noise Ratio): Ti so giua cong suat tin hieu va cong suat nhieu
% - Don vi: decibel (dB)
% - SNR cao: Tin hieu manh hon nhieu -> Chat luong tot
% - SNR thap: Nhieu manh gan bang tin hieu -> Chat luong kem
%
% Cong thuc:
%   SNR_dB = 10 * log10(P_signal / P_noise)
%   Trong do:
%   - P_signal: Cong suat tin hieu (tinh bang phuong sai)
%   - P_noise: Cong suat nhieu (tinh bang phuong sai)
%
% Ung dung: Mo phong moi truong do luong thuc te co nhieu
%
% SYNTAX:
%   signal_noisy = addNoise(signal_clean, SNR_dB)
%
% INPUTS:
%   signal_clean - Clean signal (Tin hieu sach, chua co nhieu)
%   SNR_dB       - Signal-to-noise ratio in dB (Ti so SNR mong muon)
%
% OUTPUTS:
%   signal_noisy - Noisy signal (Tin hieu da them nhieu, cung kich thuoc voi tin hieu dau vao)
%
% EXAMPLE:
%   clean_sig = randn(1000, 1);
%   noisy_sig = addNoise(clean_sig, 20);  % SNR = 20 dB

%% BUOC 1: Kiem tra tham so dau vao
% Dam bao ca hai tham so deu duoc cung cap
if nargin < 2
    error('signal:addNoise:NotEnoughInputs', ...
          'Both signal_clean and SNR_dB are required');
end

%% BUOC 2: Tinh phuong sai nhieu can thiet
% Giai thich:
% - Tinh phuong sai tin hieu sach (signal power)
% - Tu SNR_dB, suy ra phuong sai nhieu can them
% - Cong thuc nguoc: noise_var = signal_var / 10^(SNR_dB/10)

signal_var = var(signal_clean);              % Phuong sai tin hieu
noise_var = signal_var * 10^(-SNR_dB / 10);  % Phuong sai nhieu

%% BUOC 3: Tao va them nhieu vao tin hieu
% Giai thich:
% - Tao nhieu Gaussian voi do lech chuan = sqrt(noise_var)
% - Kich thuoc nhieu giong kich thuoc tin hieu
% - Cong nhieu vao tin hieu sach de co tin hieu nhieu

noise = sqrt(noise_var) * randn(size(signal_clean));  % Tao nhieu Gaussian
signal_noisy = signal_clean + noise;                  % Them nhieu vao tin hieu

end
