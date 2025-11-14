function plotRMSEComparison(results, SNR_values, method_names, save_path)
% PLOTRMSECOMPARISON Create bar chart comparing RMSE across methods
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tao bieu do cot (bar chart) so sanh RMSE giua cac phuong phap
%
% Giai thich chi tiet:
% - Tao bieu do cot nhom de so sanh truc quan RMSE cua cac phuong phap
% - Moi nhom cot tuong ung voi mot muc SNR
% - Moi cot trong nhom tuong ung voi mot phuong phap GCC
% - De nhan biet nhanh phuong phap nao tot nhat o moi muc SNR
%
% Dinh dang bieu do:
% - Truc X: Cac muc SNR (0, 10, 20 dB)
% - Truc Y: RMSE (don vi: mau)
% - Cot thap hon: Phuong phap tot hon
%
% SYNTAX:
%   plotRMSEComparison(results, SNR_values, method_names)
%   plotRMSEComparison(results, SNR_values, method_names, save_path)
%
% INPUTS:
%   results      - Cell array of results (Ma tran ket qua, n_methods x n_SNR)
%   SNR_values   - Vector of SNR values in dB (Cac muc SNR)
%   method_names - Cell array of method names (Ten cac phuong phap)
%   save_path    - (Optional) Directory to save figure (Thu muc luu hinh)
%
% DESCRIPTION:
%   Creates grouped bar chart comparing RMSE of all methods at each SNR.

%% BUOC 1: Thiet lap duong dan luu file
% Giai thich: Neu khong chi dinh, khong luu file
if nargin < 4
    save_path = '';
end

%% BUOC 2: Trich xuat gia tri RMSE
% Giai thich: Tao ma tran chua RMSE cua tat ca phuong phap o tat ca SNR
n_methods = length(method_names);
n_SNR = length(SNR_values);

rmse_matrix = zeros(n_methods, n_SNR);

% Lay RMSE tu ket qua
for i = 1:n_methods
    for j = 1:n_SNR
        rmse_matrix(i, j) = results{i, j}.rmse;
    end
end

%% BUOC 3: Tao cua so hinh
% Giai thich: Tao cua so kich thuoc 1000x600 pixel
fig = figure('Position', [100, 100, 1000, 600]);

%% BUOC 4: Ve bieu do cot nhom
% Giai thich:
% - Chuyen vi ma tran (rmse_matrix') de co dinh dang dung cho bar()
% - Moi nhom cot la mot muc SNR, moi cot la mot phuong phap
bar(SNR_values, rmse_matrix');
xlabel('SNR (dB)', 'FontWeight', 'bold', 'FontSize', 12);
ylabel('RMSE (samples)', 'FontWeight', 'bold', 'FontSize', 12);
title('RMSE Comparison of GCC Methods', 'FontWeight', 'bold', 'FontSize', 14);
legend(method_names, 'Location', 'best');
grid on;
% Thiet lap nhan truc X de hien thi chinh xac gia tri SNR
set(gca, 'XTickLabel', arrayfun(@num2str, SNR_values, 'UniformOutput', false));

%% BUOC 5: Luu hinh neu duoc yeu cau
% Giai thich: Luu file .fig va .png
if ~isempty(save_path)
    % Tao thu muc neu chua ton tai
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    % Luu file .fig
    saveas(fig, fullfile(save_path, 'rmse_comparison.fig'));
    % Luu file .png
    saveas(fig, fullfile(save_path, 'rmse_comparison.png'));
end

end
