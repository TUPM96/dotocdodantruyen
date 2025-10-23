% Phuong phap 3: SCOT (Smoothed Coherence Transform)
% - Can bang bien do theo ca hai kenh
% - Tang on dinh khi SNR thap

function [D, bias, Var, ecart_type, EQM] = method_scot(Pxy, Gx1x1, Gx2x2, N, delai_attendu)
    Scotcorrelation = fftshift(ifft(Pxy ./ sqrt(Gx1x1 .* Gx2x2)));
    [~, idx] = max(Scotcorrelation);
    est = abs(N/2 - idx + 1);
    D = est - 0.5*(Scotcorrelation(idx+1)-Scotcorrelation(idx-1)) / ...
        (Scotcorrelation(idx+1)-2*Scotcorrelation(idx)+Scotcorrelation(idx-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
