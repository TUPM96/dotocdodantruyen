% ==============================================================================
% TEN FILE: computeSpectra.m
% CHUC NANG: Tinh mat do pho tu dong va cheo su dung phuong phap Welch
% MODULE: preprocessing
% ==============================================================================
%
% Mo ta: Tinh mat do pho cong suat tu dong (auto-PSD) va cheo (cross-PSD) cua hai tin hieu
%        Su dung phuong phap Welch: Chia tin hieu thanh cac doan chong chap,
%        tinh PSD cua tung doan, roi lay trung binh de giam nhieu
%
% Thuat toan Welch:
% 1. Chia tin hieu thanh cac doan co chong chap
% 2. Nhan moi doan voi ham cua so (window) de giam ro ri pho
% 3. Tinh FFT cua moi doan
% 4. Tinh cong suat va lay trung binh tren tat ca cac doan
%
% Ung dung: Tinh toan pho cho cac phuong phap GCC (Generalized Cross-Correlation)
%
function [Pxx, Pyy, Pxy] = computeSpectra(s1, s2, win, n_overlap, nfft, Fs)

% Tinh auto-PSD cua tin hieu 1
% Tinh pho cong suat cua s1 voi chinh no
% Su dung 'twosided' de co pho hai phia (tan so am va duong)
[Pxx] = cpsd(s1, s1, win, n_overlap, nfft, Fs, 'twosided');

% Tinh auto-PSD cua tin hieu 2
% Tinh pho cong suat cua s2 voi chinh no
[Pyy] = cpsd(s2, s2, win, n_overlap, nfft, Fs, 'twosided');

% Tinh cross-PSD giua hai tin hieu
% Tinh pho tuong quan cheo giua s1 va s2
% Cross-PSD chua thong tin ve do tre va tuong quan giua hai tin hieu
[Pxy] = cpsd(s1, s2, win, n_overlap, nfft, Fs, 'twosided');

end

