% ==============================================================================
% TEN FILE: gccPHAT.m
% CHUC NANG: Uoc luong do tre bang phuong phap PHAT (Phase Transform)
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so PHAT (Phase Transform)
%        PHAT "tay trang" pho cheo, lam pho tro nen phang
%        Nhan manh thong tin pha (phase) hon la bien do (magnitude)
%
% Nguyen ly: Chia pho cheo cho bien do cua no -> chi giu lai thong tin pha
%            Pha chua thong tin ve do tre, bien do chua thong tin ve nang luong
%            Bang cach loai bo bien do, phuong phap khong bi anh huong boi su bien thien nang luong theo tan so
%
% Cong thuc trong so: Psi_PHAT(f) = 1 / |Gss(f) + epsilon|
%
% Uu diem: Tot voi moi truong co nhieu phan xa, dinh tuong quan sac net
% Nhuoc diem: Nhay cam voi nhieu o cac tan so co nang luong thap
%
function [delay, correlation] = gccPHAT(Pxy, Gss, N)

% Ap dung trong so PHAT
% Chia pho cheo cho bien do tin hieu de "tay trang"
% Them epsilon de tranh chia cho 0 khi pho = 0
epsilon = 0.1;
weighted_spectrum = Pxy ./ (Gss + epsilon);

% Tinh ham tuong quan PHAT
% Lay IFFT cua pho da duoc trong so
correlation = fftshift(ifft(weighted_spectrum));

% Uoc luong do tre
% Tim dinh ham tuong quan bang noi suy Parabola
delay = gcc.estimateDelay(correlation, N, true);

end
