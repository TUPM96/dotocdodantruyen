% Phuong phap 4: Eckart Filter
% - Giam nhieu bang bo loc theo mo hinh tin hieu va nhieu
% - Tang do chinh xac trong moi truong SNR thap

function [D, bias, Var, ecart_type, EQM] = method_eckart(Pxy, Gss, Gn1n1, Gn2n2, N, delai_attendu)
    Eckartcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gn1n1 .* Gn2n2)));
    [~, idx] = max(Eckartcorrelation);
    est = abs(N/2 - idx + 1);
    D = est - 0.5*(Eckartcorrelation(idx+1)-Eckartcorrelation(idx-1)) / ...
        (Eckartcorrelation(idx+1)-2*Eckartcorrelation(idx)+Eckartcorrelation(idx-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
