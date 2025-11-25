% Script de doc ket qua tu gcc.mat va xuat vao thu muc result
clear; close all;

% Doc ket qua tu file gcc.mat
if exist('gcc.mat', 'file')
    load('gcc.mat');
    fprintf('Da doc ket qua tu file gcc.mat\n');
else
    fprintf('Khong tim thay file gcc.mat. Vui long chay main.m truoc.\n');
    return;
end

% Kiem tra cac bien can thiet
if ~exist('EQM', 'var') || ~exist('SNR', 'var')
    fprintf('Khong tim thay bien EQM hoac SNR trong file gcc.mat\n');
    return;
end

% Tao thu muc result neu chua co
results_dir = 'result';
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
    fprintf('Da tao thu muc: %s\n', results_dir);
end

% Goi ham exportResults de luu ket qua
fprintf('\nDang xuat ket qua vao thu muc result...\n');
export.exportResults(ecart_type, ecart_type_Roth, ecart_type_scot, ecart_type_phat, ...
                     ecart_type_Eckart, ecart_type_ml, EQM, EQM_Roth, EQM_scot, ...
                     EQM_phat, EQM_Eckart, EQM_ml, SNR, ...
                     bias, bias_Roth, bias_scot, bias_phat, bias_Eckart, bias_ml, ...
                     Var, Var_Roth, Var_scot, Var_phat, Var_Eckart, Var_ml, ...
                     delai_estime, delai_estime_Roth, delai_estime_scot, ...
                     delai_estime_phat, delai_estime_Eckart, delai_estime_ml);

fprintf('\nHoan thanh! Ket qua da duoc luu vao thu muc result/\n');

