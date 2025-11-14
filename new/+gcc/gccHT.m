% ==============================================================================
% TEN FILE: gccHT.m
% CHUC NANG: Uoc luong do tre bang Hannan-Thomson (Maximum Likelihood)
% MODULE: gcc
% ==============================================================================
%
function [delay, correlation] = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)
% GCCHT Hannan-Thomson (Maximum Likelihood) GCC method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC voi bo xu ly Hannan-Thomson (Maximum Likelihood)
%
% Giai thich chi tiet:
% - Bo xu ly Hannan-Thomson la bo uoc luong hop ly cuc dai (Maximum Likelihood)
% - Phuong phap toi uu nhat (theo ly thuyet) cho tin hieu Gaussian voi
%   nhieu Gaussian cong
% - Can biet chinh xac thong ke tin hieu va nhieu
%
% Nguyen ly:
% - Phat trien tu nguyen ly hop ly cuc dai (Maximum Likelihood)
% - Toi thieu hoa sai so trung binh binh phuong (Minimum Mean Square Error)
% - Cong thuc trong so phuc tap hon Eckart, co them thanh phan tuong tac
%   giua nhieu hai kenh
%
% Cong thuc trong so:
%   Psi_HT(f) = Gss(f) / [Gss(f)*(Gn1n1 + Gn2n2) + Gn1n1*Gn2n2]
%   R_HT(tau) = IFFT[Pxy(f) * Psi_HT(f)]
%   Trong do:
%   - Gss(f): Pho tin hieu sach
%   - Gn1n1, Gn2n2: Phuong sai nhieu kenh 1 va 2
%   - Mau so: Gss*(Gn1n1 + Gn2n2) + Gn1n1*Gn2n2
%     + Thanh phan 1: Gss*(Gn1n1 + Gn2n2) -> Nhieu doc lap tren tin hieu
%     + Thanh phan 2: Gn1n1*Gn2n2 -> Tuong tac nhieu giua hai kenh
%
% Uu diem:
% - Toi uu nhat theo nghia Maximum Likelihood (ML)
% - Dat RMSE thap nhat khi biet chinh xac thong ke tin hieu va nhieu
% - Co kha nang thich nghi tot voi dac tinh tin hieu va nhieu
%
% Nhuoc diem:
% - Can biet rat chinh xac pho tin hieu va phuong sai nhieu
% - Trong thuc te, rat kho co day du thong tin nay
% - Phuc tap tinh toan cao nhat trong cac phuong phap GCC
% - Nhay cam nhat voi sai so uoc luong thong ke
%
% So sanh:
% - Eckart: Phuong phap don gian hon, khong xet tuong tac nhieu
% - HT: Toi uu hon nhung can thong tin chinh xac hon
%
% SYNTAX:
%   [delay, correlation] = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density (Pho tuong quan cheo)
%   Gss   - Clean signal power spectrum (Pho tin hieu sach)
%   Gn1n1 - Noise variance for signal 1 (Phuong sai nhieu kenh 1)
%   Gn2n2 - Noise variance for signal 2 (Phuong sai nhieu kenh 2)
%   N     - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong)
%   correlation - HT correlation function (Ham tuong quan HT)
%
% REFERENCE:
%   E.J. Hannan and E.J. Thomson, "The estimation of coherence and group
%   delay", Biometrika, vol. 58, pp. 469-481, 1971.

%% BUOC 1: Ap dung trong so Hannan-Thomson
% Giai thich: Tinh mau so phuc tap, sau do ap dung trong so
% Mau so bao gom ca tuong tac giua tin hieu va nhieu
denominator = Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2;
weighted_spectrum = Pxy .* Gss ./ denominator;

%% BUOC 2: Tinh ham tuong quan HT
% Giai thich: IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

%% BUOC 3: Uoc luong do tre
% Giai thich: Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
