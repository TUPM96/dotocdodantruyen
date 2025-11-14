% ==============================================================================
% TEN FILE: printResultsTable.m
% CHUC NANG: In bang ket qua dinh dang dep de de doc
% MODULE: metrics
% ==============================================================================
%
function printResultsTable(results, SNR_values, method_names)
% PRINTRESULTSTABLE Print formatted results table
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: In bang ket qua dinh dang dep de de doc
%
% Giai thich chi tiet:
% - Hien thi ket qua cua tat ca cac phuong phap o moi muc SNR
% - Bao gom cac chi so: Mean, Bias, Std, RMSE
% - Dinh dang bang de de so sanh giua cac phuong phap
%
% Cac cot trong bang:
% - Method: Ten phuong phap GCC
% - Mean: Gia tri trung binh uoc luong
% - Bias: Do lech he thong
% - Std: Do lech chuan (phan tan)
% - RMSE: Sai so binh phuong trung binh (chi so chinh)
%
% SYNTAX:
%   printResultsTable(results, SNR_values, method_names)
%
% INPUTS:
%   results      - Cell array of results (Ma tran ket qua, n_methods x n_SNR)
%   SNR_values   - Vector of SNR values in dB (Cac muc SNR)
%   method_names - Cell array of method names (Ten cac phuong phap)
%
% DESCRIPTION:
%   Prints formatted table for easy comparison between methods.

%% BUOC 1: In tieu de chinh
fprintf('\n');
fprintf('========================================================================\n');
fprintf('                    DELAY ESTIMATION RESULTS\n');
fprintf('                    KET QUA UOC LUONG DO TRE\n');
fprintf('========================================================================\n\n');

%% BUOC 2: In ket qua cho tung muc SNR
% Giai thich: Lap qua tung muc SNR va in bang ket qua
for iSNR = 1:length(SNR_values)
    % In tieu de muc SNR hien tai
    fprintf('SNR = %d dB\n', SNR_values(iSNR));
    fprintf('------------------------------------------------------------------------\n');

    % In dong tieu de cot
    fprintf('%-15s %12s %12s %12s %12s\n', 'Method', 'Mean', 'Bias', 'Std', 'RMSE');
    fprintf('------------------------------------------------------------------------\n');

    % In ket qua cua tung phuong phap
    for iMethod = 1:length(method_names)
        stats = results{iMethod, iSNR};
        fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', ...
                method_names{iMethod}, ...
                stats.mean, ...
                stats.bias, ...
                stats.std, ...
                stats.rmse);
    end

    fprintf('\n');
end

%% BUOC 3: In dong ket thuc
fprintf('========================================================================\n\n');

end
