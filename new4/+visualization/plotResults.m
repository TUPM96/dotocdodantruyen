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
% PHAN 2: BIEU DO SO SANH RMSE
% ============================================================================

% Bieu do so sanh RMSE - Bar chart tai moi muc SNR
for ns = 1:length(SNR)
    figure;
    x = [1:6];
    z = [EQM(ns), EQM_Roth(ns), EQM_scot(ns), EQM_Eckart(ns), EQM_phat(ns), EQM_ml(ns)];
    bar(x, z);
    set(gca, 'XTick', 1:6);
    set(gca, 'XTickLabel', {'CC_time'; 'ROTH'; 'SCOT'; 'ECKART'; 'PHAT'; 'HT'});
    ylabel('RMSE (echantillon)');
    xlabel('Phuong phap');
    title(sprintf('So sanh RMSE cua cac phuong phap tai SNR = %d dB', SNR(ns)));
    grid on;
end

% Bieu do so sanh RMSE - Line plot theo SNR
figure;
hold on;
plot(SNR, EQM, '-o', 'LineWidth', 2, 'DisplayName', 'CC_time');
plot(SNR, EQM_Roth, '-o', 'LineWidth', 2, 'DisplayName', 'ROTH');
plot(SNR, EQM_scot, '-o', 'LineWidth', 2, 'DisplayName', 'SCOT');
plot(SNR, EQM_phat, '-o', 'LineWidth', 2, 'DisplayName', 'PHAT');
plot(SNR, EQM_Eckart, '-o', 'LineWidth', 2, 'DisplayName', 'ECKART');
plot(SNR, EQM_ml, '-o', 'LineWidth', 2, 'DisplayName', 'HT');
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('RMSE (echantillon)', 'FontWeight', 'bold');
title('So sanh RMSE cua cac phuong phap theo SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Bieu do so sanh RMSE tong hop - Bar chart
figure;
x = 1:6;
z_all = [EQM(end), EQM_Roth(end), EQM_scot(end), EQM_Eckart(end), EQM_phat(end), EQM_ml(end)];
bar(x, z_all, 'FaceColor', [0.2 0.6 0.8]);
set(gca, 'XTick', 1:6);
set(gca, 'XTickLabel', {'CC_time'; 'ROTH'; 'SCOT'; 'ECKART'; 'PHAT'; 'HT'});
ylabel('RMSE (echantillon)', 'FontWeight', 'bold');
xlabel('Phuong phap', 'FontWeight', 'bold');
title('So sanh RMSE tong hop cua cac phuong phap tai SNR = 20 dB', 'FontWeight', 'bold');
grid on;

% Bieu do so sanh RMSE - Bar chart 3D
figure;
RMSE_matrix = [EQM'; EQM_Roth'; EQM_scot'; EQM_Eckart'; EQM_phat'; EQM_ml'];
bar3(RMSE_matrix);
set(gca, 'XTickLabel', {'0 dB'; '10 dB'; '20 dB'});
set(gca, 'YTickLabel', {'CC_time'; 'ROTH'; 'SCOT'; 'ECKART'; 'PHAT'; 'HT'});
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Phuong phap', 'FontWeight', 'bold');
zlabel('RMSE (echantillon)', 'FontWeight', 'bold');
title('So sanh RMSE 3D cua cac phuong phap theo SNR', 'FontWeight', 'bold');
grid on;

% Bieu do so sanh RMSE - Grouped bar chart
figure;
x = 1:length(SNR);
y1 = EQM';
y2 = EQM_Roth';
y3 = EQM_scot';
y4 = EQM_Eckart';
y5 = EQM_phat';
y6 = EQM_ml';
bar([y1; y2; y3; y4; y5; y6]');
set(gca, 'XTickLabel', {'0 dB'; '10 dB'; '20 dB'});
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('RMSE (echantillon)', 'FontWeight', 'bold');
title('So sanh RMSE cua cac phuong phap theo SNR (Grouped Bar)', 'FontWeight', 'bold');
legend('CC_time', 'ROTH', 'SCOT', 'ECKART', 'PHAT', 'HT', 'Location', 'best');
grid on;

end

