% ==============================================================================
% TEN FILE: gccPHAT.m
% CHUC NANG: Phuong phap PHAT - Phase Transform
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC su dung bo loc PHAT
%        Tay trang pho, chi giu lai thong tin pha
%
% Cong thuc: R_phat = IFFT(Pxy / (Gss + epsilon))
%            Trong do: Pxy la cross-PSD, Gss la pho tin hieu sach
%            epsilon = 0.1 de tranh chia cho 0
%
function delay = gccPHAT(Pxy, Gss, N)

% Tinh tuong quan cheo sau khi loc bang bo loc PHAT
phatcorrelation = fftshift(ifft(Pxy ./ (Gss + 0.1)));

% Tim vi tri cuc dai
[~, phattime] = max(phatcorrelation);
phatestime = abs(N/2 - phattime + 1);

% Noi suy Parabola
delay = phatestime - 0.5 * (phatcorrelation(phattime+1) - phatcorrelation(phattime-1)) / ...
        (phatcorrelation(phattime+1) - 2*phatcorrelation(phattime) + phatcorrelation(phattime-1));

end

