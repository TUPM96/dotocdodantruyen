% ==============================================================================
% TEN FILE: gccSCOT.m
% CHUC NANG: Uoc luong do tre bang SCOT (Smoothed Coherence Transform)
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC voi trong so SCOT (Smoothed Coherence Transform)
%        SCOT chuan hoa bang trung binh hinh hoc cua ca hai pho tu dong
%        Tinh toan "coherence" lam min giua hai tin hieu
%
% Nguyen ly: Chia pho cheo cho can bac hai cua tich hai pho tu dong
%            Giup loai bo anh huong cua bien do pho ca hai kenh
%            Tuong tu voi ham coherence nhung duoc lam min
%
% Cong thuc trong so: Psi_SCOT(f) = 1 / sqrt(Gx1x1(f) * Gx2x2(f))
%
% Uu diem: Doi xung khong thien vi kenh nao, tot khi ca hai kenh co SNR tuong duong nhau
% Nhuoc diem: Phuc tap hon Roth, van nhay cam voi nhieu o ca hai kenh
%
function [delay, correlation] = gccSCOT(Pxy, Gx1x1, Gx2x2, N)

% Ap dung trong so SCOT
% Chia cho can bac hai cua tich hai pho tu dong
weighted_spectrum = Pxy ./ sqrt(Gx1x1 .* Gx2x2);

% Tinh ham tuong quan SCOT
% IFFT de chuyen ve mien thoi gian
correlation = fftshift(ifft(weighted_spectrum));

% Uoc luong do tre
% Tim dinh ham tuong quan
delay = gcc.estimateDelay(correlation, N, true);

end
