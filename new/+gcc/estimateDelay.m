% ==============================================================================
% TEN FILE: estimateDelay.m
% CHUC NANG: Uoc luong do tre tu ham tuong quan bang noi suy Parabola
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Tim dinh cua ham tuong quan de xac dinh do tre
%        Su dung noi suy Parabola de tang do chinh xac len muc duoi mau
%
% Nguyen ly: Ham tuong quan cheo dat cuc dai tai vi tri tuong ung voi do tre
%            Noi suy Parabola: Khop duong Parabola qua 3 diem quanh dinh de tim
%            vi tri dinh chinh xac hon (khong phai so nguyen)
%
function delay = estimateDelay(correlation, N, use_interpolation)

% Neu khong chi dinh, mac dinh su dung noi suy Parabola
if nargin < 3
    use_interpolation = true;
end

% Tim vi tri dinh cua ham tuong quan
% Vi tri dinh tuong ung voi do tre giua hai tin hieu
[~, peak_idx] = max(correlation);

% Tinh do tre co ban (so nguyen mau)
% Chuyen tu chi so sang do tre
% Ham tuong quan duoc dich chuyen (fftshift) nen can tinh lai vi tri
delay_basic = abs(N/2 - peak_idx + 1);

% Ap dung noi suy Parabola neu duoc yeu cau
% Tang do chinh xac len muc duoi mau
if use_interpolation && peak_idx > 1 && peak_idx < length(correlation)
    % Lay 3 diem quanh dinh de noi suy
    y1 = correlation(peak_idx - 1);
    y2 = correlation(peak_idx);
    y3 = correlation(peak_idx + 1);
    
    % Cong thuc noi suy Parabola
    % delta la do dich chuyen phan so tu dinh so nguyen
    delta = 0.5 * (y3 - y1) / (y3 - 2*y2 + y1);
    delay = delay_basic - delta;
else
    % Khong noi suy: chi dung gia tri so nguyen
    delay = delay_basic;
end

end
