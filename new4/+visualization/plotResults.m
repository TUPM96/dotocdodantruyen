% ==============================================================================
% TEN FILE: plotResults.m
% CHUC NANG: Tao cac bieu do ket qua
% MODULE: visualization
% ==============================================================================
%
% Mo ta: Tao 12 bieu do cu (6 ecart_type + 6 EQM) va cac bieu do so sanh RMSE
%
function plotResults(ecart_type, ecart_type_Roth, ecart_type_scot, ecart_type_phat, ...
                     ecart_type_Eckart, ecart_type_ml, EQM, EQM_Roth, EQM_scot, ...
                     EQM_phat, EQM_Eckart, EQM_ml, SNR)

% ============================================================================
% PHAN 1: 12 BIEU DO CU (6 ecart_type + 6 EQM)
% ============================================================================

% Bieu do 1: Do lech chuan - CC_time
figure;
bar(ecart_type, 'DisplayName', 'ecart_type', 'YDataSource', 'ecart_type');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
legend('CC');

% Bieu do 2: Do lech chuan - ECKART
figure;
bar(ecart_type_Eckart, 'DisplayName', 'ecart_type_Eckart', 'YDataSource', 'ecart_type_Eckart');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
title('Methode : "Filtre d''Eckart"');

% Bieu do 3: Do lech chuan - ROTH
figure;
bar(ecart_type_Roth, 'DisplayName', 'ecart_type_Roth', 'YDataSource', 'ecart_type_Roth');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
title('Methode: "Roth"');

% Bieu do 4: Do lech chuan - HT
figure;
bar(ecart_type_ml, 'DisplayName', 'ecart_type_Roth', 'YDataSource', 'ecart_type_Roth');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
title('Methode : "HT"');

% Bieu do 5: Do lech chuan - PHAT
figure;
bar(ecart_type_phat, 'DisplayName', 'ecart_type_phat', 'YDataSource', 'ecart_type_phat');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
title('Methode : "PHAT"');

% Bieu do 6: Do lech chuan - SCOT
figure;
bar(ecart_type_scot, 'DisplayName', 'ecart_type_scot', 'YDataSource', 'ecart_type_scot');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('Ecart-type en echantillon');
xlabel('RSB en dB');
title('Methode : "SCOT"');

% Bieu do 7: RMSE - CC_time
figure;
bar(EQM, 'DisplayName', 'EQM', 'YDataSource', 'EQM');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "Correlation simple"');

% Bieu do 8: RMSE - ECKART
figure;
bar(EQM_Eckart, 'DisplayName', 'EQM_Eckart', 'YDataSource', 'EQM_Eckart');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "Filtre d''Eckart"');

% Bieu do 9: RMSE - ROTH
figure;
bar(EQM_Roth, 'DisplayName', 'EQM_Roth', 'YDataSource', 'EQM_Roth');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "Roth"');

% Bieu do 10: RMSE - HT
figure;
bar(EQM_ml, 'DisplayName', 'EQM_ml', 'YDataSource', 'EQM_ml');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "HT"');

% Bieu do 11: RMSE - SCOT
figure;
bar(EQM_scot, 'DisplayName', 'EQM_scot', 'YDataSource', 'EQM_scot');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "SCOT"');

% Bieu do 12: RMSE - PHAT
figure;
bar(EQM_phat, 'DisplayName', 'EQM_phat', 'YDataSource', 'EQM_phat');
figure(gcf);
set(gca, 'XTick', 1:length(SNR));
set(gca, 'XTickLabel', arrayfun(@num2str, SNR, 'UniformOutput', false));
ylabel('EQM en echantillon');
xlabel('RSB en dB');
title('Methode : "PHAT"');

% ============================================================================
% PHAN 2: BIEU DO SO SANH TONG HOP - LAY KET QUA TU CAC CHART CU
% ============================================================================
% Tao 1 chart lon so sanh tat ca 6 phuong phap
% Su dung du lieu tu cac chart cu (ecart_type va EQM)

% Bieu do 1: So sanh Do lech chuan (ecart_type) cua 6 phuong phap
figure;
% Tao ma tran du lieu: hang = phuong phap, cot = SNR
ecart_type_matrix = [ecart_type'; ecart_type_Roth'; ecart_type_scot'; ...
                     ecart_type_Eckart'; ecart_type_phat'; ecart_type_ml'];
% Tao grouped bar chart
bar(ecart_type_matrix');
set(gca, 'XTickLabel', arrayfun(@(s) sprintf('%d dB', s), SNR, 'UniformOutput', false));
xlabel('SNR (dB)', 'FontWeight', 'bold', 'FontSize', 12);
ylabel('Do lech chuan (echantillon)', 'FontWeight', 'bold', 'FontSize', 12);
title('So sanh Do lech chuan cua 6 phuong phap theo SNR', 'FontWeight', 'bold', 'FontSize', 14);
legend('CC_time', 'ROTH', 'SCOT', 'ECKART', 'PHAT', 'HT', 'Location', 'best', 'FontSize', 10);
grid on;
set(gcf, 'Position', [100, 100, 800, 600]);  % Kich thuoc lon hon

% Bieu do 2: So sanh EQM (RMSE) cua 6 phuong phap - Grouped bar chart
figure;
% Tao ma tran du lieu: hang = phuong phap, cot = SNR
EQM_matrix = [EQM'; EQM_Roth'; EQM_scot'; EQM_Eckart'; EQM_phat'; EQM_ml'];
% Tao grouped bar chart
bar(EQM_matrix');
set(gca, 'XTickLabel', arrayfun(@(s) sprintf('%d dB', s), SNR, 'UniformOutput', false));
xlabel('SNR (dB)', 'FontWeight', 'bold', 'FontSize', 12);
ylabel('EQM (RMSE) (echantillon)', 'FontWeight', 'bold', 'FontSize', 12);
title('So sanh EQM cua 6 phuong phap theo SNR', 'FontWeight', 'bold', 'FontSize', 14);
legend('CC_time', 'ROTH', 'SCOT', 'ECKART', 'PHAT', 'HT', 'Location', 'best', 'FontSize', 10);
grid on;
set(gcf, 'Position', [100, 100, 900, 650]);  % Kich thuoc lon hon

end

