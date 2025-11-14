% ==============================================================================
% TEN FILE: main.m
% CHUC NANG: Chuong trinh chinh uoc luong MFCV su dung cac phuong phap GCC
% MODULE: main
% ==============================================================================
%
% Mo ta: Chuong trinh chinh uoc luong toc do dan truyen soi co bap (MFCV)
%        su dung cac phuong phap tuong quan cheo tong quat (GCC)
%        Tich hop tat ca tham so tu Parameter_Script_cohF.m vao day
%
% MFCV la toc do truyen xung dien tren soi co, thong so quan trong danh gia
% tinh trang co bap va chan doan benh ly than kinh-co
% Uoc luong MFCV bang cach do do tre tin hieu sEMG giua cac dien cuc
% Cong thuc: MFCV = Khoang_cach_dien_cuc / Do_tre_thoi_gian
%
% Cac phuong phap GCC duoc so sanh (6 phuong phap chinh):
%   1. CC_time  - Tuong quan cheo mien thoi gian (co ban)
%   2. GCC      - Generalized Cross-Correlation co ban (mien tan so)
%   3. PHAT     - Phase Transform (tay trang pho)
%   4. ROTH     - Bo xu ly Roth (chuan hoa 1 kenh)
%   5. SCOT     - Smoothed Coherence Transform (chuan hoa doi xung)
%   6. ECKART   - Bo loc Eckart (toi uu SNR)
%   7. HT       - Hannan-Thomson (Maximum Likelihood - toi uu nhat)
%

clear; close all; clc;

% ============================================================================
% PHAN 1: THIET LAP THAM SO (Tich hop tu Parameter_Script_cohF.m)
% ============================================================================
fprintf('\n========================================\n');
fprintf('  GCC-BASED MFCV ESTIMATION SIMULATION\n');
fprintf('  MO PHONG UOC LUONG MFCV BANG GCC\n');
fprintf('========================================\n\n');

fprintf('[1/10] Thiet lap tham so mo phong...\n');

% Tham so Monte Carlo
N_MonteCarlo = 100;              % So lan lap Monte Carlo
SNR = [0 10 20];                 % Cac muc SNR (dB)

% Tham so tin hieu
Duration = 0.125;                % Thoi luong mo phong (giay) = 125ms
Fs = 2048;                       % Tan so lay mau (Hz)
nfft = 2048;                     % Do dai FFT cho ham tfrstft
N = Duration * Fs;              % So diem tin hieu = 256 mau
p = 40;                          % So he so cho bo loc tao do tre (dung trong sEMG_Generator)

% Tham so phan tich tan so
Bandwidth = [15 200];            % Dai tan so phan tich (Hz)
RegLinStart = round(Bandwidth(1) * nfft / Fs + 1);  % Chi so bat dau cho hoi quy tuyen tinh
RegLinStop = round(Bandwidth(2) * nfft / Fs + 1);   % Chi so ket thuc cho hoi quy tuyen tinh
nF = (0:nfft-1) / nfft;         % Truc tan so chuan hoa (0 den 1)
f = nF(RegLinStart:RegLinStop) * Fs;  % Chuyen doi truc tan so sang Hz
n = 1:N;                         % Truc tan so cho hien thi du lieu
h_Length = 128;                  % Kich thuoc cua so cho phuong phap Welch

% Tham so soi co bap
CV_Scale = [2 6];                % Khoang toc do dan truyen (m/s): min va max
DeltaE = 5 * 10^(-3);            % Khoang cach giua dien cuc (m) = 5mm

% Tham so do tre mong doi
% Tinh do tre tu toc do dan truyen trung binh
CV_expected = mean(CV_Scale);    % Toc do dan truyen trung binh = 4 m/s
delai_attendu = DeltaE * Fs / CV_expected;  % Do tre mong doi (mau)
CV_attendu = DeltaE / (delai_attendu / Fs); % Xac nhan lai CV

% Tham so xu ly do tre bien thien (neu co)
phi = 0.0;                       % Goc xoay (neu su dung)
Nl = 5;                          % So hang (neu su dung)
Nc = 13;                         % So cot (neu su dung)

% Tham so loc va xu ly
Est_Delta_CVmax = 1;             % Bien do toi da cho phep cua CV (m/s)
Delay_Threshold = Est_Delta_CVmax / (Fs * DeltaE) * min(delai_attendu)^2;  % Nguong do tre
Delta = 10;                      % So diem thoi gian cho trung binh hoa pha coherence
Med_Windows = 20;                % Do rong cua so trung vi de loai bo diem bat thuong

