% ==============================================================================
% TEN FILE: gccROTH.m
% CHUC NANG: Uoc luong do tre bang bo xu ly Roth
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so Roth
%        Bo xu ly Roth chuan hoa bang pho tu dong cua tin hieu thu nhat
%        Phuong phap "tay trang" don gian, hieu qua khi tin hieu thu nhat co SNR tot hon
%
% Nguyen ly: Chia pho cheo cho pho tu dong cua tin hieu thu nhat
%            Giup giam anh huong cua bien do pho tin hieu thu nhat
%            Tuong tu PHAT nhung chi dung pho cua mot kenh
%
% Cong thuc trong so: Psi_ROTH(f) = 1 / Gx1x1(f)
%
% Uu diem: Don gian, de thuc hien, tot khi tin hieu thu nhat co SNR cao
% Nhuoc diem: Khong toi uu neu ca hai tin hieu deu co nhieu lon, khong doi xung
%
function [delay, correlation] = gccROTH(Pxy, Gx1x1, N)

% Ap dung trong so Roth
% Chia pho cheo cho pho tu dong kenh 1
weighted_spectrum = Pxy ./ Gx1x1;

% Tinh ham tuong quan Roth
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
