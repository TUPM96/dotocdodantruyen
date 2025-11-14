function [best_method, best_rmse] = findBestMethod(results, method_names, iSNR)
% FINDBESTMETHOD Find method with lowest RMSE at given SNR
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tim phuong phap tot nhat (co RMSE thap nhat) tai muc SNR cho truoc
%
% Giai thich chi tiet:
% - So sanh RMSE cua tat ca cac phuong phap
% - Phuong phap co RMSE thap nhat la tot nhat
% - RMSE (Root Mean Square Error) la chi so chinh danh gia do chinh xac
%
% Nguyen ly:
% - RMSE ket hop ca bias (do lech) va variance (phan tan)
% - Phuong phap tot nhat: RMSE = min{RMSE_1, RMSE_2, ..., RMSE_n}
% - Phuong phap tot co the khac nhau o cac muc SNR khac nhau
%
% Ung dung:
% - Xac dinh phuong phap phu hop nhat cho moi truong cu the
% - So sanh hieu suat cac phuong phap GCC
%
% SYNTAX:
%   [best_method, best_rmse] = findBestMethod(results, method_names, iSNR)
%
% INPUTS:
%   results      - Cell array of results (Ma tran ket qua, n_methods x n_SNR)
%   method_names - Cell array of method names (Ten cac phuong phap)
%   iSNR         - SNR index to evaluate (Chi so muc SNR can danh gia)
%
% OUTPUTS:
%   best_method - Name of best performing method (Ten phuong phap tot nhat)
%   best_rmse   - RMSE value of best method (Gia tri RMSE thap nhat)
%
% DESCRIPTION:
%   Compares all methods and returns the one with lowest RMSE.

%% BUOC 1: Lay gia tri RMSE cua tat ca cac phuong phap
% Giai thich: Tao vector chua RMSE cua moi phuong phap tai muc SNR da cho
n_methods = length(method_names);
rmse_values = zeros(n_methods, 1);

for i = 1:n_methods
    rmse_values(i) = results{i, iSNR}.rmse;
end

%% BUOC 2: Tim gia tri RMSE nho nhat
% Giai thich:
% - Dung ham min de tim gia tri RMSE nho nhat va chi so cua no
% - Chi so tuong ung voi phuong phap tot nhat
[best_rmse, best_idx] = min(rmse_values);
best_method = method_names{best_idx};

end
