% ==============================================================================
% TEN FILE: calculateStats.m
% CHUC NANG: Tinh cac chi so thong ke danh gia hieu suat uoc luong
% MODULE: metrics
% ==============================================================================
%
% Mo ta: Tinh cac chi so de danh gia do chinh xac cua phuong phap uoc luong do tre
%        Su dung trong mo phong Monte Carlo (lap lai nhieu lan voi nhieu khac nhau)
%
% Cac chi so thong ke:
% 1. Mean: Trung binh cua tat ca uoc luong
% 2. Bias: Sai lech he thong giua trung binh va gia tri that
% 3. Variance: Do phan tan cua cac uoc luong
% 4. Std: Do lech chuan (can bac hai cua phuong sai)
% 5. MSE: Sai so binh phuong trung binh = Bias^2 + Variance
% 6. RMSE: Can bac hai cua MSE - Chi so quan trong nhat
%
function stats = calculateStats(delays, expected_delay)

% Tinh gia tri trung binh
% Trung binh cong cua tat ca cac uoc luong
stats.mean = mean(delays);

% Tinh do lech (Bias)
% Sai khac giua gia tri trung binh va gia tri that
% Bias duong: Uoc luong qua muc, Bias am: Uoc luong thieu
% Phuong phap tot nen co bias gan 0
stats.bias = stats.mean - expected_delay;

% Tinh phuong sai (Variance)
% Do bien dong cua cac uoc luong quanh gia tri trung binh
% Phuong sai cao: Uoc luong khong on dinh, phan tan lon
% Phuong sai thap: Uoc luong on dinh, tap trung quanh trung binh
stats.variance = var(delays);

% Tinh do lech chuan (Standard Deviation)
% Can bac hai cua phuong sai, cung don vi voi du lieu
% De hieu hon phuong sai vi cung don vi voi gia tri do tre
stats.std = sqrt(stats.variance);

% Tinh MSE (Mean Square Error)
% Sai so binh phuong trung binh
% Dinh ly: MSE = Bias^2 + Variance
% Thanh phan Bias^2: Sai so he thong
% Thanh phan Variance: Sai so ngau nhien
stats.mse = stats.bias^2 + stats.variance;

% Tinh RMSE (Root Mean Square Error)
% Can bac hai cua MSE, chi so quan trong nhat
% RMSE thap: Phuong phap tot
% RMSE cao: Phuong phap kem
% RMSE ket hop ca bias va variance nen la chi so tong quat nhat
stats.rmse = sqrt(stats.mse);

end

