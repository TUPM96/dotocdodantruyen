% ==============================================================================
% TEN FILE: findBestMethod.m
% CHUC NANG: Tim phuong phap co RMSE thap nhat tai muc SNR cho truoc
% MODULE: metrics
% ==============================================================================
%
% Mo ta: So sanh RMSE cua tat ca cac phuong phap
%        Phuong phap co RMSE thap nhat la tot nhat
%        RMSE (Root Mean Square Error) la chi so chinh danh gia do chinh xac
%
% Nguyen ly: RMSE ket hop ca bias (do lech) va variance (phan tan)
%            Phuong phap tot nhat: RMSE = min{RMSE_1, RMSE_2, ..., RMSE_n}
%            Phuong phap tot co the khac nhau o cac muc SNR khac nhau
%
function [best_method, best_rmse] = findBestMethod(results, method_names, iSNR)

% Lay gia tri RMSE cua tat ca cac phuong phap
% Tao vector chua RMSE cua moi phuong phap tai muc SNR da cho
n_methods = length(method_names);
rmse_values = zeros(n_methods, 1);

for i = 1:n_methods
    rmse_values(i) = results{i, iSNR}.rmse;
end

% Tim gia tri RMSE nho nhat
% Dung ham min de tim gia tri RMSE nho nhat va chi so cua no
% Chi so tuong ung voi phuong phap tot nhat
[best_rmse, best_idx] = min(rmse_values);
best_method = method_names{best_idx};

end

