% ==============================================================================
% TEN FILE: gccSCOT.m
% CHUC NANG: Uoc luong do tre bang SCOT (Smoothed Coherence Transform) nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so SCOT nang cao
%        SCOT chuan hoa bang trung binh hinh hoc cua ca hai pho tu dong
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Chia pho cheo cho can bac hai cua tich hai pho tu dong
%            Giup loai bo anh huong cua bien do pho ca hai kenh
%
% Cong thuc trong so: Psi_SCOT(f) = 1 / sqrt(Gx1x1(f) * Gx2x2(f))
%
% Uu diem: Doi xung khong thien vi kenh nao, tot khi ca hai kenh co SNR tuong duong nhau
% Nhuoc diem: Phuc tap hon Roth, van nhay cam voi nhieu o ca hai kenh
%
function [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)

% Validation dau vao
if nargin < 4
    error('gcc:gccSCOT:NotEnoughInputs', ...
          'Can it nhat 4 tham so: Pxy, Gx1x1, Gx2x2, N');
end

if ~isvector(Pxy) || ~isvector(Gx1x1) || ~isvector(Gx2x2)
    error('gcc:gccSCOT:InvalidInputType', ...
          'Pxy, Gx1x1 va Gx2x2 phai la vector');
end

if length(Pxy) ~= length(Gx1x1) || length(Pxy) ~= length(Gx2x2)
    error('gcc:gccSCOT:LengthMismatch', ...
          'Pxy, Gx1x1 va Gx2x2 phai co cung do dai');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccSCOT:InvalidN', ...
          'N phai la so duong');
end

% Ap dung trong so SCOT
% Chia cho can bac hai cua tich hai pho tu dong
% Them epsilon nho de tranh chia cho 0
product = Gx1x1 .* Gx2x2;
epsilon = max(abs(product)) * 1e-10;
denominator = sqrt(product + epsilon);

% Kiem tra mau so
if any(denominator <= 0) || any(~isfinite(denominator))
    warning('gcc:gccSCOT:InvalidDenominator', ...
            'Mau so co gia tri khong hop le');
    epsilon = max(abs(product)) * 1e-6;
    denominator = sqrt(abs(product) + epsilon);
end

weighted_spectrum = Pxy ./ denominator;

% Kiem tra ket qua
if any(~isfinite(weighted_spectrum))
    warning('gcc:gccSCOT:NonFiniteSpectrum', ...
            'Pho trong so co gia tri khong hop le');
    weighted_spectrum(~isfinite(weighted_spectrum)) = 0;
end

% Tinh ham tuong quan SCOT
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccSCOT:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

