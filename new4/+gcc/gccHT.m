% ==============================================================================
% TEN FILE: gccHT.m
% CHUC NANG: Phuong phap HT - Hannan-Thomson (Maximum Likelihood)
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Phuong phap GCC su dung bo loc Hannan-Thomson
%        Phuong phap Maximum Likelihood, toi uu nhat
%
% Cong thuc: R_ht = IFFT(Pxy * Gss / (Gss * (Gn1n1 + Gn2n2) + Gn1n1 * Gn2n2))
%            Trong do: Pxy la cross-PSD, Gss la pho tin hieu sach
%                      Gn1n1 va Gn2n2 la phuong sai nhieu cua 2 kenh
%
function delay = gccHT(Pxy, Gss, Gn1n1, Gn2n2, N)

% Tinh tuong quan cheo sau khi loc bang bo loc HT
mlcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2)));

% Tim vi tri cuc dai
[~, mltime] = max(mlcorrelation);
mlestime = abs(N/2 - mltime + 1);

% Noi suy Parabola
delay = mlestime - 0.5 * (mlcorrelation(mltime+1) - mlcorrelation(mltime-1)) / ...
        (mlcorrelation(mltime+1) - 2*mlcorrelation(mltime) + mlcorrelation(mltime-1));

end

