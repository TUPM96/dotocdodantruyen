% ==============================================================================
% TEN FILE: printResultsTable.m
% CHUC NANG: In bang ket qua dinh dang dep de de doc
% MODULE: metrics
% ==============================================================================
%
% Mo ta: Hien thi ket qua cua tat ca cac phuong phap o moi muc SNR
%        Bao gom cac chi so: Mean, Bias, Std, RMSE
%        Dinh dang bang de de so sanh giua cac phuong phap
%
% Cac cot trong bang:
% - Method: Ten phuong phap GCC
% - Mean: Gia tri trung binh uoc luong
% - Bias: Do lech he thong
% - Std: Do lech chuan (phan tan)
% - RMSE: Sai so binh phuong trung binh (chi so chinh)
%
function printResultsTable(results, SNR_values, method_names)

% In tieu de chinh
fprintf('\n');
fprintf('========================================================================\n');
fprintf('                    DELAY ESTIMATION RESULTS\n');
fprintf('                    KET QUA UOC LUONG DO TRE\n');
fprintf('========================================================================\n\n');

% In ket qua cho tung muc SNR
% Lap qua tung muc SNR va in bang ket qua
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

% In dong ket thuc
fprintf('========================================================================\n\n');

end

