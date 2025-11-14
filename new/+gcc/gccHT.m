% ==============================================================================
% TEN FILE: gccHT.m
% CHUC NANG: Uoc luong do tre bang Hannan-Thomson (Maximum Likelihood)
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi bo xu ly Hannan-Thomson (Maximum Likelihood)
%        Phuong phap toi uu nhat theo ly thuyet cho tin hieu Gaussian voi nhieu Gaussian cong
%        Can biet chinh xac thong ke tin hieu va nhieu
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

% Ap dung trong so Hannan-Thomson
% Tinh mau so phuc tap, sau do ap dung trong so
% Mau so bao gom ca tuong tac giua tin hieu va nhieu
denominator = Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2;
weighted_spectrum = Pxy .* Gss ./ denominator;

% Tinh ham tuong quan HT
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Uoc luong do tre
% Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
