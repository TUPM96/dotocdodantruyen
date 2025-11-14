% ==============================================================================
% TEN FILE: gccECKART.m
% CHUC NANG: Uoc luong do tre bang bo loc Eckart
% MODULE: gcc
% ==============================================================================
%
function [delay, correlation] = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)
% GCCECKART Eckart filter GCC method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC voi bo loc Eckart
%
% Giai thich chi tiet:
% - Bo loc Eckart duoc thiet ke de toi da hoa SNR dau ra
% - Phuong phap toi uu khi ca hai kenh deu co nhieu cong
% - Can biet truoc pho tin hieu sach va phuong sai nhieu
%
% Nguyen ly:
% - Tang trong so cac tan so co tin hieu manh (SNR cao)
% - Giam trong so cac tan so co nhieu manh (SNR thap)
% - Nhan pho cheo voi pho tin hieu sach, chia cho tich phuong sai nhieu
%
% Cong thuc trong so:
%   Psi_ECKART(f) = Gss(f) / (Gn1n1 * Gn2n2)
%   R_ECKART(tau) = IFFT[Pxy(f) * Psi_ECKART(f)]
%                 = IFFT[Pxy(f) * Gss(f) / (Gn1n1 * Gn2n2)]
%   Trong do:
%   - Gss(f): Pho tin hieu sach (ly thuyet)
%   - Gn1n1: Phuong sai nhieu kenh 1
%   - Gn2n2: Phuong sai nhieu kenh 2
%
% Uu diem:
% - Toi uu SNR dau ra -> Chinh xac cao nhat (ly thuyet)
% - Thich nghi voi pho tin hieu: trong so cao o tan so co nang luong cao
% - Kha nang chong nhieu tot
%
% Nhuoc diem:
% - Can biet truoc pho tin hieu sach va thong ke nhieu
% - Trong thuc te, kho co thong tin day du ve tin hieu va nhieu
% - Nhay cam voi sai so uoc luong pho
%
% Ung dung:
% - Mo phong (simulation) khi biet chinh xac tin hieu va nhieu
% - He thong co the huan luyen truoc (training data)
%
% SYNTAX:
%   [delay, correlation] = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)
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
%   correlation - Eckart correlation function (Ham tuong quan Eckart)
%
% REFERENCE:
%   C. Eckart, "Optimal rectifier systems for the detection of steady
%   signals", SIO Ref. 52-11, Scripps Inst. Oceanogr., Univ. Calif.,
%   La Jolla, 1952.

%% BUOC 1: Ap dung trong so Eckart
% Giai thich: Nhan voi pho tin hieu, chia cho tich phuong sai nhieu
weighted_spectrum = Pxy .* Gss ./ (Gn1n1 .* Gn2n2);

%% BUOC 2: Tinh ham tuong quan Eckart
% Giai thich: IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

%% BUOC 3: Uoc luong do tre
% Giai thich: Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
