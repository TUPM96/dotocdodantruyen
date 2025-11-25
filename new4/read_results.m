% Script de doc ket qua tu file gcc.mat
load('gcc.mat');

% Kiem tra cac bien co trong file
whos

% Hien thi ket qua EQM (RMSE)
fprintf('\n=== KET QUA RMSE (EQM) ===\n');
fprintf('SNR (dB)\tCC_time\t\tROTH\t\tSCOT\t\tPHAT\t\tECKART\t\tHT\n');
fprintf('--------------------------------------------------------------------------------\n');

if exist('SNR', 'var') && exist('EQM', 'var')
    for i = 1:length(SNR)
        fprintf('%d\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
            SNR(i), EQM(i), EQM_Roth(i), EQM_scot(i), ...
            EQM_phat(i), EQM_Eckart(i), EQM_ml(i));
    end
end

