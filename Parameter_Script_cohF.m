%% ================== Parameter_Script_cohF.m ==================
clear; clc;

% ==== Cấu hình mô phỏng ====
Fs = 2048;              % Tần số lấy mẫu [Hz]
Duration = 0.125;       % Thời lượng tín hiệu [s]
N = Duration * Fs;      % Số mẫu
nfft = N;
p = 40;                 % Số hệ số FIR cho mô phỏng trễ
Bandwidth = [15, 200];  % Dải tần tín hiệu sEMG
h_Length = [128];       % Chiều dài cửa sổ Hanning
CV_Scale = [2, 6];      % Khoảng vận tốc dẫn truyền [m/s]
DeltaE = 5e-3;          % Khoảng cách điện cực [m]
phi = 0.0;

n = 1:N;
CV = (CV_Scale(2) - CV_Scale(1))/2*sin(2*pi*n/N) + (CV_Scale(2) + CV_Scale(1))/2;
Delay = DeltaE * Fs ./ CV;  % Độ trễ tính bằng mẫu

save Parameter_Script_cohF Fs Duration N nfft p Bandwidth h_Length CV_Scale DeltaE phi Delay;
disp('✅ Đã lưu tham số mô phỏng vào Parameter_Script_cohF.mat');
