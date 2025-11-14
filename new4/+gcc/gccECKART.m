% ==============================================================================
% TEN FILE: gccECKART.m
% CHUC NANG: Phuong phap ECKART - Bo loc Eckart
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC su dung bo loc Eckart
%        Toi uu SNR, su dung pho tin hieu sach va phuong sai nhieu
%
% Cong thuc: R_eckart = IFFT(Pxy * Gss / (Gn1n1 * Gn2n2))
%            Trong do: Pxy la cross-PSD, Gss la pho tin hieu sach
%                      Gn1n1 va Gn2n2 la phuong sai nhieu cua 2 kenh
%
function delay = gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N)

% Tinh tuong quan cheo sau khi loc bang bo loc Eckart
Eckartcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gn1n1 .* Gn2n2)));

% Tim vi tri cuc dai
[~, Eckarttime] = max(Eckartcorrelation);
Eckartestime = abs(N/2 - Eckarttime + 1);

% Noi suy Parabola
delay = Eckartestime - 0.5 * (Eckartcorrelation(Eckarttime+1) - Eckartcorrelation(Eckarttime-1)) / ...
        (Eckartcorrelation(Eckarttime+1) - 2*Eckartcorrelation(Eckarttime) + Eckartcorrelation(Eckarttime-1));

end

