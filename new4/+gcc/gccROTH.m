% ==============================================================================
% TEN FILE: gccROTH.m
% CHUC NANG: Phuong phap ROTH - Bo xu ly Roth
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC su dung bo loc Roth
%        Chuan hoa theo pho tu dong cua kenh 1
%
% Cong thuc: R_roth = IFFT(Pxy / Gx1x1)
%            Trong do: Pxy la cross-PSD, Gx1x1 la auto-PSD cua kenh 1
%
function delay = gccROTH(Pxy, Gx1x1, N)

% Tinh tuong quan cheo sau khi loc bang bo loc Roth
Rothcorrelation = fftshift(ifft(Pxy ./ Gx1x1));

% Tim vi tri cuc dai
[~, Rothtime] = max(Rothcorrelation);
Rothestime = abs(N/2 - Rothtime + 1);

% Noi suy Parabola
delay = Rothestime - 0.5 * (Rothcorrelation(Rothtime+1) - Rothcorrelation(Rothtime-1)) / ...
        (Rothcorrelation(Rothtime+1) - 2*Rothcorrelation(Rothtime) + Rothcorrelation(Rothtime-1));

end