% ============================================================================
% PHAN 2: TINH PSD LY THUYET (Mo hinh Farina-Merletti)
% ============================================================================
fprintf('[2/10] Tinh PSD ly thuyet Farina-Merletti...\n');

fh = 120;                        % Tan so cao (Hz)
fl = 60;                         % Tan so thap (Hz)
k = 1;                           % He so ty le
% Quan trong: PSD phai co cung kich thuoc voi ket qua cpsd (nfft)
% De dam bao PSD co kich thuoc nfft, su dung nfft thay vi N
f_psd = linspace(0, Fs, nfft);   % Truc tan so cho PSD (nfft diem)

% Cong thuc PSD Farina-Merletti
% Tham khao: D. Farina and R. Merletti, "Comparison of algorithms for 
%            estimation of EMG variables during voluntary contractions",
%            Journal of Electromyography and Kinesiology, vol. 10, 
%            pp. 337-349, 2000.
PSD = k * fh.^4 .* f_psd.^2 ./ ((f_psd.^2 + fl.^2) .* (f_psd.^2 + fh.^2).^2);

% Tao pho doi xung cho tin hieu thuc
PSD = [PSD(1:nfft/2+1) fliplr(PSD(2:nfft/2))];

% Chuan hoa PSD
PSD = PSD ./ max(PSD);

% ============================================================================
% PHAN 3: KHOI TAO CAU TRUC DU LIEU
% ============================================================================
fprintf('[3/10] Khoi tao cau truc du lieu...\n');

% Khoi tao cac bien luu ket qua cho moi phuong phap
% 7 phuong phap: CC_time, GCC, PHAT, ROTH, SCOT, ECKART, HT
n_methods = 7;
n_SNR = length(SNR);

% Ma tran luu tat ca uoc luong do tre (Nm x n_methods x n_SNR)
D = zeros(N_MonteCarlo, n_SNR);           % CC_time
Dgcc = zeros(N_MonteCarlo, n_SNR);        % GCC
Dphat = zeros(N_MonteCarlo, n_SNR);       % PHAT
DRoth = zeros(N_MonteCarlo, n_SNR);      % ROTH
DScot = zeros(N_MonteCarlo, n_SNR);      % SCOT
DEckart = zeros(N_MonteCarlo, n_SNR);    % ECKART
Dml = zeros(N_MonteCarlo, n_SNR);        % HT (ML)

% Cac bien luu ket qua thong ke
delai_estime = zeros(n_SNR, 1);
delai_estime_gcc = zeros(n_SNR, 1);
delai_estime_phat = zeros(n_SNR, 1);
delai_estime_Roth = zeros(n_SNR, 1);
delai_estime_scot = zeros(n_SNR, 1);
delai_estime_Eckart = zeros(n_SNR, 1);
delai_estime_ml = zeros(n_SNR, 1);

% ============================================================================
% PHAN 4: MO PHONG MONTE CARLO
% ============================================================================
fprintf('[4/10] Chay mo phong Monte Carlo (%d lan lap)...\n', N_MonteCarlo);

% Tao ham cua so Hanning cho phuong phap Welch
win = hanning(h_Length);
n_overlap = length(win) / 2;     % 50% chong chap

