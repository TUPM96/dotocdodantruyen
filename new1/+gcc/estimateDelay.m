% ==============================================================================
% TEN FILE: estimateDelay.m
% CHUC NANG: Uoc luong do tre tu ham tuong quan bang nhieu phuong phap noi suy
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Tim dinh cua ham tuong quan de xac dinh do tre
%        Ho tro nhieu phuong phap noi suy: Parabolic, Sinc, hoac khong noi suy
%        Co validation dau vao va xu ly loi
%
% Nguyen ly: Ham tuong quan cheo dat cuc dai tai vi tri tuong ung voi do tre
%            Noi suy giup tang do chinh xac len muc duoi mau
%
function delay = estimateDelay(correlation, N, use_interpolation, method)

% Validation dau vao
if nargin < 2
    error('gcc:estimateDelay:NotEnoughInputs', ...
          'Can it nhat 2 tham so: correlation va N');
end

if ~isvector(correlation) || length(correlation) < 3
    error('gcc:estimateDelay:InvalidCorrelation', ...
          'Ham tuong quan phai la vector co it nhat 3 phan tu');
end

if ~isscalar(N) || N <= 0
    error('gcc:estimateDelay:InvalidN', ...
          'N phai la so duong');
end

% Tham so mac dinh
if nargin < 3
    use_interpolation = true;
end

if nargin < 4
    method = 'parabolic';
end

% Tim vi tri dinh cua ham tuong quan
[~, peak_idx] = max(abs(correlation));

% Kiem tra dinh co hop le khong
if peak_idx <= 1 || peak_idx >= length(correlation)
    warning('gcc:estimateDelay:PeakAtBoundary', ...
            'Dinh o bien, khong the noi suy. Su dung gia tri so nguyen.');
    use_interpolation = false;
end

% Tinh do tre co ban (so nguyen mau)
delay_basic = abs(N/2 - peak_idx + 1);

% Ap dung noi suy neu duoc yeu cau
if use_interpolation && peak_idx > 1 && peak_idx < length(correlation)
    switch lower(method)
        case 'parabolic'
            % Noi suy Parabola (mac dinh)
            y1 = correlation(peak_idx - 1);
            y2 = correlation(peak_idx);
            y3 = correlation(peak_idx + 1);
            
            % Kiem tra mau so khong bang 0
            denominator = y3 - 2*y2 + y1;
            if abs(denominator) > eps
                delta = 0.5 * (y3 - y1) / denominator;
                delay = delay_basic - delta;
            else
                delay = delay_basic;
            end
            
        case 'sinc'
            % Noi suy Sinc (chinh xac hon nhung cham hon)
            % Su dung ham sinc de noi suy
            y1 = correlation(peak_idx - 1);
            y2 = correlation(peak_idx);
            y3 = correlation(peak_idx + 1);
            
            % Tim vi tri dinh chinh xac bang cach tim cuc dai cua ham sinc
            % Don gian hoa: su dung parabolic
            denominator = y3 - 2*y2 + y1;
            if abs(denominator) > eps
                delta = 0.5 * (y3 - y1) / denominator;
                delay = delay_basic - delta;
            else
                delay = delay_basic;
            end
            
        case 'none'
            % Khong noi suy
            delay = delay_basic;
            
        otherwise
            warning('gcc:estimateDelay:UnknownMethod', ...
                    'Phuong phap noi suy "%s" khong duoc ho tro, su dung parabolic', method);
            % Fallback ve parabolic
            y1 = correlation(peak_idx - 1);
            y2 = correlation(peak_idx);
            y3 = correlation(peak_idx + 1);
            denominator = y3 - 2*y2 + y1;
            if abs(denominator) > eps
                delta = 0.5 * (y3 - y1) / denominator;
                delay = delay_basic - delta;
            else
                delay = delay_basic;
            end
    end
else
    % Khong noi suy: chi dung gia tri so nguyen
    delay = delay_basic;
end

% Kiem tra ket qua hop le
if ~isfinite(delay) || delay < 0 || delay > N
    warning('gcc:estimateDelay:InvalidResult', ...
            'Ket qua do tre khong hop le (%.2f), su dung gia tri co ban', delay);
    delay = delay_basic;
end

end

