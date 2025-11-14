% ==============================================================================
% TEN FILE: gccSCOT.m
% CHUC NANG: Phuong phap SCOT - Smoothed Coherence Transform
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC su dung bo loc SCOT
%        Chuan hoa doi xung theo can bac hai cua tich pho tu dong
%
% Cong thuc: R_scot = IFFT(Pxy / sqrt(Gx1x1 * Gx2x2))
%            Trong do: Pxy la cross-PSD, Gx1x1 va Gx2x2 la auto-PSD cua 2 kenh
%
function delay = gccSCOT(Pxy, Gx1x1, Gx2x2, N)

% Tinh tuong quan cheo sau khi loc bang bo loc SCOT
Scotcorrelation = fftshift(ifft(Pxy ./ sqrt(Gx1x1 .* Gx2x2)));

% Tim vi tri cuc dai
[~, Scottime] = max(Scotcorrelation);
Scotestime = abs(N/2 - Scottime + 1);

% Noi suy Parabola
delay = Scotestime - 0.5 * (Scotcorrelation(Scottime+1) - Scotcorrelation(Scottime-1)) / ...
        (Scotcorrelation(Scottime+1) - 2*Scotcorrelation(Scottime) + Scotcorrelation(Scottime-1));

end

