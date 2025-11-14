% ==============================================================================
% TEN FILE: gccPHAT.m
% CHUC NANG: Uoc luong do tre bang phuong phap PHAT (Phase Transform)
% MODULE: gcc
% ==============================================================================
%
function [delay, correlation] = gccPHAT(Pxy, Gss, N)
% GCCPHAT Phase Transform (PHAT) GCC method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC voi trong so PHAT (Phase Transform)
%
% Giai thich chi tiet:
% - PHAT "tay trang" (whitens) pho cheo, lam pho tro nen phang
% - Nhan manh thong tin pha (phase) hon la bien do (magnitude)
% - Hieu qua tot trong moi truong co phan xa (reverberant)
%
% Nguyen ly:
% - Chia pho cheo cho bien do cua no -> chi giu lai thong tin pha
% - Pha chua thong tin ve do tre, bien do chua thong tin ve nang luong
% - Bang cach loai bo bien do, phuong phap khong bi anh huong boi
%   su bien thien nang luong theo tan so
%
% Cong thuc trong so:
%   Psi_PHAT(f) = 1 / |Gss(f) + epsilon|
%   R_PHAT(tau) = IFFT[Pxy(f) * Psi_PHAT(f)]
%                = IFFT[Pxy(f) / |Gss(f) + epsilon|]
%   Trong do:
%   - Gss(f): Pho tin hieu sach
%   - epsilon: Hang so nho de tranh chia cho 0
%
% Uu diem:
% - Tot voi moi truong co nhieu phan xa (phong, hang dong)
% - Khong nhay cam voi su bien doi cua bien do tin hieu
% - Dinh tuong quan sac net (narrow peak)
%
% Nhuoc diem:
% - Nhay cam voi nhieu o cac tan so co nang luong thap
%
% SYNTAX:
%   [delay, correlation] = gccPHAT(Pxy, Gss, N)
%
% INPUTS:
%   Pxy - Cross power spectral density (Pho tuong quan cheo)
%   Gss - Clean signal power spectrum (Pho tin hieu sach)
%   N   - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong)
%   correlation - PHAT correlation function (Ham tuong quan PHAT)
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% BUOC 1: Ap dung trong so PHAT
% Giai thich:
% - Chia pho cheo cho bien do tin hieu de "tay trang"
% - Them epsilon (0.1) de tranh chia cho 0 khi pho = 0
epsilon = 0.1;
weighted_spectrum = Pxy ./ (Gss + epsilon);

%% BUOC 2: Tinh ham tuong quan PHAT
% Giai thich: Lay IFFT cua pho da duoc trong so
correlation = fftshift(ifft(weighted_spectrum));

%% BUOC 3: Uoc luong do tre
% Giai thich: Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
