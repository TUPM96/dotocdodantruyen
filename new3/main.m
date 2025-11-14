% ==============================================================================
% TEN FILE: main.m
% CHUC NANG: Chuong trinh chinh uoc luong MFCV su dung 6 phuong phap GCC
% MODULE: main
% ==============================================================================
%
% Mo ta: Chuong trinh chinh uoc luong toc do dan truyen soi co bap (MFCV)
%        su dung cac phuong phap tuong quan cheo tong quat (GCC)
%        Tich hop tat ca tham so tu Parameter_Script_cohF.m vao day
%
% 6 phuong phap duoc so sanh:
%   1. CC_time  - Tuong quan cheo mien thoi gian (co ban)
%   2. ROTH     - Bo xu ly Roth (chuan hoa 1 kenh)
%   3. SCOT     - Smoothed Coherence Transform (chuan hoa doi xung)
%   4. PHAT     - Phase Transform (tay trang pho)
%   5. ECKART   - Bo loc Eckart (toi uu SNR)
%   6. HT       - Hannan-Thomson (Maximum Likelihood - toi uu nhat)
%

close all; clear all;

% ============================================================================
% PHAN 1: THIET LAP THAM SO (Tich hop tu Parameter_Script_cohF.m)
% ============================================================================
fprintf('\n========================================\n');
fprintf('  GCC-BASED MFCV ESTIMATION SIMULATION\n');
fprintf('  MO PHONG UOC LUONG MFCV BANG GCC\n');
fprintf('  6 PHUONG PHAP (KHONG CO GCC)\n');
fprintf('========================================\n\n');

fprintf('[1/10] Thiet lap tham so mo phong...\n');

% Tham so Monte Carlo
N_MonteCarlo = 100;              % So lan lap Monte Carlo
Nm = N_MonteCarlo;              % Ten khac (tu origin)
SNR = [0 10 20];                 % Cac muc SNR (dB)

% Tham so tin hieu
Duration = 0.125;                % Thoi luong mo phong (giay) = 125ms
Fs = 2048;                       % Tan so lay mau (Hz)
N = Duration * Fs;              % So diem tin hieu = 256 mau
nfft = N;                        % Do dai FFT (tu origin: nfft=N)
p = 40;                          % So he so cho bo loc tao do tre (dung trong sEMG_Generator)

% Tham so phan tich tan so
Bandwidth = [15 200];            % Dai tan so phan tich (Hz)
RegLinStart = round(Bandwidth(1) * nfft / Fs + 1);  % Chi so bat dau cho hoi quy tuyen tinh
RegLinStop = round(Bandwidth(2) * nfft / Fs + 1);   % Chi so ket thuc cho hoi quy tuyen tinh
nF = (0:nfft-1) / nfft;         % Truc tan so chuan hoa (0 den 1)
f = nF(RegLinStart:RegLinStop) * Fs;  % Chuyen doi truc tan so sang Hz
n = 1:N;                         % Truc tan so cho hien thi du lieu
h_Length = [128];                % Kich thuoc cua so cho phuong phap Welch

% Tham so soi co bap
CV_Scale = [2 6];                % Khoang toc do dan truyen (m/s): min va max
DeltaE = 5 * 10^(-3);            % Khoang cach giua dien cuc (m) = 5mm

% Tham so do tre mong doi
% Tu origin: load Parameter_Script_cohF; delai_attendu=[4.9]; CV_attendu=5.10^-3/(4.9/2048);
delai_attendu = 4.9;             % Do tre mong doi (mau)
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
f_psd = linspace(0, Fs, N);      % Truc tan so cho PSD

% Cong thuc PSD Farina-Merletti
% Tham khao: D. Farina and R. Merletti, "Comparison of algorithms for 
%            estimation of EMG variables during voluntary contractions",
%            Journal of Electromyography and Kinesiology, vol. 10, 
%            pp. 337-349, 2000.
PSD = k * fh.^4 .* f_psd.^2 ./ ((f_psd.^2 + fl.^2) .* (f_psd.^2 + fh.^2).^2);

% Tao pho doi xung cho tin hieu thuc
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

% Chuan hoa PSD
PSD = PSD ./ max(PSD);

% ============================================================================
% PHAN 3: KHOI TAO CAU TRUC DU LIEU
% ============================================================================
fprintf('[3/10] Khoi tao cau truc du lieu...\n');

