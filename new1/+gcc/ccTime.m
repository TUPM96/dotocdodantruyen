% ==============================================================================
% TEN FILE: ccTime.m
% CHUC NANG: Uoc luong do tre bang tuong quan cheo mien thoi gian nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap co ban nhat de uoc luong do tre giua hai tin hieu
%        bang cach tinh tuong quan cheo truc tiep trong mien thoi gian
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Khi hai tin hieu giong nhau nhung lech nhau mot khoang thoi gian,
%            ham tuong quan cheo se dat cuc dai tai vi tri do tre
%
% Uu diem: Don gian, khong can chuyen doi sang mien tan so
% Nhuoc diem: Nhay cam voi nhieu, hieu suat thap hon cac phuong phap GCC co trong so
%
function [delay, correlation] = ccTime(s1, s2, N)

% Validation dau vao
if nargin < 3
    error('gcc:ccTime:NotEnoughInputs', ...
          'Can it nhat 3 tham so: s1, s2, N');
end

if ~isvector(s1) || ~isvector(s2)
    error('gcc:ccTime:InvalidInputType', ...
          's1 va s2 phai la vector');
end

if length(s1) ~= length(s2)
    error('gcc:ccTime:LengthMismatch', ...
          's1 va s2 phai co cung do dai');
end

if ~isscalar(N) || N <= 0
    error('gcc:ccTime:InvalidN', ...
          'N phai la so duong');
end

% Kiem tra tin hieu co gia tri hop le
if any(~isfinite(s1)) || any(~isfinite(s2))
    error('gcc:ccTime:NonFiniteValues', ...
          'Tin hieu khong duoc chua gia tri Inf hoac NaN');
end

% Tinh tuong quan cheo trong mien thoi gian
% Su dung ham xcorr de tinh tuong quan cheo
% Gioi han do tre toi da = length(s1)/2 de tang toc do tinh toan
max_lag = floor(length(s1) / 2);
[Rx1x2, ~] = xcorr(s1, s2, max_lag);

% Loai bo mau cuoi cung neu can
if length(Rx1x2) > 2*max_lag + 1
    Rx1x2 = Rx1x2(1:end-1);
end

% Luu ham tuong quan
correlation = Rx1x2;

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:ccTime:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre tu ham tuong quan
% Tim dinh cua ham tuong quan va dung noi suy Parabola de tang do chinh xac
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

