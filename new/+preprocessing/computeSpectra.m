function [Pxx, Pyy, Pxy] = computeSpectra(s1, s2, win, n_overlap, nfft, Fs)
% COMPUTESPECTRA Compute auto and cross power spectral densities
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tinh mat do pho cong suat tu dong (auto-PSD) va cheo (cross-PSD)
%            cua hai tin hieu
%
% Giai thich chi tiet:
% - Auto-PSD (Pxx, Pyy): Do luong phan bo nang luong cua mot tin hieu theo tan so
% - Cross-PSD (Pxy): Do luong tuong quan giua hai tin hieu trong mien tan so
% - Su dung phuong phap Welch: Chia tin hieu thanh cac doan chong chap,
%   tinh PSD cua tung doan, roi lay trung binh de giam nhieu
%
% Thuat toan Welch:
%   1. Chia tin hieu thanh cac doan co chong chap
%   2. Nhan moi doan voi ham cua so (window) de giam ro ri pho
%   3. Tinh FFT cua moi doan
%   4. Tinh cong suat va lay trung binh tren tat ca cac doan
%
% Ung dung: Tinh toan pho cho cac phuong phap GCC (Generalized Cross-Correlation)
%
% SYNTAX:
%   [Pxx, Pyy, Pxy] = computeSpectra(s1, s2, win, n_overlap, nfft, Fs)
%
% INPUTS:
%   s1         - First signal (Tin hieu thu nhat - vector)
%   s2         - Second signal (Tin hieu thu hai - vector)
%   win        - Window function (Ham cua so, vd: hanning(128))
%   n_overlap  - Number of overlapping samples (So mau chong chap giua cac doan)
%   nfft       - FFT length (Do dai FFT)
%   Fs         - Sampling frequency in Hz (Tan so lay mau)
%
% OUTPUTS:
%   Pxx - Auto power spectral density of s1 (Mat do pho cong suat tu dong cua s1)
%   Pyy - Auto power spectral density of s2 (Mat do pho cong suat tu dong cua s2)
%   Pxy - Cross power spectral density (Mat do pho cong suat cheo giua s1 va s2)
%
% DESCRIPTION:
%   Computes power spectral densities using Welch's method.
%   All PSDs are two-sided spectra (Tat ca PSD deu la pho hai phia).
%
% See also: cpsd

%% BUOC 1: Tinh auto-PSD cua tin hieu 1
% Giai thich: Tinh pho cong suat cua s1 voi chinh no
% Su dung 'twosided' de co pho hai phia (tan so am va duong)
[Pxx] = cpsd(s1, s1, win, n_overlap, nfft, Fs, 'twosided');

%% BUOC 2: Tinh auto-PSD cua tin hieu 2
% Giai thich: Tinh pho cong suat cua s2 voi chinh no
[Pyy] = cpsd(s2, s2, win, n_overlap, nfft, Fs, 'twosided');

%% BUOC 3: Tinh cross-PSD giua hai tin hieu
% Giai thich: Tinh pho tuong quan cheo giua s1 va s2
% Cross-PSD chua thong tin ve do tre va tuong quan giua hai tin hieu
[Pxy] = cpsd(s1, s2, win, n_overlap, nfft, Fs, 'twosided');

end
