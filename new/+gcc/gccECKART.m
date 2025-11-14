% ==============================================================================
% TEN FILE: gccECKART.m
% CHUC NANG: Uoc luong do tre bang bo loc Eckart
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi bo loc Eckart duoc thiet ke de toi da hoa SNR dau ra
%        Phuong phap toi uu khi ca hai kenh deu co nhieu cong
%        Can biet truoc pho tin hieu sach va phuong sai nhieu
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

% Ap dung trong so Eckart
% Nhan voi pho tin hieu, chia cho tich phuong sai nhieu
weighted_spectrum = Pxy .* Gss ./ (Gn1n1 .* Gn2n2);

% Tinh ham tuong quan Eckart
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
