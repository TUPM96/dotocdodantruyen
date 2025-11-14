% ==============================================================================
% TEN FILE: gccECKART.m
% CHUC NANG: Uoc luong do tre bang bo loc Eckart nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi bo loc Eckart nang cao
%        Bo loc Eckart duoc thiet ke de toi da hoa SNR dau ra
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Tang trong so cac tan so co tin hieu manh (SNR cao)
%            Giam trong so cac tan so co nhieu manh (SNR thap)
%            Nhan pho cheo voi pho tin hieu sach, chia cho tich phuong sai nhieu
%
% Cong thuc trong so: Psi_ECKART(f) = Gss(f) / (Gn1n1 * Gn2n2)
%
% Uu diem: Toi uu SNR dau ra, chinh xac cao nhat (ly thuyet)
% Nhuoc diem: Can biet truoc pho tin hieu sach va thong ke nhieu
%
function [delay, correlation] = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)

% Validation dau vao
if nargin < 5
    error('gcc:gccECKART:NotEnoughInputs', ...
          'Can it nhat 5 tham so: Pxy, Gss, Gn1n1, Gn2n2, N');
end

if ~isvector(Pxy) || ~isvector(Gss)
    error('gcc:gccECKART:InvalidInputType', ...
          'Pxy va Gss phai la vector');
end

if length(Pxy) ~= length(Gss)
    error('gcc:gccECKART:LengthMismatch', ...
          'Pxy va Gss phai co cung do dai');
end

if ~isscalar(Gn1n1) || ~isscalar(Gn2n2) || Gn1n1 <= 0 || Gn2n2 <= 0
    error('gcc:gccECKART:InvalidNoiseVariance', ...
          'Gn1n1 va Gn2n2 phai la so duong');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccECKART:InvalidN', ...
          'N phai la so duong');
end

% Ap dung trong so Eckart
% Nhan voi pho tin hieu, chia cho tich phuong sai nhieu
denominator = Gn1n1 .* Gn2n2;

% Kiem tra mau so khong bang 0
if denominator <= 0 || ~isfinite(denominator)
    error('gcc:gccECKART:InvalidDenominator', ...
          'Tich phuong sai nhieu phai la so duong');
end

weighted_spectrum = Pxy .* Gss ./ denominator;

% Kiem tra ket qua
if any(~isfinite(weighted_spectrum))
    warning('gcc:gccECKART:NonFiniteSpectrum', ...
            'Pho trong so co gia tri khong hop le');
    weighted_spectrum(~isfinite(weighted_spectrum)) = 0;
end

% Tinh ham tuong quan Eckart
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccECKART:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

