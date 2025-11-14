% ==============================================================================
% TEN FILE: gccBasic.m
% CHUC NANG: GCC co ban (tuong duong CC_time trong mien tan so)
% MODULE: gcc
% ==============================================================================
%
function [delay, correlation] = gccBasic(Pxy, N)
% GCCBASIC Basic GCC method (frequency domain cross-correlation)
%
% Ghi chu quan trong:
% - GCC co ban KHONG PHAI la mot phuong phap rieng biet
% - No chi la phien ban mien tan so cua CC_time
% - Ket qua tuong duong voi CC_time
% - Chi dung de minh hoa, khong tinh vao 6 phuong phap chinh
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC co ban (khong co trong so)
%
% Giai thich chi tiet:
% - GCC (Generalized Cross-Correlation): Tuong quan cheo tong quat
% - Phuong phap co ban nay tuong duong voi tuong quan cheo mien thoi gian
%   nhung duoc tinh trong mien tan so
% - Khong ap dung ham trong so (weighting function)
%
% Nguyen ly:
% - Tinh tuong quan cheo trong mien tan so bang cach lay IFFT cua
%   pho tuong quan cheo (cross-spectrum)
% - Dinh cua ham GCC cho biet do tre giua hai tin hieu
%
% Cong thuc:
%   R_GCC(tau) = IFFT[Pxy(f)]
%   Trong do:
%   - Pxy(f): Pho tuong quan cheo (Cross Power Spectral Density)
%   - IFFT: Bien doi Fourier nguoc (Inverse Fast Fourier Transform)
%   - tau: Do tre
%
% So sanh:
% - Giong CC_time nhung tinh trong mien tan so (nhanh hon voi FFT)
% - Khong co trong so nen nhay cam voi nhieu nhu CC_time
%
% SYNTAX:
%   [delay, correlation] = gccBasic(Pxy, N)
%
% INPUTS:
%   Pxy - Cross power spectral density (Pho tuong quan cheo)
%   N   - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong)
%   correlation - GCC function (Ham GCC)
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% BUOC 1: Tinh ham GCC (IFFT cua pho cheo)
% Giai thich:
% - Lay bien doi Fourier nguoc de chuyen tu mien tan so ve mien thoi gian
% - Su dung fftshift de dich chuyen pho ve trung tam (tau = 0 o giua)
correlation = fftshift(ifft(Pxy));

%% BUOC 2: Uoc luong do tre tu ham GCC
% Giai thich: Tim dinh cua ham GCC bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