% Khoi tao cac bien luu ket qua cho moi phuong phap
% 6 phuong phap: CC_time, ROTH, SCOT, PHAT, ECKART, HT
n_SNR = length(SNR);

% Ma tran luu tat ca uoc luong do tre (Nm x n_SNR)
D = zeros(Nm, n_SNR);            % CC_time
DRoth = zeros(Nm, n_SNR);       % ROTH
DScot = zeros(Nm, n_SNR);       % SCOT
Dphat = zeros(Nm, n_SNR);       % PHAT
DEckart = zeros(Nm, n_SNR);     % ECKART
Dml = zeros(Nm, n_SNR);         % HT (ML)

% Cac bien luu ket qua thong ke
delai_estime = zeros(n_SNR, 1);
delai_estime_Roth = zeros(n_SNR, 1);
delai_estime_scot = zeros(n_SNR, 1);
delai_estime_phat = zeros(n_SNR, 1);
delai_estime_Eckart = zeros(n_SNR, 1);
delai_estime_ml = zeros(n_SNR, 1);

% ============================================================================
% PHAN 4: MO PHONG MONTE CARLO
% ============================================================================
fprintf('[4/10] Chay mo phong Monte Carlo (%d lan lap)...\n', Nm);

% Vong lap chinh cho moi muc SNR
for ns = 1:n_SNR
    fprintf('  SNR = %d dB\n', SNR(ns));
    
    % Tao ham cua so Hanning cho phuong phap Welch
    win = hanning(h_Length);
    n_overlap = length(win) / 2;     % 50% chong chap
    
    % Vong lap Monte Carlo
    for i = 1:Nm
        % In tien trinh moi 20 lan lap
        if mod(i, 20) == 0
            fprintf('    Lan lap %d/%d\n', i, Nm);
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
        % Tu origin: [Pxx] = cpsd( s1_noise, s1_noise, win, n_overlap, nfft, Fs,'twoside');
        [Pxx] = cpsd(s1_noise, s1_noise, win, n_overlap, nfft, Fs, 'twoside');
        [Pyy] = cpsd(s2_noise, s2_noise, win, n_overlap, nfft, Fs, 'twoside');
        [Pxy] = cpsd(s1_noise, s2_noise, win, n_overlap, nfft, Fs, 'twoside');
        
        % Buoc 4.4: Tinh pho ly thuyet cho cac phuong phap ECKART va HT
        % Tinh phuong sai nhieu
        Gn1n1 = var(s1) * 10^(-SNR(ns)/10);
        Gn2n2 = var(s2) * 10^(-SNR(ns)/10);
        
        % Tinh pho tu dong cua tin hieu co nhieu
        % Tu origin: Gx1x1=PSD*var(s1)/mean(PSD)+Gn1n1; Gx1x1=Gx1x1';
        Gx1x1 = PSD * var(s1) / mean(PSD) + Gn1n1;
        Gx1x1 = Gx1x1';
        Gx2x2 = PSD * var(s2) / mean(PSD) + Gn2n2;
        Gx2x2 = Gx2x2';
        
        % Pho tin hieu sach
        Gss = PSD';
        
        % Buoc 4.5: Ap dung cac phuong phap GCC
        % Phuong phap 1: CC_time - Tuong quan cheo mien thoi gian
        [Rx1x2, lag1] = xcorr(s1_noise, s2_noise, length(s1_noise)/2);
        Rx1x2 = Rx1x2(1:end-1);
        lag1 = lag1(1:end-1);
        [ccmaximum, cctime] = max(Rx1x2);
        ccestime = abs(N/2 - cctime + 1);
        % Noi suy Parabola
        D(i, ns) = ccestime - 0.5 * (Rx1x2(cctime+1) - Rx1x2(cctime-1)) / ...
                   (Rx1x2(cctime+1) - 2*Rx1x2(cctime) + Rx1x2(cctime-1));
        
        % Phuong phap 2: ROTH - Bo xu ly Roth
        % Tu origin: Rothcorrelation=fftshift(ifft(Pxy./Gx1x1));
        Rothcorrelation = fftshift(ifft(Pxy ./ Gx1x1));
        [Rothmaximum, Rothtime] = max(Rothcorrelation);
        Rothestime = abs(N/2 - Rothtime + 1);
        % Noi suy Parabola
        DRoth(i, ns) = Rothestime - 0.5 * (Rothcorrelation(Rothtime+1) - Rothcorrelation(Rothtime-1)) / ...
                       (Rothcorrelation(Rothtime+1) - 2*Rothcorrelation(Rothtime) + Rothcorrelation(Rothtime-1));
        
        % Phuong phap 3: SCOT - Smoothed Coherence Transform
        % Tu origin: Scotcorrelation=fftshift((ifft(Pxy./sqrt(Gx1x1.*Gx2x2))));
        Scotcorrelation = fftshift(ifft(Pxy ./ sqrt(Gx1x1 .* Gx2x2)));
        [Scotmaximum, Scottime] = max(Scotcorrelation);
        Scotestime = abs(N/2 - Scottime + 1);
        % Noi suy Parabola
        DScot(i, ns) = Scotestime - 0.5 * (Scotcorrelation(Scottime+1) - Scotcorrelation(Scottime-1)) / ...
                       (Scotcorrelation(Scottime+1) - 2*Scotcorrelation(Scottime) + Scotcorrelation(Scottime-1));
        
        % Phuong phap 4: PHAT - Phase Transform
        % Tu origin: phatcorrelation=fftshift(ifft(Pxy./(Gss+0.1)));
        phatcorrelation = fftshift(ifft(Pxy ./ (Gss + 0.1)));
        [phatmaximum, phattime] = max(phatcorrelation);
        phatestime = abs(N/2 - phattime + 1);
        % Noi suy Parabola
        Dphat(i, ns) = phatestime - 0.5 * (phatcorrelation(phattime+1) - phatcorrelation(phattime-1)) / ...
                       (phatcorrelation(phattime+1) - 2*phatcorrelation(phattime) + phatcorrelation(phattime-1));
        
        % Phuong phap 5: ECKART - Bo loc Eckart
        % Tu origin: Eckartcorrelation=fftshift(ifft(Pxy.*Gss./(Gn1n1.*Gn2n2)));
        Eckartcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gn1n1 .* Gn2n2)));
        [Eckartmaximum, Eckarttime] = max(Eckartcorrelation);
        Eckartestime = abs(N/2 - Eckarttime + 1);
        % Noi suy Parabola
        DEckart(i, ns) = Eckartestime - 0.5 * (Eckartcorrelation(Eckarttime+1) - Eckartcorrelation(Eckarttime-1)) / ...
                         (Eckartcorrelation(Eckarttime+1) - 2*Eckartcorrelation(Eckarttime) + Eckartcorrelation(Eckarttime-1));
        
        % Phuong phap 6: HT - Hannan-Thomson (Maximum Likelihood)
        % Tu origin: mlcorrelation=fftshift(ifft(Pxy.*Gss./(Gss.*(Gn1n1+Gn2n2)+Gn1n1.*Gn2n2)));
        mlcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gss .* (Gn1n1 + Gn2n2) + Gn1n1 .* Gn2n2)));
        [mlmaximum, mltime] = max(mlcorrelation);
        mlestime = abs(N/2 - mltime + 1);
        % Noi suy Parabola
        Dml(i, ns) = mlestime - 0.5 * (mlcorrelation(mltime+1) - mlcorrelation(mltime-1)) / ...
                     (mlcorrelation(mltime+1) - 2*mlcorrelation(mltime) + mlcorrelation(mltime-1));
    end
