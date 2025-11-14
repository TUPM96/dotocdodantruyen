% ==============================================================================
% TEN FILE: estimateDelay.m
% CHUC NANG: Uoc luong do tre tu ham tuong quan bang noi suy Parabola
% MODULE: gcc
% ==============================================================================
%
function delay = estimateDelay(correlation, N, use_interpolation)
% ESTIMATEDELAY Estimate time delay from correlation function
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Uoc luong do tre thoi gian tu ham tuong quan
%
% Giai thich chi tiet:
% - Tim dinh (peak) cua ham tuong quan de xac dinh do tre
% - Su dung noi suy Parabola (parabolic interpolation) de tang do chinh xac
%   len muc duoi mau (sub-sample accuracy)
%
% Nguyen ly:
% - Ham tuong quan cheo dat cuc dai tai vi tri tuong ung voi do tre
% - Noi suy Parabola: Khop duong Parabola qua 3 diem quanh dinh de tim
%   vi tri dinh chinh xac hon (khong phai so nguyen)
%
% Thuat toan noi suy Parabola:
%   delta = 0.5 * (y3 - y1) / (y3 - 2*y2 + y1)
%   Trong do: y1, y2, y3 la 3 gia tri lien tiep quanh dinh
%
% SYNTAX:
%   delay = estimateDelay(correlation, N)
%   delay = estimateDelay(correlation, N, use_interpolation)
%
% INPUTS:
%   correlation        - Correlation function (Ham tuong quan - vector)
%   N                  - Signal length (Do dai tin hieu)
%   use_interpolation  - (Optional) true: dung noi suy, false: khong dung (mac dinh: true)
%
% OUTPUTS:
%   delay - Estimated delay in samples (Do tre uoc luong, don vi: mau)
%
% DESCRIPTION:
%   Finds the peak and estimates delay with optional sub-sample accuracy.

%% BUOC 1: Thiet lap tham so mac dinh
% Neu khong chi dinh, mac dinh su dung noi suy Parabola
if nargin < 3
    use_interpolation = true;
end

%% BUOC 2: Tim vi tri dinh cua ham tuong quan
% Giai thich: Vi tri dinh tuong ung voi do tre giua hai tin hieu
[~, peak_idx] = max(correlation);

%% BUOC 3: Tinh do tre co ban (so nguyen mau)
% Giai thich: Chuyen tu chi so sang do tre
% Ham tuong quan duoc dich chuyen (fftshift) nen can tinh lai vi tri
delay_basic = abs(N/2 - peak_idx + 1);

%% BUOC 4: Ap dung noi suy Parabola neu duoc yeu cau
% Giai thich: Tang do chinh xac len muc duoi mau
if use_interpolation && peak_idx > 1 && peak_idx < length(correlation)
    % Lay 3 diem quanh dinh de noi suy
    y1 = correlation(peak_idx - 1);  % Diem truoc dinh
    y2 = correlation(peak_idx);      % Diem dinh
    y3 = correlation(peak_idx + 1);  % Diem sau dinh

    % Cong thuc noi suy Parabola
    % delta la do dich chuyen phan so tu dinh so nguyen
    delta = 0.5 * (y3 - y1) / (y3 - 2*y2 + y1);
    delay = delay_basic - delta;
else
    % Khong noi suy: chi dung gia tri so nguyen
    delay = delay_basic;
end

end
