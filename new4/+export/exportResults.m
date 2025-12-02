% ==============================================================================
% TEN FILE: exportResults.m
% CHUC NANG: Luu va xuat du lieu ket qua ra file
% MODULE: export
% ==============================================================================
%
% Mo ta: Luu tat ca ket qua thong ke (ecart_type, EQM, bias, variance) ra file
%        Hỗ trợ các định dạng: .mat, .txt, .xlsx
%
function exportResults(ecart_type, ecart_type_Roth, ecart_type_scot, ecart_type_phat, ...
                       ecart_type_Eckart, ecart_type_ml, EQM, EQM_Roth, EQM_scot, ...
                       EQM_phat, EQM_Eckart, EQM_ml, SNR, ...
                       bias, bias_Roth, bias_scot, bias_phat, bias_Eckart, bias_ml, ...
                       Var, Var_Roth, Var_scot, Var_phat, Var_Eckart, Var_ml, ...
                       delai_estime, delai_estime_Roth, delai_estime_scot, ...
                       delai_estime_phat, delai_estime_Eckart, delai_estime_ml)

% ============================================================================
% PHAN 1: TAO THU MUC RESULT NEU CHUA CO
% ============================================================================
results_dir = 'result';
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
    fprintf('Da tao thu muc: %s\n', results_dir);
end

% ============================================================================
% PHAN 2: TAO TEN FILE VOI THOI GIAN
% ============================================================================
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
base_filename = sprintf('ket_qua_MFCV_%s', timestamp);

% ============================================================================
% PHAN 3: LUU DU LIEU RA FILE .MAT
% ============================================================================
mat_filename = fullfile(results_dir, [base_filename, '.mat']);
save(mat_filename, ...
     'ecart_type', 'ecart_type_Roth', 'ecart_type_scot', 'ecart_type_phat', ...
     'ecart_type_Eckart', 'ecart_type_ml', ...
     'EQM', 'EQM_Roth', 'EQM_scot', 'EQM_phat', 'EQM_Eckart', 'EQM_ml', ...
     'SNR', 'bias', 'bias_Roth', 'bias_scot', 'bias_phat', 'bias_Eckart', 'bias_ml', ...
     'Var', 'Var_Roth', 'Var_scot', 'Var_phat', 'Var_Eckart', 'Var_ml', ...
     'delai_estime', 'delai_estime_Roth', 'delai_estime_scot', ...
     'delai_estime_phat', 'delai_estime_Eckart', 'delai_estime_ml');
fprintf('Da luu du lieu ra file: %s\n', mat_filename);

% ============================================================================
% PHAN 4: XUAT DU LIEU RA FILE .TXT (DANG BANG)
% ============================================================================
txt_filename = fullfile(results_dir, [base_filename, '.txt']);
fid = fopen(txt_filename, 'w');