end

% ============================================================================
% PHAN 5: TINH CAC CHI SO THONG KE
% ============================================================================
fprintf('[5/10] Tinh cac chi so thong ke...\n');

% Khoi tao cac bien luu EQM
EQM = zeros(n_SNR, 1);
EQM_Roth = zeros(n_SNR, 1);
EQM_scot = zeros(n_SNR, 1);
EQM_phat = zeros(n_SNR, 1);
EQM_Eckart = zeros(n_SNR, 1);
EQM_ml = zeros(n_SNR, 1);

% Tinh trung binh, bias, phuong sai, do lech chuan, RMSE cho moi phuong phap
for ns = 1:n_SNR
    % Phuong phap CC_time
    delai_estime(ns) = mean(D(:, ns));
    bias = delai_estime(ns) - delai_attendu;
    Var = var(D(:, ns));
    ecart_type = sqrt(Var);
    EQM(ns) = bias^2 + Var;
    
    % Phuong phap ROTH
    delai_estime_Roth(ns) = mean(DRoth(:, ns));
    bias_Roth = delai_estime_Roth(ns) - delai_attendu;
    Var_Roth = var(DRoth(:, ns));
    ecart_type_Roth = sqrt(Var_Roth);
    EQM_Roth(ns) = sqrt(bias_Roth^2 + Var_Roth);
    
    % Phuong phap SCOT
    delai_estime_scot(ns) = mean(DScot(:, ns));
    bias_scot = delai_estime_scot(ns) - delai_attendu;
    Var_scot = var(DScot(:, ns));
    ecart_type_scot = sqrt(Var_scot);
    EQM_scot(ns) = sqrt(bias_scot^2 + Var_scot);
    
    % Phuong phap PHAT
    delai_estime_phat(ns) = mean(Dphat(:, ns));
    bias_phat = delai_estime_phat(ns) - delai_attendu;
    Var_phat = var(Dphat(:, ns));
    ecart_type_phat = sqrt(Var_phat);
    EQM_phat(ns) = sqrt(bias_phat^2 + Var_phat);
    
    % Phuong phap ECKART
    delai_estime_Eckart(ns) = mean(DEckart(:, ns));
    bias_Eckart = delai_estime_Eckart(ns) - delai_attendu;
    Var_Eckart = var(DEckart(:, ns));
    ecart_type_Eckart = sqrt(Var_Eckart);
    EQM_Eckart(ns) = sqrt(bias_Eckart^2 + Var_Eckart);
    
    % Phuong phap HT (ML)
    delai_estime_ml(ns) = mean(Dml(:, ns));
    bias_ml = delai_estime_ml(ns) - delai_attendu;
    Var_ml = var(Dml(:, ns));
    ecart_type_ml = sqrt(Var_ml);
    EQM_ml(ns) = sqrt(bias_ml^2 + Var_ml);
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
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'ROTH', ...
            delai_estime_Roth(ns), delai_estime_Roth(ns) - delai_attendu, ...
            sqrt(var(DRoth(:, ns))), EQM_Roth(ns));
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'SCOT', ...
            delai_estime_scot(ns), delai_estime_scot(ns) - delai_attendu, ...
            sqrt(var(DScot(:, ns))), EQM_scot(ns));
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'PHAT', ...
            delai_estime_phat(ns), delai_estime_phat(ns) - delai_attendu, ...
            sqrt(var(Dphat(:, ns))), EQM_phat(ns));
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'ECKART', ...
            delai_estime_Eckart(ns), delai_estime_Eckart(ns) - delai_attendu, ...
            sqrt(var(DEckart(:, ns))), EQM_Eckart(ns));
    
    fprintf('%-15s %12.4f %12.4f %12.4f %12.4f\n', 'HT', ...
            delai_estime_ml(ns), delai_estime_ml(ns) - delai_attendu, ...
            sqrt(var(Dml(:, ns))), EQM_ml(ns));
    
    fprintf('\n');
