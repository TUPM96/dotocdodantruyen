% ==============================================================================
% TEN FILE: computeTheoreticalSpectra.m
% CHUC NANG: Tinh cac pho ly thuyet cho cac phuong phap GCC
% MODULE: preprocessing
% ==============================================================================
%
% Mo ta: Tinh cac pho ly thuyet cho cac phuong phap GCC
%        Mot so phuong phap GCC (vd: Eckart, Hannan-Thomson) can biet truoc
%        thong ke cua tin hieu va nhieu de toi uu hoa bo trong so
%
% Mo hinh tin hieu: x(t) = s(t) + n(t)
%   - x(t): Tin hieu do duoc (quan sat)
%   - s(t): Tin hieu sach (clean signal)
%   - n(t): Nhieu trang Gaussian
%
% Pho cua tin hieu do: Gxx(f) = Gss(f) + Gnn(f)
%
function [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR_dB)

% Tinh phuong sai nhieu cho moi kenh
% Tu SNR_dB, tinh nguoc lai phuong sai nhieu
% Gia dinh nhieu la trang (pho phang) nen phuong sai = cong suat
% Cong thuc: noise_var = signal_var / 10^(SNR_dB/10)
Gn1n1 = var(s1) * 10^(-SNR_dB / 10);
Gn2n2 = var(s2) * 10^(-SNR_dB / 10);

% Tinh pho tu dong cua tin hieu co nhieu
% Pho tin hieu do = Pho tin hieu sach + Pho nhieu
% Ty le PSD theo phuong sai tin hieu thuc te
% Chia cho mean(PSD) de chuan hoa, sau do nhan voi var(s) de ty le dung

% Pho tu dong tin hieu 1 (signal + noise)
Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
Gx1x1 = Gx1x1';

% Pho tu dong tin hieu 2 (signal + noise)
Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
Gx2x2 = Gx2x2';

% Pho tin hieu sach
% Su dung PSD ly thuyet (Farina-Merletti) lam pho tin hieu sach
Gss = PSD';

end
