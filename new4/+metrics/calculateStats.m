% ==============================================================================
% TEN FILE: calculateStats.m
% CHUC NANG: Tinh cac chi so thong ke cho mot phuong phap
% MODULE: metrics
% ==============================================================================
%
% Mo ta: Tinh trung binh, bias, phuong sai, do lech chuan, RMSE
%        cho mot phuong phap uoc luong do tre
%
function [mean_delay, bias, variance, std_dev, rmse] = calculateStats(D, delai_attendu)

% Tinh trung binh do tre uoc luong
mean_delay = mean(D);

% Tinh bias (do lech so voi gia tri thuc)
bias = mean_delay - delai_attendu;

% Tinh phuong sai (variance)
variance = var(D);

% Tinh do lech chuan (standard deviation)
std_dev = sqrt(variance);

% Tinh RMSE (Root Mean Squared Error)
% RMSE = sqrt(bias^2 + variance)
rmse = sqrt(bias^2 + variance);

end

