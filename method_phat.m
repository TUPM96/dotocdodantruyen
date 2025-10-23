% Phuong phap 5: PHAT (Phase Transform)
% - Chuan hoa pha cua ham chuyen vi
% - Toi uu trong moi truong nhieu trang

function [D, bias, Var, ecart_type, EQM] = method_phat(Pxy, Gss, N, delai_attendu)
    phatcorrelation = fftshift(ifft(Pxy ./ (Gss + 0.1)));
    [~, idx] = max(phatcorrelation);
    est = abs(N/2 - idx + 1);
    D = est - 0.5*(phatcorrelation(idx+1)-phatcorrelation(idx-1)) / ...
        (phatcorrelation(idx+1)-2*phatcorrelation(idx)+phatcorrelation(idx-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