end

fprintf('========================================================================\n\n');

% ============================================================================
% PHAN 7: TAO BIEU DO TRUC QUAN
% ============================================================================
fprintf('[7/10] Tao bieu do...\n');

% Tao bieu do so sanh cac phuong phap
visualization.plotResults(D, DRoth, DScot, Dphat, DEckart, Dml, ...
                          SNR, delai_attendu, Nm, EQM_scot);

% ============================================================================
% PHAN 8: LUU KET QUA
% ============================================================================
fprintf('[8/10] Luu ket qua...\n');

% Luu tat ca ket qua vao file .mat
save('gcc_simulation_results.mat', 'D', 'DRoth', 'DScot', 'Dphat', ...
     'DEckart', 'Dml', 'SNR', 'Fs', 'delai_attendu', 'EQM_Roth', ...
     'EQM_scot', 'EQM_phat', 'EQM_Eckart', 'EQM_ml');

fprintf('Ket qua da luu vao: gcc_simulation_results.mat\n');

% ============================================================================
% PHAN 9: KET THUC
% ============================================================================
fprintf('[9/10] Mo phong hoan thanh!\n\n');
fprintf('========================================\n');
fprintf('  Total iterations: %d\n', Nm * n_SNR);
fprintf('  Methods compared: 6 (CC_time, ROTH, SCOT, PHAT, ECKART, HT)\n');
fprintf('  SNR levels: %d\n', n_SNR);
fprintf('========================================\n\n');

