% ==============================================================================
% TEN FILE: computeTheoreticalSpectra.m
% CHUC NANG: Tinh pho ly thuyet cho cac phuong phap ECKART va HT
% MODULE: preprocessing
% ==============================================================================
%
% Mo ta: Tinh pho tu dong cua tin hieu co nhieu va pho tin hieu sach
%        Su dung cho cac phuong phap ECKART va HT (Maximum Likelihood)
%
function [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = computeTheoreticalSpectra(PSD, s1, s2, SNR)

% Tinh phuong sai nhieu
% Cong thuc: Gn = var(signal) * 10^(-SNR/10)
Gn1n1 = var(s1) * 10^(-SNR/10);
Gn2n2 = var(s2) * 10^(-SNR/10);

% Tinh pho tu dong cua tin hieu co nhieu
% Cong thuc: Gx = PSD * var(signal) / mean(PSD) + Gn
Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
Gx1x1 = Gx1x1';

Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
Gx2x2 = Gx2x2';

% Pho tin hieu sach (khong co nhieu)
Gss = PSD';

end

