% ==============================================================================
% TEN FILE: gccPHAT.m
% CHUC NANG: Uoc luong do tre bang phuong phap PHAT (Phase Transform) nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so PHAT (Phase Transform) nang cao
%        PHAT "tay trang" pho cheo, lam pho tro nen phang
%        Nhan manh thong tin pha (phase) hon la bien do (magnitude)
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Chia pho cheo cho bien do cua no -> chi giu lai thong tin pha
%            Pha chua thong tin ve do tre, bien do chua thong tin ve nang luong
%
% Cong thuc trong so: Psi_PHAT(f) = 1 / |Gss(f) + epsilon|
%
% Uu diem: Tot voi moi truong co nhieu phan xa, dinh tuong quan sac net
% Nhuoc diem: Nhay cam voi nhieu o cac tan so co nang luong thap
%
function [delay, correlation] = gccPHAT(Pxy, Gss, N, epsilon)

% Validation dau vao
if nargin < 3
    error('gcc:gccPHAT:NotEnoughInputs', ...
          'Can it nhat 3 tham so: Pxy, Gss, N');
end

if ~isvector(Pxy) || ~isvector(Gss)
    error('gcc:gccPHAT:InvalidInputType', ...
          'Pxy va Gss phai la vector');
end

if length(Pxy) ~= length(Gss)
    error('gcc:gccPHAT:LengthMismatch', ...
          'Pxy va Gss phai co cung do dai');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccPHAT:InvalidN', ...
          'N phai la so duong');
end

% Tham so mac dinh
if nargin < 4 || isempty(epsilon)
    epsilon = 0.1;
end

% Kiem tra epsilon hop le
if epsilon <= 0
    warning('gcc:gccPHAT:InvalidEpsilon', ...
            'Epsilon phai duong, dat gia tri mac dinh 0.1');
    epsilon = 0.1;
end

% Ap dung trong so PHAT
% Chia pho cheo cho bien do tin hieu de "tay trang"
% Them epsilon de tranh chia cho 0 khi pho = 0
denominator = abs(Gss) + epsilon;

% Kiem tra mau so khong co gia tri 0 hoac Inf
if any(~isfinite(denominator)) || any(denominator == 0)
    warning('gcc:gccPHAT:InvalidDenominator', ...
            'Mau so co gia tri khong hop le, tang epsilon');
    epsilon = max(epsilon, max(abs(Gss)) * 1e-6);
    denominator = abs(Gss) + epsilon;
end

weighted_spectrum = Pxy ./ denominator;

% Tinh ham tuong quan PHAT
% Lay IFFT cua pho da duoc trong so
correlation = fftshift(ifft(weighted_spectrum));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccPHAT:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre
% Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

