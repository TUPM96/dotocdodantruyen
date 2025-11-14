function [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)
% GCCSCOT Smoothed Coherence Transform (SCOT) GCC method
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Phuong phap GCC voi trong so SCOT (Smoothed Coherence Transform)
%
% Giai thich chi tiet:
% - SCOT chuan hoa bang trung binh hinh hoc cua ca hai pho tu dong
% - Tinh toan "coherence" (do tuong quan) lam min giua hai tin hieu
% - Doi xung: Xu ly ca hai kenh nhu nhau
%
% Nguyen ly:
% - Chia pho cheo cho can bac hai cua tich hai pho tu dong
% - Giup loai bo anh huong cua bien do pho ca hai kenh
% - Tuong tu voi ham coherence nhung duoc lam min (smoothed)
%
% Cong thuc trong so:
%   Psi_SCOT(f) = 1 / sqrt(Gx1x1(f) * Gx2x2(f))
%   R_SCOT(tau) = IFFT[Pxy(f) / sqrt(Gx1x1(f) * Gx2x2(f))]
%   Trong do:
%   - Gx1x1(f): Pho tu dong tin hieu 1
%   - Gx2x2(f): Pho tu dong tin hieu 2
%   - sqrt(A*B): Trung binh hinh hoc (geometric mean)
%
% Uu diem:
% - Doi xung: Khong thien vi kenh nao
% - Tot khi ca hai kenh co SNR tuong duong nhau
% - Chuan hoa bang cong suat ca hai kenh -> ben vung
%
% Nhuoc diem:
% - Phuc tap hon Roth
% - Van nhay cam voi nhieu o ca hai kenh
%
% So sanh:
% - Roth: Chi dung pho kenh 1 -> Khong doi xung
% - SCOT: Dung pho ca hai kenh -> Doi xung
% - PHAT: Chi dung pho tin hieu sach -> Can biet truoc
%
% SYNTAX:
%   [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)
%
% INPUTS:
%   Pxy   - Cross power spectral density (Pho tuong quan cheo)
%   Gx1x1 - Auto power spectrum of first signal (Pho tu dong tin hieu 1)
%   Gx2x2 - Auto power spectrum of second signal (Pho tu dong tin hieu 2)
%   N     - Signal length (Do dai tin hieu)
%
% OUTPUTS:
%   delay       - Estimated delay in samples (Do tre uoc luong)
%   correlation - SCOT correlation function (Ham tuong quan SCOT)
%
% REFERENCE:
%   G.C. Carter et al., "Coherence and time delay estimation",
%   Proc. IEEE, vol. 75, pp. 236-255, Feb. 1987.

%% BUOC 1: Ap dung trong so SCOT
% Giai thich: Chia cho can bac hai cua tich hai pho tu dong
weighted_spectrum = Pxy ./ sqrt(Gx1x1 .* Gx2x2);

%% BUOC 2: Tinh ham tuong quan SCOT
% Giai thich: IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

%% BUOC 3: Uoc luong do tre
% Giai thich: Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
