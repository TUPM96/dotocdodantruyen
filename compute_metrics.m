%% ===================== TINH TOAN CAC CHI SO =====================
% Tinh bias, variance, std, mse cho tat ca phuong phap

function [bias, Var, ecart_type, EQM] = compute_metrics(D, delai_attendu)
    bias = mean(D) - delai_attendu;
    Var  = var(D);
    ecart_type = sqrt(Var);
    EQM = bias^2 + Var;
end
