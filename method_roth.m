% Phuong phap 2: Roth Filter
% - Su dung bo loc Roth trong mien tan so
% - Giam anh huong cua nhieu tren cac thanh phan tan so thap

function [D, bias, Var, ecart_type, EQM] = method_roth(Pxy, Gx1x1, N, delai_attendu)
    Rothcorrelation = fftshift(ifft(Pxy ./ Gx1x1));
    [~, idx] = max(Rothcorrelation);
    est = abs(N/2 - idx + 1);
    D = est - 0.5*(Rothcorrelation(idx+1)-Rothcorrelation(idx-1)) / ...
        (Rothcorrelation(idx+1)-2*Rothcorrelation(idx)+Rothcorrelation(idx-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
