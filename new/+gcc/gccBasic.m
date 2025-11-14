% ==============================================================================
% TEN FILE: gccBasic.m
% CHUC NANG: GCC co ban (tuong duong CC_time trong mien tan so)
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC co ban khong co trong so
%        Tuong duong voi tuong quan cheo mien thoi gian nhung tinh trong mien tan so
%
% Ghi chu: GCC co ban KHONG PHAI la mot phuong phap rieng biet
%          No chi la phien ban mien tan so cua CC_time
%          Ket qua tuong duong voi CC_time, chi dung de minh hoa
%
% Nguyen ly: Tinh tuong quan cheo trong mien tan so bang cach lay IFFT cua pho tuong quan cheo
%            Dinh cua ham GCC cho biet do tre giua hai tin hieu
%
function [delay, correlation] = gccBasic(Pxy, N)

% Tinh ham GCC (IFFT cua pho cheo)
% Lay bien doi Fourier nguoc de chuyen tu mien tan so ve mien thoi gian
% Su dung fftshift de dich chuyen pho ve trung tam (tau = 0 o giua)
correlation = fftshift(ifft(Pxy));

% Uoc luong do tre tu ham GCC
% Tim dinh cua ham GCC bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
