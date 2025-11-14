function [delay, correlation] = ccTime(s1, s2, N)
% CCTIME Time-domain cross-correlation method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Uoc luong do tre bang phuong phap tuong quan cheo mien thoi gian
%
% Giai thich chi tiet:
% - Phuong phap co ban nhat de uoc luong do tre giua hai tin hieu
% - Tinh tuong quan cheo (cross-correlation) truc tiep trong mien thoi gian
% - Tim vi tri cua dinh tuong quan de xac dinh do tre
%
% Nguyen ly:
% - Khi hai tin hieu giong nhau nhung lech nhau mot khoang thoi gian tau,
%   ham tuong quan cheo se dat cuc dai tai tau
% - Cong thuc: R_xy(tau) = E[x(t) * y(t + tau)]
%
% Uu diem:
% - Don gian, de hieu
% - Khong can chuyen doi sang mien tan so
%
% Nhuoc diem:
% - Nhay cam voi nhieu
% - Hieu suat thap hon cac phuong phap GCC co trong so
%
% SYNTAX:
%   [delay, correlation] = ccTime(s1, s2, N)
%
% INPUTS:
%   s1 - First signal (Tin hieu thu nhat - vector)
%   s2 - Second signal (Tin hieu thu hai - vector)
%   N  - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong, don vi: mau)
%   correlation - Cross-correlation function (Ham tuong quan cheo)
%
% REFERENCE:
%   C.H. Knapp and G.C. Carter, "The generalized correlation method for
%   estimation of time delay", IEEE Trans. Acoustics, Speech and Signal
%   Processing, vol. 24, pp. 320-327, Aug. 1976.

%% BUOC 1: Tinh tuong quan cheo trong mien thoi gian
% Giai thich:
% - Su dung ham xcorr de tinh tuong quan cheo
% - Gioi han do tre toi da = length(s1)/2 de tang toc do tinh toan
% - Cat bo mau cuoi cung de co do dai dung
[Rx1x2, ~] = xcorr(s1, s2, length(s1)/2);
Rx1x2 = Rx1x2(1:end-1);

%% BUOC 2: Luu ham tuong quan
correlation = Rx1x2;

%% BUOC 3: Uoc luong do tre tu ham tuong quan
% Giai thich: Tim dinh cua ham tuong quan va dung noi suy Parabola
% de tang do chinh xac len muc duoi mau
delay = gcc.estimateDelay(correlation, N, true);

end
