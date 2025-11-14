% ==============================================================================
% TEN FILE: ccTime.m
% CHUC NANG: Uoc luong do tre bang tuong quan cheo mien thoi gian
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap co ban nhat de uoc luong do tre giua hai tin hieu
%        bang cach tinh tuong quan cheo truc tiep trong mien thoi gian
%        Tim vi tri dinh cua ham tuong quan de xac dinh do tre
%
% Nguyen ly: Khi hai tin hieu giong nhau nhung lech nhau mot khoang thoi gian,
%            ham tuong quan cheo se dat cuc dai tai vi tri do tre
%
% Uu diem: Don gian, khong can chuyen doi sang mien tan so
% Nhuoc diem: Nhay cam voi nhieu, hieu suat thap hon cac phuong phap GCC co trong so
%
function [delay, correlation] = ccTime(s1, s2, N)

% Tinh tuong quan cheo trong mien thoi gian
% Su dung ham xcorr de tinh tuong quan cheo
% Gioi han do tre toi da = length(s1)/2 de tang toc do tinh toan
[Rx1x2, ~] = xcorr(s1, s2, length(s1)/2);
Rx1x2 = Rx1x2(1:end-1);

% Luu ham tuong quan
correlation = Rx1x2;

% Uoc luong do tre tu ham tuong quan
% Tim dinh cua ham tuong quan va dung noi suy Parabola de tang do chinh xac
delay = gcc.estimateDelay(correlation, N, true);

end
