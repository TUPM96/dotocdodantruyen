function stats = calculateStats(delays, expected_delay)
% CALCULATESTATS Calculate statistical performance metrics
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tinh cac chi so thong ke danh gia hieu suat uoc luong do tre
%
% Giai thich chi tiet:
% - Tinh cac chi so de danh gia do chinh xac cua phuong phap uoc luong
% - Su dung trong mo phong Monte Carlo (lap lai nhieu lan voi nhieu khac nhau)
% - Cac chi so bao gom: trung binh, do lech, phuong sai, do lech chuan, RMSE
%
% Cac chi so thong ke:
% 1. Mean (Gia tri trung binh): Trung binh cua tat ca uoc luong
% 2. Bias (Do lech): Sai lech he thong giua trung binh va gia tri that
%    - Bias > 0: Uoc luong cao hon gia tri that
%    - Bias < 0: Uoc luong thap hon gia tri that
%    - Bias = 0: Uoc luong khong lech (unbiased)
% 3. Variance (Phuong sai): Do phan tan cua cac uoc luong
% 4. Std (Do lech chuan): Can bac hai cua phuong sai
% 5. MSE (Mean Square Error): Sai so binh phuong trung binh
%    - MSE = Bias^2 + Variance (Dinh ly phan tich MSE)
% 6. RMSE (Root MSE): Can bac hai cua MSE - Chi so quan trong nhat
%
% SYNTAX:
%   stats = calculateStats(delays, expected_delay)
%
% INPUTS:
%   delays         - Vector of estimated delays (Vector cac gia tri uoc luong, Nm x 1)
%   expected_delay - True delay value (Gia tri do tre that)
%
% OUTPUTS:
%   stats - Structure containing (Cau truc chua cac chi so):
%           .mean     - Mean of estimates (Gia tri trung binh)
%           .bias     - Bias (Do lech he thong)
%           .variance - Variance (Phuong sai)
%           .std      - Standard deviation (Do lech chuan)
%           .rmse     - Root mean square error (RMSE)
%           .mse      - Mean square error (MSE)
%
% DESCRIPTION:
%   Evaluates performance in Monte Carlo simulations.

%% BUOC 1: Tinh gia tri trung binh
% Giai thich: Trung binh cong cua tat ca cac uoc luong
stats.mean = mean(delays);

%% BUOC 2: Tinh do lech (Bias)
% Giai thich: Sai khac giua gia tri trung binh va gia tri that
% - Bias duong: Uoc luong qua muc (overestimate)
% - Bias am: Uoc luong thieu (underestimate)
% - Phuong phap tot nen co bias gan 0
stats.bias = stats.mean - expected_delay;

%% BUOC 3: Tinh phuong sai (Variance)
% Giai thich: Do bien dong cua cac uoc luong quanh gia tri trung binh
% - Phuong sai cao: Uoc luong khong on dinh, phan tan lon
% - Phuong sai thap: Uoc luong on dinh, tap trung quanh trung binh
stats.variance = var(delays);

%% BUOC 4: Tinh do lech chuan (Standard Deviation)
% Giai thich: Can bac hai cua phuong sai, cung don vi voi du lieu
% - De hieu hon phuong sai vi cung don vi voi gia tri do tre
stats.std = sqrt(stats.variance);

%% BUOC 5: Tinh MSE (Mean Square Error)
% Giai thich: Sai so binh phuong trung binh
% Dinh ly: MSE = Bias^2 + Variance
% - Thanh phan Bias^2: Sai so he thong
% - Thanh phan Variance: Sai so ngau nhien
stats.mse = stats.bias^2 + stats.variance;

%% BUOC 6: Tinh RMSE (Root Mean Square Error)
% Giai thich: Can bac hai cua MSE, chi so quan trong nhat
% - RMSE thap: Phuong phap tot
% - RMSE cao: Phuong phap kem
% - RMSE ket hop ca bias va variance nen la chi so tong quat nhat
stats.rmse = sqrt(stats.mse);

end
