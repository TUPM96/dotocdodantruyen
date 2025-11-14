function [delay, correlation] = gccROTH(Pxy, Gx1x1, N)
% GCCROTH Roth processor GCC method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC voi trong so Roth
%
% Giai thich chi tiet:
% - Bo xu ly Roth chuan hoa bang pho tu dong cua tin hieu thu nhat
% - Phuong phap "tay trang" don gian, hieu qua khi tin hieu thu nhat
%   co SNR tot hon tin hieu thu hai
%
% Nguyen ly:
% - Chia pho cheo cho pho tu dong cua tin hieu thu nhat
% - Giup giam anh huong cua bien do pho tin hieu thu nhat
% - Tuong tu PHAT nhung chi dung pho cua mot kenh
%
% Cong thuc trong so:
%   Psi_ROTH(f) = 1 / Gx1x1(f)
%   R_ROTH(tau) = IFFT[Pxy(f) / Gx1x1(f)]
%   Trong do:
%   - Gx1x1(f): Pho tu dong cua tin hieu thu nhat
%
% Uu diem:
% - Don gian, de thuc hien
% - Tot khi tin hieu thu nhat (tham chieu) co SNR cao
% - Khong can biet truoc thong tin ve nhieu
%
% Nhuoc diem:
% - Khong toi uu neu ca hai tin hieu deu co nhieu lon
% - Chi tay trang theo mot kenh nen khong doi xung
%
% Ung dung:
% - Khi mot kenh la tham chieu sach (hoac gan sach)
% - He thong co mot micro tot hon micro kia
%
% SYNTAX:
%   [delay, correlation] = gccROTH(Pxy, Gx1x1, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density (Pho tuong quan cheo)
%   Gx1x1 - Auto power spectrum of first signal (Pho tu dong tin hieu 1)
%   N     - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong)
%   correlation - Roth correlation function (Ham tuong quan Roth)
%
% REFERENCE:
%   P.R. Roth, "Effective measurements using complex correlation and
%   complex coherence", IEEE Trans. Instrumentation and Measurement,
%   vol. 20, pp. 83-92, 1971.

%% BUOC 1: Ap dung trong so Roth
% Giai thich: Chia pho cheo cho pho tu dong kenh 1
weighted_spectrum = Pxy ./ Gx1x1;

%% BUOC 2: Tinh ham tuong quan Roth
% Giai thich: IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

%% BUOC 3: Uoc luong do tre
% Giai thich: Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
