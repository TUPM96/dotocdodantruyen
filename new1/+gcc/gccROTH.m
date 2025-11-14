% ==============================================================================
% TEN FILE: gccROTH.m
% CHUC NANG: Uoc luong do tre bang bo xu ly Roth nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so Roth nang cao
%        Bo xu ly Roth chuan hoa bang pho tu dong cua tin hieu thu nhat
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Chia pho cheo cho pho tu dong cua tin hieu thu nhat
%            Giup giam anh huong cua bien do pho tin hieu thu nhat
%
% Cong thuc trong so: Psi_ROTH(f) = 1 / Gx1x1(f)
%
% Uu diem: Don gian, de thuc hien, tot khi tin hieu thu nhat co SNR cao
% Nhuoc diem: Khong toi uu neu ca hai tin hieu deu co nhieu lon, khong doi xung
%
function [delay, correlation] = gccROTH(Pxy, Gx1x1, N)

% Validation dau vao
if nargin < 3
    error('gcc:gccROTH:NotEnoughInputs', ...
          'Can it nhat 3 tham so: Pxy, Gx1x1, N');
end

if ~isvector(Pxy) || ~isvector(Gx1x1)
    error('gcc:gccROTH:InvalidInputType', ...
          'Pxy va Gx1x1 phai la vector');
end

if length(Pxy) ~= length(Gx1x1)
    error('gcc:gccROTH:LengthMismatch', ...
          'Pxy va Gx1x1 phai co cung do dai');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccROTH:InvalidN', ...
          'N phai la so duong');
end

% Ap dung trong so Roth
% Chia pho cheo cho pho tu dong kenh 1
% Them epsilon nho de tranh chia cho 0
epsilon = max(abs(Gx1x1)) * 1e-10;
denominator = Gx1x1 + epsilon;

% Kiem tra mau so
if any(denominator <= 0) || any(~isfinite(denominator))
    warning('gcc:gccROTH:InvalidDenominator', ...
            'Mau so co gia tri khong hop le');
    epsilon = max(abs(Gx1x1)) * 1e-6;
    denominator = abs(Gx1x1) + epsilon;
end

weighted_spectrum = Pxy ./ denominator;

% Kiem tra ket qua
if any(~isfinite(weighted_spectrum))
    warning('gcc:gccROTH:NonFiniteSpectrum', ...
            'Pho trong so co gia tri khong hop le');
    weighted_spectrum(~isfinite(weighted_spectrum)) = 0;
end

% Tinh ham tuong quan Roth
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccROTH:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

