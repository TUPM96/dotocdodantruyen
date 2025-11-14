% ==============================================================================
% TEN FILE: plotRMSEComparison.m
% CHUC NANG: Tao bieu do cot so sanh RMSE giua cac phuong phap
% MODULE: visualization
% ==============================================================================
%
% Mo ta: Tao bieu do cot nhom de so sanh truc quan RMSE cua cac phuong phap
%        Moi nhom cot tuong ung voi mot muc SNR
%        Moi cot trong nhom tuong ung voi mot phuong phap GCC
%        De nhan biet nhanh phuong phap nao tot nhat o moi muc SNR
%
% Dinh dang bieu do:
% - Truc X: Cac muc SNR (0, 10, 20 dB)
% - Truc Y: RMSE (don vi: mau)
% - Cot thap hon: Phuong phap tot hon
%
function plotRMSEComparison(results, SNR_values, method_names, save_path)

% Thiet lap duong dan luu file
% Neu khong chi dinh, khong luu file
if nargin < 4
    save_path = '';
end

% Trich xuat gia tri RMSE
% Tao ma tran chua RMSE cua tat ca phuong phap o tat ca SNR
n_methods = length(method_names);
n_SNR = length(SNR_values);

rmse_matrix = zeros(n_methods, n_SNR);

% Lay RMSE tu ket qua
for i = 1:n_methods
    for j = 1:n_SNR
        rmse_matrix(i, j) = results{i, j}.rmse;
    end
end

% Tao cua so hinh
% Tao cua so kich thuoc 1000x600 pixel
fig = figure('Position', [100, 100, 1000, 600]);

% Ve bieu do cot nhom
% Chuyen vi ma tran (rmse_matrix') de co dinh dang dung cho bar()
% Moi nhom cot la mot muc SNR, moi cot la mot phuong phap
bar(SNR_values, rmse_matrix');
xlabel('SNR (dB)', 'FontWeight', 'bold', 'FontSize', 12);
ylabel('RMSE (samples)', 'FontWeight', 'bold', 'FontSize', 12);
title('RMSE Comparison of GCC Methods', 'FontWeight', 'bold', 'FontSize', 14);
legend(method_names, 'Location', 'best');
grid on;
set(gca, 'XTickLabel', arrayfun(@num2str, SNR_values, 'UniformOutput', false));

% Luu hinh neu duoc yeu cau
% Luu file .fig va .png
if ~isempty(save_path)
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    saveas(fig, fullfile(save_path, 'rmse_comparison.fig'));
    saveas(fig, fullfile(save_path, 'rmse_comparison.png'));
end

end

