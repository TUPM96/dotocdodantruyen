function cfg = config()
% CONFIG Configuration parameters for GCC simulation
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Cau hinh tap trung cho mo phong uoc luong toc do dan truyen
%            soi co (MFCV) su dung cac phuong phap GCC
%
% Giai thich chi tiet:
% - File cau hinh tap trung tat ca tham so mo phong
% - De thay doi tham so, chi can sua file nay
% - Bao gom: tham so Monte Carlo, tin hieu, phan tich tan so, co bap
%
% SYNTAX:
%   cfg = config()
%
% OUTPUTS:
%   cfg - Configuration structure (Cau truc chua tat ca tham so)
%
% DESCRIPTION:
%   Centralized configuration for MFCV estimation using GCC methods.

%% BUOC 1: Tham so mo phong Monte Carlo
% Giai thich: Monte Carlo la phuong phap lap lai nhieu lan voi nhieu khac nhau
% de danh gia do on dinh va chinh xac cua thuat toan
cfg.Nm = 100;                    % So lan lap Monte Carlo
cfg.SNR = [0 10 20];            % Cac muc SNR (dB): thap, trung binh, cao

%% BUOC 2: Tham so tin hieu
% Giai thich: Cac tham so co ban cua tin hieu sEMG
cfg.Duration = 0.125;            % Thoi luong tin hieu (giay) - 125ms
cfg.Fs = 2048;                   % Tan so lay mau (Hz) - pho bien cho sEMG
cfg.N = cfg.Duration * cfg.Fs;   % So mau = thoi luong * tan so = 256 mau
cfg.p = 40;                      % Bac bo loc FIR cho mo hinh hoa do tre phan so

%% BUOC 3: Tham so phan tich tan so
% Giai thich: Cac tham so cho phuong phap Welch va tinh toan pho
cfg.nfft = 2048;                 % Do dai FFT - nen la luy thua 2 cho nhanh
cfg.Bandwidth = [15 200];        % Dải tan so phan tich (Hz)
                                 % - 15-200 Hz la dải tan so chinh cua sEMG
cfg.h_Length = 128;              % Do dai cua so cho tinh CPSD (Welch method)
                                 % - Lon hon -> do phan giai tan so cao, nhung it doan
                                 % - Nho hon -> nhieu doan, giam nhieu tot hon

%% BUOC 4: Tham so soi co bap
% Giai thich: Cac tham so sinh ly cua co bap
cfg.CV_Scale = [2 6];            % Khoang toc do dan truyen (m/s)
                                 % - 2-6 m/s la khoang pho bien cho co bap nguoi
cfg.DeltaE = 5e-3;               % Khoang cach giua dien cuc (m) = 5mm
                                 % - Khoang cach tieu chuan trong do luong sEMG

%% BUOC 5: Tinh do tre mong doi
% Giai thich: Tinh do tre ly thuyet dua tren toc do dan truyen trung binh
% Cong thuc: delay = khoang_cach / toc_do
% Chuyen sang mau: nhan voi tan so lay mau

cfg.CV_expected = mean(cfg.CV_Scale);  % Toc do dan truyen trung binh (m/s)
                                       % = (2 + 6) / 2 = 4 m/s

cfg.delay_expected = cfg.DeltaE * cfg.Fs / cfg.CV_expected;
% Giai thich tinh toan:
% - DeltaE = 5mm = 0.005m
% - CV = 4 m/s
% - Thoi gian tre = 0.005/4 = 0.00125 giay
% - So mau tre = 0.00125 * 2048 = 2.56 mau

%% BUOC 6: Danh sach cac phuong phap GCC can danh gia
% Giai thich: 7 phuong phap pho bien nhat, tu co ban den phuc tap
cfg.methods = {
    'CC_time'   % 1. Tuong quan cheo mien thoi gian (co ban nhat)
    'GCC'       % 2. GCC co ban (tuong duong CC_time, tinh trong mien tan so)
    'PHAT'      % 3. Phase Transform - Tay trang pho, tot voi moi truong phan xa
    'ROTH'      % 4. Bo xu ly Roth - Chuan hoa theo pho kenh 1
    'SCOT'      % 5. Smoothed Coherence Transform - Chuan hoa doi xung ca 2 kenh
    'ECKART'    % 6. Bo loc Eckart - Toi uu SNR, can biet thong ke tin hieu va nhieu
    'HT'        % 7. Hannan-Thomson (ML) - Toi uu nhat theo ly thuyet
};
% Ghi chu:
% - CC_time, GCC: Khong can thong tin truoc, don gian
% - PHAT, ROTH, SCOT: Can pho tin hieu, tot hon voi nhieu
% - ECKART, HT: Can biet chính xac pho va thong ke nhieu, toi uu nhat

%% BUOC 7: Cau hinh dau ra
% Giai thich: Cac tuy chon luu ket qua va hien thi
cfg.save_results = true;         % Luu ket qua vao file .mat
cfg.results_dir = 'results';     % Thu muc luu ket qua
cfg.show_plots = true;           % Hien thi bieu do (figures)
cfg.verbose = true;              % In thong bao tien trinh

end
