% ==============================================================================
% TEN FILE: exportResults.m
% CHUC NANG: Luu va xuat du lieu ket qua ra file
% MODULE: export
% ==============================================================================
%
% Mo ta: Luu tat ca ket qua thong ke (ecart_type, EQM, bias, variance) ra file
%        Hỗ trợ các định dạng: .mat, .txt
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

fprintf('\nHoan thanh xuat du lieu!\n');

end

