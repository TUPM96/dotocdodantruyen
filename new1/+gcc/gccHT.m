% ==============================================================================
% TEN FILE: gccHT.m
% CHUC NANG: Uoc luong do tre bang Hannan-Thomson (Maximum Likelihood) nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi bo xu ly Hannan-Thomson (Maximum Likelihood) nang cao
%        Phuong phap toi uu nhat theo ly thuyet cho tin hieu Gaussian voi nhieu Gaussian cong
%        Co validation dau vao va xu ly loi tot hon
%
% Nguyen ly: Phat trien tu nguyen ly hop ly cuc dai (Maximum Likelihood)
%            Toi thieu hoa sai so trung binh binh phuong
%            Cong thuc trong so phuc tap hon Eckart, co them thanh phan tuong tac giua nhieu hai kenh
%
% Cong thuc trong so: Psi_HT(f) = Gss(f) / [Gss(f)*(Gn1n1 + Gn2n2) + Gn1n1*Gn2n2]
%
% Uu diem: Toi uu nhat theo nghia Maximum Likelihood, dat RMSE thap nhat
% Nhuoc diem: Can biet rat chinh xac pho tin hieu va phuong sai nhieu, phuc tap tinh toan cao nhat
%
function [delay, correlation] = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)

% Validation dau vao
if nargin < 5
    error('gcc:gccHT:NotEnoughInputs', ...
          'Can it nhat 5 tham so: Pxy, Gss, Gn1n1, Gn2n2, N');
end

if ~isvector(Pxy) || ~isvector(Gss)
    error('gcc:gccHT:InvalidInputType', ...
          'Pxy va Gss phai la vector');
end

if length(Pxy) ~= length(Gss)
    error('gcc:gccHT:LengthMismatch', ...
          'Pxy va Gss phai co cung do dai');
end

if ~isscalar(Gn1n1) || ~isscalar(Gn2n2) || Gn1n1 <= 0 || Gn2n2 <= 0
    error('gcc:gccHT:InvalidNoiseVariance', ...
          'Gn1n1 va Gn2n2 phai la so duong');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccHT:InvalidN', ...
          'N phai la so duong');
end

% Ap dung trong so Hannan-Thomson
% Tinh mau so phuc tap, sau do ap dung trong so
% Mau so bao gom ca tuong tac giua tin hieu va nhieu
denominator = Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2;

% Kiem tra mau so khong co gia tri 0 hoac am
if any(denominator <= 0) || any(~isfinite(denominator))
    warning('gcc:gccHT:InvalidDenominator', ...
            'Mau so co gia tri khong hop le, them epsilon nho');
    epsilon = max(denominator) * 1e-10;
    denominator = denominator + epsilon;
end

weighted_spectrum = Pxy .* Gss ./ denominator;

% Kiem tra ket qua
if any(~isfinite(weighted_spectrum))
    warning('gcc:gccHT:NonFiniteSpectrum', ...
            'Pho trong so co gia tri khong hop le');
    weighted_spectrum(~isfinite(weighted_spectrum)) = 0;
end

% Tinh ham tuong quan HT
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccHT:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre
% Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

