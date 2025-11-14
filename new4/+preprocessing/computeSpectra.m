% ==============================================================================
% TEN FILE: computeSpectra.m
% CHUC NANG: Tinh mat do pho tu dong va cheo su dung phuong phap Welch
% MODULE: preprocessing
% ==============================================================================
%
% Mo ta: Tinh mat do pho cong suat tu dong (auto-PSD) va cheo (cross-PSD) 
%        cua hai tin hieu su dung phuong phap Welch
%
% Phuong phap Welch: Chia tin hieu thanh cac doan chong chap, tinh PSD 
%                    cua tung doan, roi lay trung binh de giam nhieu
%
function [Pxx, Pyy, Pxy] = computeSpectra(s1_noise, s2_noise, win, n_overlap, nfft, Fs)

% Tinh auto-PSD cua tin hieu 1
% Tinh pho cong suat cua s1_noise voi chinh no
[Pxx] = cpsd(s1_noise, s1_noise, win, n_overlap, nfft, Fs, 'twoside');

% Tinh auto-PSD cua tin hieu 2
% Tinh pho cong suat cua s2_noise voi chinh no
[Pyy] = cpsd(s2_noise, s2_noise, win, n_overlap, nfft, Fs, 'twoside');

% Tinh cross-PSD giua hai tin hieu
% Tinh pho tuong quan cheo giua s1_noise va s2_noise
% Cross-PSD chua thong tin ve do tre va tuong quan giua hai tin hieu
[Pxy] = cpsd(s1_noise, s2_noise, win, n_overlap, nfft, Fs, 'twoside');

end

