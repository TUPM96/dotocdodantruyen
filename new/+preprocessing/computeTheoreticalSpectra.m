% ==============================================================================
% TEN FILE: computeTheoreticalSpectra.m
% CHUC NANG: Tinh cac pho ly thuyet cho cac phuong phap GCC
% MODULE: preprocessing
% ==============================================================================
%
function [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR_dB)
% COMPUTETHEORETICALSPECTRA Compute theoretical spectra for GCC methods
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tinh cac pho ly thuyet cho cac phuong phap GCC
%
% Giai thich chi tiet:
% - Mot so phuong phap GCC (vd: Eckart, Hannan-Thomson) can biet truoc
%   thong ke cua tin hieu va nhieu de toi uu hoa bo trong
% - Ham nay tinh cac pho ly thuyet dua tren gia dinh nhieu trang Gaussian cong
%   (additive white Gaussian noise - AWGN)
%
% Mo hinh tin hieu:
%   x(t) = s(t) + n(t)
%   Trong do:
%   - x(t): Tin hieu do duoc (quan sat)
%   - s(t): Tin hieu sach (clean signal)
%   - n(t): Nhieu trang Gaussian
%
% Pho cua tin hieu do:
%   Gxx(f) = Gss(f) + Gnn(f)
%   (Pho tin hieu do = Pho tin hieu sach + Pho nhieu)
%
% SYNTAX:
%   [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR_dB)
%
% INPUTS:
%   PSD    - Theoretical PSD of clean signal (PSD ly thuyet cua tin hieu sach)
%   s1     - First noisy signal (Tin hieu co nhieu thu nhat)
%   s2     - Second noisy signal (Tin hieu co nhieu thu hai)
%   SNR_dB - Signal-to-noise ratio in dB (Ti so SNR)
%
% OUTPUTS:
%   Gx1x1  - Theoretical auto-spectrum of signal 1 (Pho tu dong ly thuyet: tin hieu + nhieu)
%   Gx2x2  - Theoretical auto-spectrum of signal 2 (Pho tu dong ly thuyet: tin hieu + nhieu)
%   Gss    - Theoretical spectrum of clean signal (Pho tin hieu sach ly thuyet)
%   Gn1n1  - Noise variance for signal 1 (Phuong sai nhieu kenh 1)
%   Gn2n2  - Noise variance for signal 2 (Phuong sai nhieu kenh 2)
%
% DESCRIPTION:
%   Used by GCC methods that require noise statistics (e.g., Eckart, HT).

%% BUOC 1: Tinh phuong sai nhieu cho moi kenh
% Giai thich:
% - Tu SNR_dB, tinh nguoc lai phuong sai nhieu
% - Gia dinh nhieu la trang (pho phang) nen phuong sai = cong suat
% - Cong thuc: noise_var = signal_var / 10^(SNR_dB/10)

Gn1n1 = var(s1) * 10^(-SNR_dB / 10);  % Phuong sai nhieu kenh 1
Gn2n2 = var(s2) * 10^(-SNR_dB / 10);  % Phuong sai nhieu kenh 2

%% BUOC 2: Tinh pho tu dong cua tin hieu co nhieu
% Giai thich:
% - Pho tin hieu do = Pho tin hieu sach + Pho nhieu
% - Ty le PSD theo phuong sai tin hieu thuc te
% - Chia cho mean(PSD) de chuan hoa, sau do nhan voi var(s) de ty le dung

% Pho tu dong tin hieu 1 (signal + noise)
Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
Gx1x1 = Gx1x1';  % Chuyen sang vector cot

% Pho tu dong tin hieu 2 (signal + noise)
Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
Gx2x2 = Gx2x2';  % Chuyen sang vector cot

%% BUOC 3: Pho tin hieu sach
% Giai thich: Su dung PSD ly thuyet (Farina-Merletti) lam pho tin hieu sach
Gss = PSD';  % Chuyen sang vector cot

end