% Ghi header
fprintf(fid, '================================================================================\n');
fprintf(fid, 'KET QUA MO PHONG UOC LUONG MFCV BANG 6 PHUONG PHAP GCC\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'Thoi gian: %s\n', datestr(now));
fprintf(fid, 'So muc SNR: %d\n', length(SNR));
fprintf(fid, 'Cac muc SNR: %s\n', mat2str(SNR));
fprintf(fid, '================================================================================\n\n');

% Ghi ket qua Do lech chuan (ecart_type)
fprintf(fid, '1. DO LECH CHUAN (ECART-TYPE) - ECHANTILLON\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf(fid, '--------------------------------------------------------------------------------\n');
for ns = 1:length(SNR)
    fprintf(fid, '%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(ns), ecart_type(ns), ecart_type_Roth(ns), ecart_type_scot(ns), ...
            ecart_type_phat(ns), ecart_type_Eckart(ns), ecart_type_ml(ns));
end
fprintf(fid, '\n');

% Ghi ket qua EQM (RMSE)
fprintf(fid, '2. EQM (RMSE) - ECHANTILLON\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf(fid, '--------------------------------------------------------------------------------\n');
for ns = 1:length(SNR)
    fprintf(fid, '%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(ns), EQM(ns), EQM_Roth(ns), EQM_scot(ns), ...
            EQM_phat(ns), EQM_Eckart(ns), EQM_ml(ns));
end
fprintf(fid, '\n');

% Ghi ket qua Bias
fprintf(fid, '3. BIAS - ECHANTILLON\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf(fid, '--------------------------------------------------------------------------------\n');
for ns = 1:length(SNR)
    fprintf(fid, '%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(ns), bias(ns), bias_Roth(ns), bias_scot(ns), ...
            bias_phat(ns), bias_Eckart(ns), bias_ml(ns));
end
fprintf(fid, '\n');

% Ghi ket qua Variance
fprintf(fid, '4. VARIANCE - ECHANTILLON^2\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf(fid, '--------------------------------------------------------------------------------\n');
for ns = 1:length(SNR)
    fprintf(fid, '%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(ns), Var(ns), Var_Roth(ns), Var_scot(ns), ...
            Var_phat(ns), Var_Eckart(ns), Var_ml(ns));
end
fprintf(fid, '\n');

% Ghi ket qua Do tre uoc luong
fprintf(fid, '5. DO TRE UOC LUONG (DELAI ESTIME) - ECHANTILLON\n');
fprintf(fid, '================================================================================\n');
fprintf(fid, 'SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf(fid, '--------------------------------------------------------------------------------\n');
for ns = 1:length(SNR)
    fprintf(fid, '%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(ns), delai_estime(ns), delai_estime_Roth(ns), delai_estime_scot(ns), ...
            delai_estime_phat(ns), delai_estime_Eckart(ns), delai_estime_ml(ns));
end
fprintf(fid, '\n');

fprintf(fid, '================================================================================\n');
fprintf(fid, 'KET THUC\n');
fprintf(fid, '================================================================================\n');

fclose(fid);
fprintf('Da xuat du lieu ra file: %s\n', txt_filename);

% ============================================================================
% PHAN 5: XUAT DU LIEU RA FILE .XLSX (EXCEL)
% ============================================================================
try
    xlsx_filename = fullfile(results_dir, [base_filename, '.xlsx']);
    
    % Xoa file cu neu ton tai
    if exist(xlsx_filename, 'file')
        delete(xlsx_filename);
    end
    
    % Tao bang du lieu cho Do lech chuan
    ecart_type_table = table(SNR', ecart_type', ecart_type_Roth', ecart_type_scot', ...
                             ecart_type_phat', ecart_type_Eckart', ecart_type_ml', ...
                             'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                             'PHAT', 'ECKART', 'HT'});
    writetable(ecart_type_table, xlsx_filename, 'Sheet', 'Do_lech_chuan', 'WriteRowNames', false);
    
    % Tao bang du lieu cho EQM
    EQM_table = table(SNR', EQM', EQM_Roth', EQM_scot', EQM_phat', ...
                      EQM_Eckart', EQM_ml', ...
                      'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                      'PHAT', 'ECKART', 'HT'});
    writetable(EQM_table, xlsx_filename, 'Sheet', 'EQM_RMSE', 'WriteRowNames', false);
    
    % Tao bang du lieu cho Bias
    bias_table = table(SNR', bias', bias_Roth', bias_scot', bias_phat', ...
                       bias_Eckart', bias_ml', ...
                       'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                       'PHAT', 'ECKART', 'HT'});
    writetable(bias_table, xlsx_filename, 'Sheet', 'Bias', 'WriteRowNames', false);
    
    % Tao bang du lieu cho Variance
    Var_table = table(SNR', Var', Var_Roth', Var_scot', Var_phat', ...
                      Var_Eckart', Var_ml', ...
                      'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                      'PHAT', 'ECKART', 'HT'});
    writetable(Var_table, xlsx_filename, 'Sheet', 'Variance', 'WriteRowNames', false);
    
    % Tao bang du lieu cho Do tre uoc luong
    delai_table = table(SNR', delai_estime', delai_estime_Roth', delai_estime_scot', ...
                        delai_estime_phat', delai_estime_Eckart', delai_estime_ml', ...
                        'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                        'PHAT', 'ECKART', 'HT'});
    writetable(delai_table, xlsx_filename, 'Sheet', 'Do_tre_uoc_luong', 'WriteRowNames', false);
    
    fprintf('Da xuat du lieu ra file Excel: %s\n', xlsx_filename);
    fprintf('  - Sheet 1: Do_lech_chuan\n');
    fprintf('  - Sheet 2: EQM_RMSE\n');
    fprintf('  - Sheet 3: Bias\n');
    fprintf('  - Sheet 4: Variance\n');
    fprintf('  - Sheet 5: Do_tre_uoc_luong\n');
    
catch ME
    fprintf('Khong the xuat file Excel. Loi: %s\n', ME.message);
    fprintf('  Chi xuat duoc file .mat va .txt\n');
    fprintf('  Kiem tra xem co MATLAB Excel support hoac quyen ghi file\n');
end

% ============================================================================
% PHAN 6: XUAT DU LIEU RA FILE .CSV
% ============================================================================
try
    % Tao bang du lieu cho Do lech chuan
    ecart_type_table = table(SNR', ecart_type', ecart_type_Roth', ecart_type_scot', ...
                             ecart_type_phat', ecart_type_Eckart', ecart_type_ml', ...
                             'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                             'PHAT', 'ECKART', 'HT'});
    csv_filename_ecart = fullfile(results_dir, [base_filename, '_Do_lech_chuan.csv']);
    writetable(ecart_type_table, csv_filename_ecart);
    fprintf('Da xuat du lieu ra file: %s\n', csv_filename_ecart);
    
    % Tao bang du lieu cho EQM (RMSE)
    EQM_table = table(SNR', EQM', EQM_Roth', EQM_scot', EQM_phat', ...
                      EQM_Eckart', EQM_ml', ...
                      'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                      'PHAT', 'ECKART', 'HT'});
    csv_filename_eqm = fullfile(results_dir, [base_filename, '_EQM_RMSE.csv']);
    writetable(EQM_table, csv_filename_eqm);
    fprintf('Da xuat du lieu ra file: %s\n', csv_filename_eqm);
    
    % Tao bang du lieu cho Bias
    bias_table = table(SNR', bias', bias_Roth', bias_scot', bias_phat', ...
                       bias_Eckart', bias_ml', ...
                       'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                       'PHAT', 'ECKART', 'HT'});
    csv_filename_bias = fullfile(results_dir, [base_filename, '_Bias.csv']);
    writetable(bias_table, csv_filename_bias);
    fprintf('Da xuat du lieu ra file: %s\n', csv_filename_bias);
    
    % Tao bang du lieu cho Variance
    Var_table = table(SNR', Var', Var_Roth', Var_scot', Var_phat', ...
                      Var_Eckart', Var_ml', ...
                      'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                      'PHAT', 'ECKART', 'HT'});
    csv_filename_var = fullfile(results_dir, [base_filename, '_Variance.csv']);
    writetable(Var_table, csv_filename_var);
    fprintf('Da xuat du lieu ra file: %s\n', csv_filename_var);
    
    % Tao bang du lieu cho Do tre uoc luong
    delai_table = table(SNR', delai_estime', delai_estime_Roth', delai_estime_scot', ...
                        delai_estime_phat', delai_estime_Eckart', delai_estime_ml', ...
                        'VariableNames', {'SNR_dB', 'CC_time', 'ROTH', 'SCOT', ...
                        'PHAT', 'ECKART', 'HT'});
    csv_filename_delai = fullfile(results_dir, [base_filename, '_Do_tre_uoc_luong.csv']);
    writetable(delai_table, csv_filename_delai);
    fprintf('Da xuat du lieu ra file: %s\n', csv_filename_delai);
    
catch ME
    fprintf('Khong the xuat file CSV. Loi: %s\n', ME.message);
end

fprintf('\nHoan thanh xuat du lieu!\n');

end

