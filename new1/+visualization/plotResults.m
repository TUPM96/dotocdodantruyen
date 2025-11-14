% ==============================================================================
% TEN FILE: plotResults.m
% CHUC NANG: Tao cac bieu do tong hop ket qua so sanh cac phuong phap
% MODULE: visualization
% ==============================================================================
%
% Mo ta: Tao 4 bieu do phu (subplots) hien thi cac chi so thong ke theo SNR
%        Moi bieu do the hien su phu thuoc cua mot chi so vao SNR
%        De so sanh truc quan hieu suat cac phuong phap o cac muc SNR khac nhau
%
% Cac bieu do duoc tao:
% 1. RMSE vs SNR: Chi so quan trong nhat, the hien do chinh xac tong the
% 2. Bias vs SNR: The hien do lech he thong
% 3. Variance vs SNR: The hien do phan tan (khong on dinh)
% 4. Std vs SNR: The hien do lech chuan
%
function plotResults(results, SNR_values, method_names, save_path)

% Thiet lap duong dan luu file (neu co)
% Neu khong chi dinh, khong luu file
if nargin < 4
    save_path = '';
end

% Trich xuat cac chi so thong ke
% Tao cac ma tran chua du lieu de ve bieu do
% Moi ma tran co kich thuoc (n_methods x n_SNR)
n_methods = length(method_names);
n_SNR = length(SNR_values);

% Khoi tao cac ma tran rong
rmse_matrix = zeros(n_methods, n_SNR);
bias_matrix = zeros(n_methods, n_SNR);
var_matrix = zeros(n_methods, n_SNR);
std_matrix = zeros(n_methods, n_SNR);

% Trich xuat du lieu tu ket qua
for i = 1:n_methods
    for j = 1:n_SNR
        stats = results{i, j};
        rmse_matrix(i, j) = stats.rmse;
        bias_matrix(i, j) = stats.bias;
        var_matrix(i, j) = stats.variance;
        std_matrix(i, j) = stats.std;
    end
end

% Tao cua so hinh
% Tao cua so lon 1200x800 pixel cho 4 bieu do phu
fig = figure('Position', [100, 100, 1200, 800]);

% Ve bieu do RMSE vs SNR
% RMSE la chi so quan trong nhat, the hien do chinh xac tong quat
subplot(2, 2, 1);
hold on;
for i = 1:n_methods
    plot(SNR_values, rmse_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('RMSE (samples)', 'FontWeight', 'bold');
title('Root Mean Square Error vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Ve bieu do Bias vs SNR
% Bias the hien do lech he thong, nen gan 0
subplot(2, 2, 2);
hold on;
for i = 1:n_methods
    plot(SNR_values, bias_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Bias (samples)', 'FontWeight', 'bold');
title('Bias vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Ve bieu do Variance vs SNR
% Variance the hien do phan tan, khong on dinh cua uoc luong
subplot(2, 2, 3);
hold on;
for i = 1:n_methods
    plot(SNR_values, var_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Variance (samples^2)', 'FontWeight', 'bold');
title('Variance vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Ve bieu do Standard Deviation vs SNR
% Std la can bac hai cua variance, de hieu hon vi cung don vi
subplot(2, 2, 4);
hold on;
for i = 1:n_methods
    plot(SNR_values, std_matrix(i, :), '-o', 'LineWidth', 2, 'DisplayName', method_names{i});
end
hold off;
xlabel('SNR (dB)', 'FontWeight', 'bold');
ylabel('Std (samples)', 'FontWeight', 'bold');
title('Standard Deviation vs SNR', 'FontWeight', 'bold');
legend('Location', 'best');
grid on;

% Luu hinh neu duoc yeu cau
% Luu hinh duoi 2 dinh dang .fig (MATLAB) va .png (anh)
if ~isempty(save_path)
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    saveas(fig, fullfile(save_path, 'gcc_comparison.fig'));
    saveas(fig, fullfile(save_path, 'gcc_comparison.png'));
end

end

