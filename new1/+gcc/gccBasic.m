% ==============================================================================
% TEN FILE: gccBasic.m
% CHUC NANG: GCC co ban (tuong duong CC_time trong mien tan so) nang cao
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC co ban khong co trong so (nang cao)
%        Tuong duong voi tuong quan cheo mien thoi gian nhung tinh trong mien tan so
%        Co validation dau vao va xu ly loi tot hon
%
% Ghi chu: GCC co ban KHONG PHAI la mot phuong phap rieng biet
%          No chi la phien ban mien tan so cua CC_time
%
% Nguyen ly: Tinh tuong quan cheo trong mien tan so bang cach lay IFFT cua pho tuong quan cheo
%
function [delay, correlation] = gccBasic(Pxy, N)

% Validation dau vao
if nargin < 2
    error('gcc:gccBasic:NotEnoughInputs', ...
          'Can it nhat 2 tham so: Pxy, N');
end

if ~isvector(Pxy)
    error('gcc:gccBasic:InvalidInputType', ...
          'Pxy phai la vector');
end

if ~isscalar(N) || N <= 0
    error('gcc:gccBasic:InvalidN', ...
          'N phai la so duong');
end

% Tinh ham GCC (IFFT cua pho cheo)
% Lay bien doi Fourier nguoc de chuyen tu mien tan so ve mien thoi gian
% Su dung fftshift de dich chuyen pho ve trung tam (tau = 0 o giua)
correlation = fftshift(ifft(Pxy));

% Kiem tra ket qua
if any(~isfinite(correlation))
    warning('gcc:gccBasic:NonFiniteCorrelation', ...
            'Ham tuong quan co gia tri khong hop le');
    correlation(~isfinite(correlation)) = 0;
end

% Uoc luong do tre tu ham GCC
% Tim dinh cua ham GCC bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true, 'parabolic');

end

