% ==============================================================================
% TEN FILE: main.m
% CHUC NANG: Chuong trinh chinh uoc luong MFCV su dung 6 phuong phap GCC
% ==============================================================================

close all; clear all;

% ============================================================================
% PHAN 1: KHOI TAO THAM SO
% ============================================================================
% Tham so Monte Carlo
N_MonteCarlo = 100;    % So lan lap Monte Carlo
Nm = N_MonteCarlo;     % Ten khac

% Tham so tin hieu
Duration = 0.125;      % Thoi luong mo phong (giay) = 125ms
Fs = 2048;             % Tan so lay mau (Hz)
nfft = 2048;           % Do dai FFT cho ham tfrstft
N = Duration * Fs;     % So diem tin hieu = 256 mau
p = 40;                % So he so cho bo loc tao do tre (dung trong sEMG_Generator)

% Tham so phan tich tan so
Bandwidth = [15 200];  % Dai tan so phan tich (Hz)
RegLinStart = round(Bandwidth(1) * nfft / Fs + 1);  % Chi so bat dau cho hoi quy tuyen tinh
RegLinStop = round(Bandwidth(2) * nfft / Fs + 1);   % Chi so ket thuc cho hoi quy tuyen tinh
nF = (0:nfft-1) / nfft;  % Truc tan so chuan hoa (0 den 1)
f = nF(RegLinStart:RegLinStop) * Fs;  % Chuyen doi truc tan so sang Hz
n = 1:N;               % Truc tan so cho hien thi du lieu
h_Length = [128];      % Kich thuoc cua so cho phuong phap Welch

% Tham so soi co bap
CV_Scale = [2 6];      % Khoang toc do dan truyen (m/s): min va max
DeltaE = 5 * 10^(-3);  % Khoang cach giua dien cuc (m) = 5mm

% Tham so xu ly do tre bien thien (neu co)
phi = 0.0;             % Goc xoay (neu su dung)
Nl = 5;                % So hang (neu su dung)
Nc = 13;               % So cot (neu su dung)

% Tinh CV va Delay (tu Parameter_Script_cohF.m)
% Tinh CV theo cong thuc sin (neu can thiet cho do tre bien thien)
CV = (CV_Scale(2) - CV_Scale(1))/2 * sin(2*pi*n/N) + (CV_Scale(2) + CV_Scale(1))/2;
% Tinh Delay tu CV
Delay = DeltaE * Fs ./ CV;  % Delay en m.s-1

% Tham so loc va xu ly
Est_Delta_CVmax = 1;   % Bien do toi da cho phep cua CV (m/s)
Delay_Threshold = Est_Delta_CVmax / (Fs * DeltaE) * min(Delay).^2;  % Nguong do tre
Delta = 10;            % So diem thoi gian cho trung binh hoa pha coherence
Med_Windows = 20;      % Do rong cua so trung vi de loai bo diem bat thuong

% Thiet lap do tre mong doi va CV mong doi
delai_attendu = [4.9];  % Do tre mong doi (mau)
CV_attendu = 5.10^-3 / (4.9/2048);  % CV mong doi (m/s)

% Tham so mo phong
SNR = [0 10 20];       % Cac muc SNR (dB)
nfft = N;              % Do dai FFT (bang do dai tin hieu)

% ============================================================================
% PHAN 3: KHOI TAO CAC BIEN LUU KET QUA
% ============================================================================
% Ma tran luu uoc luong do tre cho moi phuong phap (Nm x length(SNR))
D = zeros(Nm, length(SNR));        % CC_time - Tuong quan cheo mien thoi gian
DRoth = zeros(Nm, length(SNR));    % ROTH - Bo xu ly Roth
DScot = zeros(Nm, length(SNR));    % SCOT - Smoothed Coherence Transform
Dphat = zeros(Nm, length(SNR));    % PHAT - Phase Transform
DEckart = zeros(Nm, length(SNR));  % ECKART - Bo loc Eckart
Dml = zeros(Nm, length(SNR));      % HT - Hannan-Thomson (Maximum Likelihood)