% Vong lap chinh cho moi muc SNR
for ns = 1:n_SNR
    fprintf('  SNR = %d dB\n', SNR(ns));
    
    % Vong lap Monte Carlo
    for i = 1:N_MonteCarlo
        % In tien trinh moi 20 lan lap
        if mod(i, 20) == 0
            fprintf('    Lan lap %d/%d\n', i, N_MonteCarlo);
        end
        
        % Buoc 4.1: Tao tin hieu sEMG gia lap
        % Su dung ham sEMG_Generator de tao 4 kenh tin hieu voi do tre khac nhau
        [Vec_Signal, T, b] = signal.generateSEMG('simu_semg', N, p, delai_attendu, Fs);
        s1 = Vec_Signal(:, 1);   % Kenh 1 (tham chieu, khong co do tre)
        s2 = Vec_Signal(:, 2);   % Kenh 2 (co do tre delai_attendu)
        
        % Buoc 4.2: Them nhieu vao tin hieu
        % Them nhieu trang Gaussian de dat SNR mong muon
        s1_noise = s1 + sqrt(var(s1) * 10^(-SNR(ns)/10)) * randn(size(s1));
        s2_noise = s2 + sqrt(var(s2) * 10^(-SNR(ns)/10)) * randn(size(s2));
        
        % Buoc 4.3: Tinh cac pho (PSD) su dung phuong phap Welch
        % Tinh pho tu dong (auto-PSD) va pho cheo (cross-PSD)
        [Pxx] = cpsd(s1_noise, s1_noise, win, n_overlap, nfft, Fs, 'twosided');
        [Pyy] = cpsd(s2_noise, s2_noise, win, n_overlap, nfft, Fs, 'twosided');
        [Pxy] = cpsd(s1_noise, s2_noise, win, n_overlap, nfft, Fs, 'twosided');
        
        % Buoc 4.4: Tinh pho ly thuyet cho cac phuong phap ECKART va HT
        % Tinh phuong sai nhieu
        Gn1n1 = var(s1) * 10^(-SNR(ns)/10);
        Gn2n2 = var(s2) * 10^(-SNR(ns)/10);
        
        % Tinh pho tu dong cua tin hieu co nhieu
        % Quan trong: PSD da co kich thuoc nfft, nen Gx1x1 cung se co kich thuoc nfft
        % Dam bao cung kich thuoc voi Pxy tu cpsd
        Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
        Gx1x1 = Gx1x1(:);         % Chuyen thanh vector cot
        Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
        Gx2x2 = Gx2x2(:);         % Chuyen thanh vector cot
        
        % Pho tin hieu sach
        Gss = PSD(:);             % Chuyen thanh vector cot
        
        % Buoc 4.5: Ap dung cac phuong phap GCC
        % Phuong phap 1: CC_time - Tuong quan cheo mien thoi gian
        [Rx1x2, ~] = xcorr(s1_noise, s2_noise, length(s1_noise)/2);
        Rx1x2 = Rx1x2(1:end-1);
        [~, cctime] = max(abs(Rx1x2));
        ccestime = abs(N/2 - cctime + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if cctime > 1 && cctime < length(Rx1x2)
            D(i, ns) = ccestime - 0.5 * (Rx1x2(cctime+1) - Rx1x2(cctime-1)) / ...
                       (Rx1x2(cctime+1) - 2*Rx1x2(cctime) + Rx1x2(cctime-1));
        else
            D(i, ns) = ccestime;
        end
        
        % Phuong phap 2: GCC - Generalized Cross-Correlation co ban
        gcccorrelation = fftshift(ifft(Pxy));
        [~, gcctime] = max(abs(gcccorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        % gcccorrelation co kich thuoc nfft, nhung delay can tinh theo N
        gcctime_scaled = round((gcctime - nfft/2) * N / nfft + N/2);
        gccestime = abs(N/2 - gcctime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if gcctime > 1 && gcctime < length(gcccorrelation)
            % Tinh do lech tu diem cuc dai
            delta = 0.5 * (gcccorrelation(gcctime+1) - gcccorrelation(gcctime-1)) / ...
                    (gcccorrelation(gcctime+1) - 2*gcccorrelation(gcctime) + gcccorrelation(gcctime-1));
            % Chuyen doi delta ve don vi N
            delta_scaled = delta * N / nfft;
            Dgcc(i, ns) = gccestime - delta_scaled;
        else
            Dgcc(i, ns) = gccestime;
        end
        
        % Phuong phap 3: ROTH - Bo xu ly Roth
        % Dam bao Pxy va Gx1x1 cung kich thuoc
        if length(Pxy) ~= length(Gx1x1)
            % Neu khac kich thuoc, chuan hoa Gx1x1 ve kich thuoc cua Pxy
            Gx1x1_resized = interp1(1:length(Gx1x1), Gx1x1, linspace(1, length(Gx1x1), length(Pxy)), 'linear');
        else
            Gx1x1_resized = Gx1x1;
        end
        Rothcorrelation = fftshift(ifft(Pxy ./ Gx1x1_resized));
        [~, Rothtime] = max(abs(Rothcorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        Rothtime_scaled = round((Rothtime - nfft/2) * N / nfft + N/2);
        Rothestime = abs(N/2 - Rothtime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if Rothtime > 1 && Rothtime < length(Rothcorrelation)
            delta = 0.5 * (Rothcorrelation(Rothtime+1) - Rothcorrelation(Rothtime-1)) / ...
                    (Rothcorrelation(Rothtime+1) - 2*Rothcorrelation(Rothtime) + Rothcorrelation(Rothtime-1));
            delta_scaled = delta * N / nfft;
            DRoth(i, ns) = Rothestime - delta_scaled;
        else
            DRoth(i, ns) = Rothestime;
        end
        
        % Phuong phap 4: SCOT - Smoothed Coherence Transform
        % Dam bao cung kich thuoc
        if length(Pxy) ~= length(Gx2x2)
            Gx2x2_resized = interp1(1:length(Gx2x2), Gx2x2, linspace(1, length(Gx2x2), length(Pxy)), 'linear');
        else
            Gx2x2_resized = Gx2x2;
        end
        Scotcorrelation = fftshift(ifft(Pxy ./ sqrt(Gx1x1_resized .* Gx2x2_resized)));
        [~, Scottime] = max(abs(Scotcorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        Scottime_scaled = round((Scottime - nfft/2) * N / nfft + N/2);
        Scotestime = abs(N/2 - Scottime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if Scottime > 1 && Scottime < length(Scotcorrelation)
            delta = 0.5 * (Scotcorrelation(Scottime+1) - Scotcorrelation(Scottime-1)) / ...
                    (Scotcorrelation(Scottime+1) - 2*Scotcorrelation(Scottime) + Scotcorrelation(Scottime-1));
            delta_scaled = delta * N / nfft;
            DScot(i, ns) = Scotestime - delta_scaled;
        else
            DScot(i, ns) = Scotestime;
        end
        
        % Phuong phap 5: PHAT - Phase Transform
        % Dam bao cung kich thuoc
        if length(Pxy) ~= length(Gss)
            Gss_resized = interp1(1:length(Gss), Gss, linspace(1, length(Gss), length(Pxy)), 'linear');
        else
            Gss_resized = Gss;
        end
        phatcorrelation = fftshift(ifft(Pxy ./ (Gss_resized + 0.1)));
        [~, phattime] = max(abs(phatcorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        phattime_scaled = round((phattime - nfft/2) * N / nfft + N/2);
        phatestime = abs(N/2 - phattime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if phattime > 1 && phattime < length(phatcorrelation)
            delta = 0.5 * (phatcorrelation(phattime+1) - phatcorrelation(phattime-1)) / ...
                    (phatcorrelation(phattime+1) - 2*phatcorrelation(phattime) + phatcorrelation(phattime-1));
            delta_scaled = delta * N / nfft;
            Dphat(i, ns) = phatestime - delta_scaled;
        else
            Dphat(i, ns) = phatestime;
        end
        
        % Phuong phap 6: ECKART - Bo loc Eckart
        % Gss_resized da duoc tinh o phuong phap PHAT
        Eckartcorrelation = fftshift(ifft(Pxy .* Gss_resized ./ (Gn1n1 .* Gn2n2)));
        [~, Eckarttime] = max(abs(Eckartcorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        Eckarttime_scaled = round((Eckarttime - nfft/2) * N / nfft + N/2);
        Eckartestime = abs(N/2 - Eckarttime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if Eckarttime > 1 && Eckarttime < length(Eckartcorrelation)
            delta = 0.5 * (Eckartcorrelation(Eckarttime+1) - Eckartcorrelation(Eckarttime-1)) / ...
                    (Eckartcorrelation(Eckarttime+1) - 2*Eckartcorrelation(Eckarttime) + Eckartcorrelation(Eckarttime-1));
            delta_scaled = delta * N / nfft;
            DEckart(i, ns) = Eckartestime - delta_scaled;
        else
            DEckart(i, ns) = Eckartestime;
        end
        
        % Phuong phap 7: HT - Hannan-Thomson (Maximum Likelihood)
        % Gss_resized da duoc tinh o phuong phap PHAT
        denominator_ht = Gss_resized .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2;
        mlcorrelation = fftshift(ifft(Pxy .* Gss_resized ./ denominator_ht));
        [~, mltime] = max(abs(mlcorrelation));
        % Chuyen doi tu index trong nfft sang delay theo N
        mltime_scaled = round((mltime - nfft/2) * N / nfft + N/2);
        mlestime = abs(N/2 - mltime_scaled + 1);
        % Noi suy Parabola (kiem tra bien truoc)
        if mltime > 1 && mltime < length(mlcorrelation)
            delta = 0.5 * (mlcorrelation(mltime+1) - mlcorrelation(mltime-1)) / ...
                    (mlcorrelation(mltime+1) - 2*mlcorrelation(mltime) + mlcorrelation(mltime-1));
            delta_scaled = delta * N / nfft;
            Dml(i, ns) = mlestime - delta_scaled;
        else
            Dml(i, ns) = mlestime;
        end
    end
end

% ============================================================================
% PHAN 5: TINH CAC CHI SO THONG KE
% ============================================================================
fprintf('[5/10] Tinh cac chi so thong ke...\n');

% Tinh trung binh, bias, phuong sai, do lech chuan, RMSE cho moi phuong phap
for ns = 1:n_SNR
    % Phuong phap CC_time
    delai_estime(ns) = mean(D(:, ns));
    bias_cc = delai_estime(ns) - delai_attendu;
    Var_cc = var(D(:, ns));
    ecart_type_cc = sqrt(Var_cc);
    EQM_cc = bias_cc^2 + Var_cc;
    
    % Phuong phap GCC
    delai_estime_gcc(ns) = mean(Dgcc(:, ns));
    bias_gcc = delai_estime_gcc(ns) - delai_attendu;
    Var_gcc = var(Dgcc(:, ns));
    ecart_type_gcc = sqrt(Var_gcc);
    EQM_gcc = sqrt(bias_gcc^2 + Var_gcc);
    
    % Phuong phap ROTH
    delai_estime_Roth(ns) = mean(DRoth(:, ns));
    bias_Roth = delai_estime_Roth(ns) - delai_attendu;
    Var_Roth = var(DRoth(:, ns));
    ecart_type_Roth = sqrt(Var_Roth);
    EQM_Roth = sqrt(bias_Roth^2 + Var_Roth);
    
    % Phuong phap SCOT
    delai_estime_scot(ns) = mean(DScot(:, ns));
    bias_scot = delai_estime_scot(ns) - delai_attendu;
    Var_scot = var(DScot(:, ns));
    ecart_type_scot = sqrt(Var_scot);
    EQM_scot = sqrt(bias_scot^2 + Var_scot);
    
    % Phuong phap PHAT
    delai_estime_phat(ns) = mean(Dphat(:, ns));
    bias_phat = delai_estime_phat(ns) - delai_attendu;
    Var_phat = var(Dphat(:, ns));
    ecart_type_phat = sqrt(Var_phat);
    EQM_phat = sqrt(bias_phat^2 + Var_phat);
    
    % Phuong phap ECKART
    delai_estime_Eckart(ns) = mean(DEckart(:, ns));
    bias_Eckart = delai_estime_Eckart(ns) - delai_attendu;
    Var_Eckart = var(DEckart(:, ns));
    ecart_type_Eckart = sqrt(Var_Eckart);
    EQM_Eckart = sqrt(bias_Eckart^2 + Var_Eckart);
    
    % Phuong phap HT (ML)
    delai_estime_ml(ns) = mean(Dml(:, ns));
    bias_ml = delai_estime_ml(ns) - delai_attendu;
    Var_ml = var(Dml(:, ns));
    ecart_type_ml = sqrt(Var_ml);
    EQM_ml = sqrt(bias_ml^2 + Var_ml);
end

% ============================================================================
% PHAN 6: IN KET QUA
% ============================================================================
fprintf('[6/10] In ket qua...\n');

fprintf('\n========================================================================\n');
fprintf('                    DELAY ESTIMATION RESULTS\n');
fprintf('                    KET QUA UOC LUONG DO TRE\n');
fprintf('========================================================================\n\n');

for ns = 1:n_SNR
    fprintf('SNR = %d dB\n', SNR(ns));
    fprintf('------------------------------------------------------------------------\n');
    fprintf('%-15s %12s %12s %12s %12s\n', 'Method', 'Mean', 'Bias', 'Std', 'RMSE');
    fprintf('------------------------------------------------------------------------\n');
    
    % In ket qua cho tung phuong phap
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'CC_time', ...
            delai_estime(ns), delai_estime(ns) - delai_attendu, ...
            sqrt(var(D(:, ns))), sqrt((delai_estime(ns) - delai_attendu)^2 + var(D(:, ns))));
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'GCC', ...
            delai_estime_gcc(ns), delai_estime_gcc(ns) - delai_attendu, ...
            sqrt(var(Dgcc(:, ns))), EQM_gcc);
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'ROTH', ...
            delai_estime_Roth(ns), delai_estime_Roth(ns) - delai_attendu, ...
            sqrt(var(DRoth(:, ns))), EQM_Roth);
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'SCOT', ...
            delai_estime_scot(ns), delai_estime_scot(ns) - delai_attendu, ...
            sqrt(var(DScot(:, ns))), EQM_scot);
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'PHAT', ...
            delai_estime_phat(ns), delai_estime_phat(ns) - delai_attendu, ...
            sqrt(var(Dphat(:, ns))), EQM_phat);
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'ECKART', ...
            delai_estime_Eckart(ns), delai_estime_Eckart(ns) - delai_attendu, ...
            sqrt(var(DEckart(:, ns))), EQM_Eckart);
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'HT', ...
            delai_estime_ml(ns), delai_estime_ml(ns) - delai_attendu, ...
            sqrt(var(Dml(:, ns))), EQM_ml);
    
    fprintf('\n');
end

fprintf('========================================================================\n\n');

% ============================================================================
% PHAN 7: TIM PHUONG PHAP TOT NHAT
% ============================================================================
fprintf('[7/10] Tim phuong phap tot nhat...\n\n');

fprintf('Best methods at each SNR level:\n');
fprintf('Phuong phap tot nhat tai moi muc SNR:\n');
fprintf('--------------------------------\n');

for ns = 1:n_SNR
    % Tinh RMSE cho tat ca phuong phap
    rmse_cc = sqrt((delai_estime(ns) - delai_attendu)^2 + var(D(:, ns)));
    rmse_gcc = EQM_gcc;
    rmse_roth = EQM_Roth;
    rmse_scot = EQM_scot;
    rmse_phat = EQM_phat;
    rmse_eckart = EQM_Eckart;
    rmse_ml = EQM_ml;
    
    % Tim phuong phap co RMSE thap nhat
    rmse_all = [rmse_cc, rmse_gcc, rmse_roth, rmse_scot, rmse_phat, rmse_eckart, rmse_ml];
    method_names = {'CC_time', 'GCC', 'ROTH', 'SCOT', 'PHAT', 'ECKART', 'HT'};
    [best_rmse, best_idx] = min(rmse_all);
    
    fprintf('SNR = %2d dB: %s (RMSE = %.4f samples)\n', ...
            SNR(ns), method_names{best_idx}, best_rmse);
end
fprintf('\n');

% ============================================================================
% PHAN 8: TAO BIEU DO TRUC QUAN
% ============================================================================
fprintf('[8/10] Tao bieu do...\n');

% Tao bieu do so sanh cac phuong phap
visualization.plotResults(D, Dgcc, DRoth, DScot, Dphat, DEckart, Dml, ...
                          SNR, delai_attendu, N_MonteCarlo);

% ============================================================================
% PHAN 9: LUU KET QUA
% ============================================================================
fprintf('[9/10] Luu ket qua...\n');

% Luu tat ca ket qua vao file .mat
save('gcc_simulation_results.mat', 'D', 'Dgcc', 'DRoth', 'DScot', 'Dphat', ...
     'DEckart', 'Dml', 'SNR', 'Fs', 'delai_attendu', 'Var_cc', 'bias_cc', ...
     'ecart_type_cc', 'Var_gcc', 'bias_gcc', 'ecart_type_gcc', ...
     'Var_phat', 'ecart_type_phat', 'bias_phat', 'Var_Roth', 'bias_Roth', ...
     'ecart_type_Roth', 'Var_ml', 'bias_ml', 'ecart_type_ml', ...
     'Var_scot', 'bias_scot', 'ecart_type_scot', 'Var_Eckart', 'bias_Eckart', ...
     'ecart_type_Eckart', 'EQM_gcc', 'EQM_Roth', 'EQM_scot', 'EQM_ml', ...
     'EQM_phat', 'EQM_Eckart');

fprintf('Ket qua da luu vao: gcc_simulation_results.mat\n');

% ============================================================================
% PHAN 10: KET THUC
% ============================================================================
fprintf('[10/10] Mo phong hoan thanh!\n\n');
fprintf('========================================\n');
fprintf('  Total iterations: %d\n', N_MonteCarlo * n_SNR);
fprintf('  Methods compared: %d\n', n_methods);
fprintf('  SNR levels: %d\n', n_SNR);
fprintf('========================================\n\n');

