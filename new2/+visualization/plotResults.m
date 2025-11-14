% ==============================================================================
% TEN FILE: plotResults.m
% CHUC NANG: Tao cac bieu do tong hop ket qua so sanh cac phuong phap
% MODULE: visualization
% ==============================================================================
%
% Mo ta: Tao cac bieu do so sanh hieu suat cac phuong phap GCC
%        Hien thi do lech chuan (std) va sai so binh phuong trung binh (RMSE)
%        theo cac muc SNR khac nhau
%
function plotResults(D, Dgcc, DRoth, DScot, Dphat, DEckart, Dml, SNR, delai_attendu, Nm)

% Tinh cac chi so thong ke cho moi phuong phap
n_SNR = length(SNR);

% Khoi tao cac ma tran luu ket qua
ecart_type = zeros(n_SNR, 1);
ecart_type_gcc = zeros(n_SNR, 1);
ecart_type_Roth = zeros(n_SNR, 1);
ecart_type_scot = zeros(n_SNR, 1);
ecart_type_phat = zeros(n_SNR, 1);
ecart_type_Eckart = zeros(n_SNR, 1);
ecart_type_ml = zeros(n_SNR, 1);

EQM = zeros(n_SNR, 1);
EQM_gcc = zeros(n_SNR, 1);
EQM_Roth = zeros(n_SNR, 1);
EQM_scot = zeros(n_SNR, 1);
EQM_phat = zeros(n_SNR, 1);
EQM_Eckart = zeros(n_SNR, 1);
EQM_ml = zeros(n_SNR, 1);

for ns = 1:n_SNR
    % Tinh do lech chuan cho moi phuong phap
    ecart_type(ns) = sqrt(var(D(:, ns)));
    ecart_type_gcc(ns) = sqrt(var(Dgcc(:, ns)));
    ecart_type_Roth(ns) = sqrt(var(DRoth(:, ns)));
    ecart_type_scot(ns) = sqrt(var(DScot(:, ns)));
    ecart_type_phat(ns) = sqrt(var(Dphat(:, ns)));
    ecart_type_Eckart(ns) = sqrt(var(DEckart(:, ns)));
    ecart_type_ml(ns) = sqrt(var(Dml(:, ns)));
    
    % Tinh RMSE cho moi phuong phap
    bias_cc = mean(D(:, ns)) - delai_attendu;
    EQM(ns) = bias_cc^2 + var(D(:, ns));
    
    bias_gcc = mean(Dgcc(:, ns)) - delai_attendu;
    EQM_gcc(ns) = bias_gcc^2 + var(Dgcc(:, ns));
    
    bias_Roth = mean(DRoth(:, ns)) - delai_attendu;
    EQM_Roth(ns) = bias_Roth^2 + var(DRoth(:, ns));
    
    bias_scot = mean(DScot(:, ns)) - delai_attendu;
    EQM_scot(ns) = bias_scot^2 + var(DScot(:, ns));
    
    bias_phat = mean(Dphat(:, ns)) - delai_attendu;
    EQM_phat(ns) = bias_phat^2 + var(Dphat(:, ns));
    
    bias_Eckart = mean(DEckart(:, ns)) - delai_attendu;
    EQM_Eckart(ns) = bias_Eckart^2 + var(DEckart(:, ns));
    
    bias_ml = mean(Dml(:, ns)) - delai_attendu;
    EQM_ml(ns) = bias_ml^2 + var(Dml(:, ns));
end

% Bieu do 1: Do lech chuan (Standard Deviation) theo SNR
figure('Position', [100, 100, 1400, 900]);

% Bieu do do lech chuan - CC_time
subplot(2, 4, 1);
bar(ecart_type);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Do lech chuan (mau)');
xlabel('SNR (dB)');
title('Phuong phap: CC_time');
grid on;

% Bieu do do lech chuan - ECKART
subplot(2, 4, 2);
bar(ecart_type_Eckart);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Do lech chuan (mau)');
xlabel('SNR (dB)');
title('Phuong phap: ECKART');
grid on;

% Bieu do do lech chuan - ROTH
subplot(2, 4, 3);
bar(ecart_type_Roth);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Do lech chuan (mau)');
xlabel('SNR (dB)');
title('Phuong phap: ROTH');
grid on;

% Bieu do do lech chuan - HT
subplot(2, 4, 4);
bar(ecart_type_ml);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Do lech chuan (mau)');
xlabel('SNR (dB)');
title('Phuong phap: HT');
grid on;

% Bieu do do lech chuan - PHAT
subplot(2, 4, 5);
bar(ecart_type_phat);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Do lech chuan (mau)');
xlabel('SNR (dB)');
title('Phuong phap: PHAT');
grid on;

% Bieu do RMSE - CC_time
subplot(2, 4, 6);
bar(EQM);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('RMSE (mau)');
xlabel('SNR (dB)');
title('Phuong phap: CC_time');
grid on;

% Bieu do RMSE - ECKART
subplot(2, 4, 7);
bar(EQM_Eckart);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('RMSE (mau)');
xlabel('SNR (dB)');
title('Phuong phap: ECKART');
grid on;

% Bieu do RMSE - ROTH
subplot(2, 4, 8);
bar(EQM_Roth);
set(gca, 'XTick', 1:n_SNR);
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('RMSE (mau)');
xlabel('SNR (dB)');
title('Phuong phap: ROTH');
grid on;

% Bieu do 2: So sanh RMSE cua tat ca phuong phap
figure('Position', [100, 100, 1200, 600]);

subplot(1, 2, 1);
hold on;
plot(SNR, sqrt(EQM), '-o', 'LineWidth', 2, 'DisplayName', 'CC_time');
plot(SNR, sqrt(EQM_gcc), '-o', 'LineWidth', 2, 'DisplayName', 'GCC');
plot(SNR, sqrt(EQM_Roth), '-o', 'LineWidth', 2, 'DisplayName', 'ROTH');
plot(SNR, sqrt(EQM_scot), '-o', 'LineWidth', 2, 'DisplayName', 'SCOT');
plot(SNR, sqrt(EQM_phat), '-o', 'LineWidth', 2, 'DisplayName', 'PHAT');
plot(SNR, sqrt(EQM_Eckart), '-o', 'LineWidth', 2, 'DisplayName', 'ECKART');
plot(SNR, sqrt(EQM_ml), '-o', 'LineWidth', 2, 'DisplayName', 'HT');
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('RMSE (samples)', 'FontWeight', 'bold');
title('RMSE Comparison of All Methods', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

subplot(1, 2, 2);
hold on;
plot(SNR, ecart_type, '-o', 'LineWidth', 2, 'DisplayName', 'CC_time');
plot(SNR, ecart_type_gcc, '-o', 'LineWidth', 2, 'DisplayName', 'GCC');
plot(SNR, ecart_type_Roth, '-o', 'LineWidth', 2, 'DisplayName', 'ROTH');
plot(SNR, ecart_type_scot, '-o', 'LineWidth', 2, 'DisplayName', 'SCOT');
plot(SNR, ecart_type_phat, '-o', 'LineWidth', 2, 'DisplayName', 'PHAT');
plot(SNR, ecart_type_Eckart, '-o', 'LineWidth', 2, 'DisplayName', 'ECKART');
plot(SNR, ecart_type_ml, '-o', 'LineWidth', 2, 'DisplayName', 'HT');
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Standard Deviation (samples)', 'FontWeight', 'bold');
title('Standard Deviation Comparison', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

end