% Cac bien luu ket qua thong ke cho moi phuong phap
delai_estime = zeros(length(SNR), 1);         % Trung binh do tre - CC_time
delai_estime_Roth = zeros(length(SNR), 1);    % Trung binh do tre - ROTH
delai_estime_scot = zeros(length(SNR), 1);    % Trung binh do tre - SCOT
delai_estime_phat = zeros(length(SNR), 1);    % Trung binh do tre - PHAT
delai_estime_Eckart = zeros(length(SNR), 1);  % Trung binh do tre - ECKART
delai_estime_ml = zeros(length(SNR), 1);      % Trung binh do tre - HT

% Cac bien luu gia tri cuc dai va vi tri cuc dai
ccmaximum = zeros(Nm, 1);      % Gia tri cuc dai - CC_time
Rothmaximum = zeros(Nm, 1);    % Gia tri cuc dai - ROTH
Scotmaximum = zeros(Nm, 1);    % Gia tri cuc dai - SCOT
phatmaximum = zeros(Nm, 1);    % Gia tri cuc dai - PHAT
Eckartmaximum = zeros(Nm, 1);  % Gia tri cuc dai - ECKART
mlmaximum = zeros(Nm, 1);     % Gia tri cuc dai - HT

% Cac bien luu vi tri (index) cuc dai
cctime = zeros(Nm, 1);         % Vi tri cuc dai - CC_time
Rothtime = zeros(Nm, 1);       % Vi tri cuc dai - ROTH
Scottime = zeros(Nm, 1);       % Vi tri cuc dai - SCOT
phattime = zeros(Nm, 1);       % Vi tri cuc dai - PHAT
Eckarttime = zeros(Nm, 1);     % Vi tri cuc dai - ECKART
mltime = zeros(Nm, 1);         % Vi tri cuc dai - HT

% Cac bien luu uoc luong do tre (truoc khi noi suy)
ccestime = zeros(Nm, 1);       % Uoc luong do tre - CC_time
Rothestime = zeros(Nm, 1);    % Uoc luong do tre - ROTH
Scotestime = zeros(Nm, 1);    % Uoc luong do tre - SCOT
phatestime = zeros(Nm, 1);     % Uoc luong do tre - PHAT
Eckartestime = zeros(Nm, 1);  % Uoc luong do tre - ECKART
mlestime = zeros(Nm, 1);       % Uoc luong do tre - HT

% Cac bien luu bias (do lech so voi gia tri thuc)
bias = zeros(length(SNR), 1);         % Bias - CC_time
bias_Roth = zeros(length(SNR), 1);    % Bias - ROTH
bias_scot = zeros(length(SNR), 1);    % Bias - SCOT
bias_phat = zeros(length(SNR), 1);    % Bias - PHAT
bias_Eckart = zeros(length(SNR), 1);  % Bias - ECKART
bias_ml = zeros(length(SNR), 1);     % Bias - HT

% Cac bien luu phuong sai (variance)
Var = zeros(length(SNR), 1);         % Phuong sai - CC_time
Var_Roth = zeros(length(SNR), 1);    % Phuong sai - ROTH
Var_scot = zeros(length(SNR), 1);    % Phuong sai - SCOT
Var_phat = zeros(length(SNR), 1);     % Phuong sai - PHAT
Var_Eckart = zeros(length(SNR), 1);  % Phuong sai - ECKART
Var_ml = zeros(length(SNR), 1);       % Phuong sai - HT

% Cac bien luu do lech chuan (standard deviation)
ecart_type = zeros(length(SNR), 1);         % Do lech chuan - CC_time
ecart_type_Roth = zeros(length(SNR), 1);    % Do lech chuan - ROTH
ecart_type_scot = zeros(length(SNR), 1);   % Do lech chuan - SCOT
ecart_type_phat = zeros(length(SNR), 1);   % Do lech chuan - PHAT
ecart_type_Eckart = zeros(length(SNR), 1); % Do lech chuan - ECKART
ecart_type_ml = zeros(length(SNR), 1);     % Do lech chuan - HT

% Cac bien luu sai so binh phuong trung binh (RMSE/EQM)
EQM = zeros(length(SNR), 1);         % RMSE - CC_time
EQM_Roth = zeros(length(SNR), 1);   % RMSE - ROTH
EQM_scot = zeros(length(SNR), 1);   % RMSE - SCOT
EQM_phat = zeros(length(SNR), 1);   % RMSE - PHAT
EQM_Eckart = zeros(length(SNR), 1);  % RMSE - ECKART
EQM_ml = zeros(length(SNR), 1);     % RMSE - HT

