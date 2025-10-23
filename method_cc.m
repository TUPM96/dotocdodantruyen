% Phuong phap 1: Cross-Correlation (CC)
% - Tinh tuong quan cheo trong mien thoi gian
% - Xac dinh vi tri dinh toi da de tinh do tre
% - Su dung noi suy parabolique de nang do chinh xac

function [D, bias, Var, ecart_type, EQM] = method_cc(s1_noise, s2_noise, N, delai_attendu, SNR)
    [Rx1x2, lag1] = xcorr(s1_noise, s2_noise, length(s1_noise)/2);
    [~, cctime] = max(Rx1x2);
    ccestime = abs(N/2 - cctime + 1);
    D = ccestime - 0.5*(Rx1x2(cctime+1)-Rx1x2(cctime-1)) / ...
        (Rx1x2(cctime+1)-2*Rx1x2(cctime)+Rx1x2(cctime-1));
    bias = mean(D) - delai_attendu;
    Var = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
