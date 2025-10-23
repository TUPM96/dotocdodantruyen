% Phuong phap 6: Hannan Thompson (HT) hay Maximum Likelihood
% - Su dung uoc luong ML de toi uu tinh sai so
% - Do chinh xac cao nhat trong cac phuong phap GCC

function [D, bias, Var, ecart_type, EQM] = method_ht(Pxy, Gss, Gn1n1, Gn2n2, N, delai_attendu)
    mlcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gss.*(Gn1n1 + Gn2n2) + Gn1n1.*Gn2n2)));
    [~, idx] = max(mlcorrelation);
    est = abs(N/2 - idx + 1);
    D = est - 0.5*(mlcorrelation(idx+1)-mlcorrelation(idx-1)) / ...
        (mlcorrelation(idx+1)-2*mlcorrelation(idx)+mlcorrelation(idx-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