% ============================================================================
% PHAN 4: TINH PSD LY THUYET (Mo hinh Farina-Merletti)
% ============================================================================
maximum = delai_attendu + 20;  % Gioi han tren cho hien thi
minimum = delai_attendu - 20;  % Gioi han duoi cho hien thi

fh = 120;  % Tan so cao (Hz)
fl = 60;   % Tan so thap (Hz)
k = 1;     % He so ty le

% Tinh PSD theo mo hinh Farina-Merletti
% Tham khao: D. Farina and R. Merletti, "Comparison of algorithms for 
%            estimation of EMG variables during voluntary contractions",
%            Journal of Electromyography and Kinesiology, vol. 10, 
%            pp. 337-349, 2000.
f = linspace(0, Fs, N);
PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);

% Tao pho doi xung cho tin hieu thuc
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

% Chuan hoa PSD
PSD = PSD ./ max(PSD);

% ============================================================================
% PHAN 5: MO PHONG MONTE CARLO
% ============================================================================
for ns = 1:length(SNR),  % Vong lap cho moi muc SNR
    for nN = 1:length(h_Length),  % Vong lap cho moi kich thuoc cua so
        % Tao ham cua so Hanning cho phuong phap Welch
        win = hanning(h_Length(nN));
        n_overlap = length(win) / 2;  % 50% chong chap
        
        for i = 1:Nm,  % Vong lap Monte Carlo
            % ====================================================================
            % BUOC 1: TAO TIN HIEU sEMG GIA LAP
            % ====================================================================
            % Tao 4 kenh tin hieu sEMG voi do tre khac nhau
            % Su dung module signal
            [Vec_Signal, T, b] = signal.sEMG_Generator('simu_semg', N, p, delai_attendu, Fs);
            s1 = Vec_Signal(:, 1);  % Kenh 1 (tham chieu, khong co do tre)
            s2 = Vec_Signal(:, 2);  % Kenh 2 (co do tre delai_attendu)
            
            % ====================================================================
            % BUOC 2: THEM NHIEU VAO TIN HIEU
            % ====================================================================
            % Them nhieu trang Gaussian de dat SNR mong muon
            s1_noise = Vec_Signal(:, 1) + sqrt(var(Vec_Signal(:, 1)) * 10^(-SNR(ns)/10)) * randn(size(Vec_Signal(:, 1)));
            s2_noise = Vec_Signal(:, 2) + sqrt(var(Vec_Signal(:, 2)) * 10^(-SNR(ns)/10)) * randn(size(Vec_Signal(:, 2)));
            
            % ====================================================================
            % BUOC 3: TINH CAC PHO (PSD) SU DUNG PHUONG PHAP WELCH
            % ====================================================================
            % Tinh pho tu dong (auto-PSD) va pho cheo (cross-PSD)
            % Su dung module preprocessing
            [Pxx, Pyy, Pxy] = preprocessing.computeSpectra(s1_noise, s2_noise, win, n_overlap, nfft, Fs);
            
            % ====================================================================
            % BUOC 4: TINH PHO LY THUYET CHO CAC PHUONG PHAP ECKART VA HT
            % ====================================================================
            % Tinh pho tu dong cua tin hieu co nhieu va pho tin hieu sach
            % Su dung module preprocessing
            [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = preprocessing.computeTheoreticalSpectra(PSD, s1, s2, SNR(ns));
            
            % ====================================================================
            % BUOC 5: AP DUNG CAC PHUONG PHAP GCC
            % ====================================================================
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 1: CC_time - Tuong quan cheo mien thoi gian
            % --------------------------------------------------------------------
            % Su dung module gcc
            D(i, ns) = gcc.ccTime(s1_noise, s2_noise, N);
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 2: ROTH - Bo xu ly Roth
            % --------------------------------------------------------------------
            % Su dung module gcc
            DRoth(i, ns) = gcc.gccROTH(Pxy, Gx1x1, N);
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 3: SCOT - Smoothed Coherence Transform
            % --------------------------------------------------------------------
            % Su dung module gcc
            DScot(i, ns) = gcc.gccSCOT(Pxy, Gx1x1, Gx2x2, N);
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 4: PHAT - Phase Transform
            % --------------------------------------------------------------------
            % Su dung module gcc
            Dphat(i, ns) = gcc.gccPHAT(Pxy, Gss, N);
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 5: ECKART - Bo loc Eckart
            % --------------------------------------------------------------------
            % Su dung module gcc
            DEckart(i, ns) = gcc.gccECKART(Pxy, Gss, Gn1n1, Gn2n2, N);
            
            % --------------------------------------------------------------------
            % PHUONG PHAP 6: HT - Hannan-Thomson (Maximum Likelihood)
            % --------------------------------------------------------------------
            % Su dung module gcc
            Dml(i, ns) = gcc.gccHT(Pxy, Gss, Gn1n1, Gn2n2, N);
            
            % Luu ket qua tam thoi
            save gcc;
        end;
    end;
end;

% ============================================================================
% PHAN 6: TINH LAI CAC CHI SO THONG KE SAU KHI HOAN THANH TAT CA VONG LAP
% ============================================================================
% Tinh lai cac chi so thong ke cho tat ca cac phuong phap
for ns = 1:length(SNR)
    % Phuong phap CC_time
    delai_estime(ns) = mean(D(:, ns));
    bias(ns) = delai_estime(ns) - delai_attendu;
    Var(ns) = var(D(:, ns));
    ecart_type(ns) = sqrt(Var(ns));
    EQM(ns) = bias(ns)^2 + Var(ns);
    
    % Phuong phap ROTH
    delai_estime_Roth(ns) = mean(DRoth(:, ns));
    bias_Roth(ns) = delai_estime_Roth(ns) - delai_attendu;
    Var_Roth(ns) = var(DRoth(:, ns));
    ecart_type_Roth(ns) = sqrt(Var_Roth(ns));
    EQM_Roth(ns) = sqrt(bias_Roth(ns)^2 + Var_Roth(ns));
    
    % Phuong phap SCOT
    delai_estime_scot(ns) = mean(DScot(:, ns));
    bias_scot(ns) = delai_estime_scot(ns) - delai_attendu;
    Var_scot(ns) = var(DScot(:, ns));
    ecart_type_scot(ns) = sqrt(Var_scot(ns));
    EQM_scot(ns) = sqrt(bias_scot(ns)^2 + Var_scot(ns));
    
    % Phuong phap PHAT
    delai_estime_phat(ns) = mean(Dphat(:, ns));
    bias_phat(ns) = delai_estime_phat(ns) - delai_attendu;
    Var_phat(ns) = var(Dphat(:, ns));
    ecart_type_phat(ns) = sqrt(Var_phat(ns));
    EQM_phat(ns) = sqrt(bias_phat(ns)^2 + Var_phat(ns));
    
    % Phuong phap ECKART
    delai_estime_Eckart(ns) = mean(DEckart(:, ns));
    bias_Eckart(ns) = delai_estime_Eckart(ns) - delai_attendu;
    Var_Eckart(ns) = var(DEckart(:, ns));
    ecart_type_Eckart(ns) = sqrt(Var_Eckart(ns));
    EQM_Eckart(ns) = sqrt(bias_Eckart(ns)^2 + Var_Eckart(ns));
    
    % Phuong phap HT
    delai_estime_ml(ns) = mean(Dml(:, ns));
    bias_ml(ns) = delai_estime_ml(ns) - delai_attendu;
    Var_ml(ns) = var(Dml(:, ns));
    ecart_type_ml(ns) = sqrt(Var_ml(ns));
    EQM_ml(ns) = sqrt(bias_ml(ns)^2 + Var_ml(ns));
end

% ============================================================================
% PHAN 7: TAO CAC BIEU DO
% ============================================================================
% Su dung module visualization de tao tat ca cac bieu do
visualization.plotResults(ecart_type, ecart_type_Roth, ecart_type_scot, ecart_type_phat, ...
                         ecart_type_Eckart, ecart_type_ml, EQM, EQM_Roth, EQM_scot, ...
                         EQM_phat, EQM_Eckart, EQM_ml, SNR);

