% ==============================================================================
% TEN FILE: config.m
% CHUC NANG: Cau hinh tap trung cho mo phong uoc luong MFCV su dung GCC
% MODULE: config
% ==============================================================================
%
% Mo ta: Cau hinh tap trung cho mo phong uoc luong toc do dan truyen
%        soi co (MFCV) su dung cac phuong phap GCC
%
% Giai thich: File cau hinh tap trung tat ca tham so mo phong
%             De thay doi tham so, chi can sua file nay
%             Bao gom: tham so Monte Carlo, tin hieu, phan tich tan so, co bap
%
function cfg = config()

% Tham so mo phong Monte Carlo
% Monte Carlo la phuong phap lap lai nhieu lan voi nhieu khac nhau
% de danh gia do on dinh va chinh xac cua thuat toan
cfg.Nm = 100;
cfg.SNR = [0 10 20];

% Tham so tin hieu
% Cac tham so co ban cua tin hieu sEMG
cfg.Duration = 0.125;
cfg.Fs = 2048;
cfg.N = cfg.Duration * cfg.Fs;
cfg.p = 40;

% Tham so phan tich tan so
% Cac tham so cho phuong phap Welch va tinh toan pho
cfg.nfft = 2048;
cfg.Bandwidth = [15 200];
cfg.h_Length = 128;

% Tham so soi co bap
% Cac tham so sinh ly cua co bap
cfg.CV_Scale = [2 6];
cfg.DeltaE = 5e-3;

% Tinh do tre mong doi
% Tinh do tre ly thuyet dua tren toc do dan truyen trung binh
% Cong thuc: delay = khoang_cach / toc_do
% Chuyen sang mau: nhan voi tan so lay mau
cfg.CV_expected = mean(cfg.CV_Scale);
cfg.delay_expected = cfg.DeltaE * cfg.Fs / cfg.CV_expected;

% Danh sach cac phuong phap GCC can danh gia
% 6 phuong phap chinh, tu co ban den phuc tap
cfg.methods = {
    'CC_time'
    'PHAT'
    'ROTH'
    'SCOT'
    'ECKART'
    'HT'
};

% Cau hinh dau ra
% Cac tuy chon luu ket qua va hien thi
cfg.save_results = true;
cfg.results_dir = 'results';
cfg.show_plots = true;
cfg.verbose = true;

end
