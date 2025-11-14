% ==============================================================================
% TEN FILE: main.m
% CHUC NANG: Chuong trinh chinh uoc luong MFCV su dung cac phuong phap GCC
% MODULE: main
% ==============================================================================
%
% Mo ta: Chuong trinh chinh uoc luong toc do dan truyen soi co bap (MFCV)
%        su dung cac phuong phap tuong quan cheo tong quat (GCC)
%
% MFCV la toc do truyen xung dien tren soi co, thong so quan trong danh gia
% tinh trang co bap va chan doan benh ly than kinh-co
% Uoc luong MFCV bang cach do do tre tin hieu sEMG giua cac dien cuc
% Cong thuc: MFCV = Khoang_cach_dien_cuc / Do_tre_thoi_gian
%
% Cac phuong phap GCC duoc so sanh (6 phuong phap chinh):
%   1. CC_time  - Tuong quan cheo mien thoi gian (co ban)
%   2. PHAT     - Phase Transform (tay trang pho)
%   3. ROTH     - Bo xu ly Roth (chuan hoa 1 kenh)
%   4. SCOT     - Smoothed Coherence Transform (chuan hoa doi xung)
%   5. ECKART   - Bo loc Eckart (toi uu SNR)
%   6. HT       - Hannan-Thomson (Maximum Likelihood - toi uu nhat)
%
% Quy trinh:
% 1. Nap cau hinh
% 2. Tinh PSD ly thuyet (Farina-Merletti)
% 3. Khoi tao cau truc du lieu
% 4. Chay mo phong Monte Carlo
% 5. Tinh cac chi so thong ke
% 6. In ket qua
% 7. Tim phuong phap tot nhat
% 8. Ve bieu do
% 9. Luu ket qua
% 10. Ket thuc
%

clear; close all; clc;

% PHAN 1: NAP CAU HINH
% Nap tat ca tham so mo phong tu file config.m
% Bao gom: so lan lap Monte Carlo, SNR, tan so lay mau, tham so co bap, v.v.
fprintf('\n========================================\n');
fprintf('  GCC-BASED MFCV ESTIMATION SIMULATION\n');
fprintf('  MO PHONG UOC LUONG MFCV BANG GCC\n');
fprintf('========================================\n\n');

fprintf('[1/10] Loading configuration...\n');
fprintf('[1/10] Dang nap cau hinh...\n');
cfg = config();

% PHAN 2: TINH PSD LY THUYET
% Tinh mat do pho cong suat (PSD) ly thuyet theo mo hinh Farina-Merletti
% Mo hinh chuan cho tin hieu sEMG
fprintf('[2/10] Calculating Farina-Merletti PSD...\n');
fprintf('[2/10] Dang tinh PSD Farina-Merletti...\n');
PSD = signal.calculatePSD(cfg.N, cfg.Fs);

% PHAN 3: KHOI TAO CAU TRUC DU LIEU
% Tao cac bien de luu tru ket qua mo phong
% delays: Luu tat ca uoc luong do tre tu moi lan lap Monte Carlo
% results: Luu cac chi so thong ke (mean, bias, RMSE, ...) cho moi phuong phap
fprintf('[3/10] Initializing data structures...\n');
fprintf('[3/10] Dang khoi tao cau truc du lieu...\n');

n_methods = length(cfg.methods);
n_SNR = length(cfg.SNR);

% Luu tru tat ca cac uoc luong do tre tu moi lan lap
% Kich thuoc: (Nm x n_methods x n_SNR)
delays = zeros(cfg.Nm, n_methods, n_SNR);

% Luu tru cac chi so thong ke da tinh toan
% Moi o chua mot cau truc voi cac truong: mean, bias, variance, std, mse, rmse
results = cell(n_methods, n_SNR);

% PHAN 4: MO PHONG MONTE CARLO
% Vong lap chinh cua mo phong
% Lap lai Nm lan voi nhieu ngau nhien khac nhau
% Moi lan: tao tin hieu, them nhieu, tinh pho, ap dung cac phuong phap GCC
% Muc dich: Danh gia hieu suat thong ke cua cac phuong phap
fprintf('[4/10] Running Monte Carlo simulation (%d iterations)...\n', cfg.Nm);
fprintf('[4/10] Dang chay mo phong Monte Carlo (%d lan lap)...\n', cfg.Nm);

% Tao ham cua so Hanning cho phuong phap Welch
win = hanning(cfg.h_Length);
n_overlap = cfg.h_Length / 2;

% Vong lap mo phong chinh
for iSNR = 1:n_SNR
    fprintf('  SNR = %d dB\n', cfg.SNR(iSNR));
    
    for iMC = 1:cfg.Nm
        % In tien trinh moi 20 lan lap
        if mod(iMC, 20) == 0
            fprintf('    Iteration %d/%d (Lan lap %d/%d)\n', iMC, cfg.Nm, iMC, cfg.Nm);
        end
        
        % Buoc 4.1: Tao tin hieu sEMG gia lap
        % Tao 4 kenh tin hieu voi do tre tang dan
        [Vec_Signal, ~, ~] = signal.generateSEMG('simu_semg', cfg.N, cfg.p, ...
                                                  cfg.delay_expected, cfg.Fs);
        s1 = Vec_Signal(:, 1);
        s2 = Vec_Signal(:, 2);
        
        % Buoc 4.2: Them nhieu vao tin hieu
        % Them nhieu trang Gaussian de dat SNR mong muon
        s1_noise = signal.addNoise(s1, cfg.SNR(iSNR));
        s2_noise = signal.addNoise(s2, cfg.SNR(iSNR));
        
        % Buoc 4.3: Tinh cac pho (PSD)
        % Tinh pho tu dong va pho cheo su dung phuong phap Welch
        [Pxx, Pyy, Pxy] = preprocessing.computeSpectra(s1_noise, s2_noise, ...
                                                       win, n_overlap, cfg.nfft, cfg.Fs);
        
        % Buoc 4.4: Tinh pho ly thuyet
        % Can cho cac phuong phap ECKART va HT
        [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = preprocessing.computeTheoreticalSpectra(...
                                              PSD, s1, s2, cfg.SNR(iSNR));
        
        % Buoc 4.5: Ap dung 6 phuong phap GCC chinh
        % Moi phuong phap tra ve mot uoc luong do tre
        
        % Phuong phap 1: CC_time - Tuong quan cheo mien thoi gian
        delays(iMC, 1, iSNR) = gcc.ccTime(s1_noise, s2_noise, cfg.N);
        
        % Phuong phap 2: PHAT - Tay trang pho
        delays(iMC, 2, iSNR) = gcc.gccPHAT(Pxy, Gss, cfg.N);
        
        % Phuong phap 3: ROTH - Chuan hoa theo pho kenh 1
        delays(iMC, 3, iSNR) = gcc.gccROTH(Pxy, Gx1x1, cfg.N);
        
        % Phuong phap 4: SCOT - Chuan hoa doi xung
        delays(iMC, 4, iSNR) = gcc.gccSCOT(Pxy, Gx1x1, Gx2x2, cfg.N);
        
        % Phuong phap 5: ECKART - Bo loc toi uu SNR
        delays(iMC, 5, iSNR) = gcc.gccECKART(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);
        
        % Phuong phap 6: HT - Maximum Likelihood (toi uu nhat)
        delays(iMC, 6, iSNR) = gcc.gccHT(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);
    end
end

% PHAN 5: TINH CAC CHI SO THONG KE
% Tinh cac chi so thong ke tu ket qua mo phong Monte Carlo
% Bao gom: mean, bias, variance, std, MSE, RMSE cho moi phuong phap o moi SNR
fprintf('[5/10] Calculating statistics...\n');
fprintf('[5/10] Dang tinh cac chi so thong ke...\n');

for iSNR = 1:n_SNR
    for iMethod = 1:n_methods
        % Lay tat ca uoc luong do tre cua phuong phap iMethod tai SNR iSNR
        delay_estimates = delays(:, iMethod, iSNR);
        % Tinh cac chi so thong ke
        results{iMethod, iSNR} = metrics.calculateStats(delay_estimates, cfg.delay_expected);
    end
end

% PHAN 6: IN KET QUA
% In bang ket qua dinh dang dep ra man hinh
fprintf('[6/10] Printing results...\n');
fprintf('[6/10] Dang in ket qua...\n');
metrics.printResultsTable(results, cfg.SNR, cfg.methods);

% PHAN 7: TIM PHUONG PHAP TOT NHAT
% Tim phuong phap co RMSE thap nhat tai moi muc SNR
fprintf('[7/10] Identifying best methods...\n');
fprintf('[7/10] Dang xac dinh phuong phap tot nhat...\n\n');
fprintf('Best methods at each SNR level:\n');
fprintf('Phuong phap tot nhat tai moi muc SNR:\n');
fprintf('--------------------------------\n');

for iSNR = 1:n_SNR
    [best_method, best_rmse] = metrics.findBestMethod(results, cfg.methods, iSNR);
    fprintf('SNR = %2d dB: %s (RMSE = %.4f samples)\n', ...
            cfg.SNR(iSNR), best_method, best_rmse);
end
fprintf('\n');

% PHAN 8: TAO BIEU DO TRUC QUAN
% Tao cac bieu do de so sanh truc quan hieu suat cac phuong phap
fprintf('[8/10] Creating visualizations...\n');
fprintf('[8/10] Dang tao bieu do...\n');

if cfg.show_plots
    % Bieu do tong hop: RMSE, Bias, Variance, Std vs SNR
    visualization.plotResults(results, cfg.SNR, cfg.methods, cfg.results_dir);
    
    % Bieu do cot so sanh RMSE
    visualization.plotRMSEComparison(results, cfg.SNR, cfg.methods, cfg.results_dir);
end

% PHAN 9: LUU KET QUA
% Luu tat ca ket qua vao file .mat de su dung sau nay
fprintf('[9/10] Saving results...\n');
fprintf('[9/10] Dang luu ket qua...\n');

if cfg.save_results
    % Tao thu muc ket qua neu chua ton tai
    if ~exist(cfg.results_dir, 'dir')
        mkdir(cfg.results_dir);
    end
    
    % Luu workspace vao file .mat
    save(fullfile(cfg.results_dir, 'gcc_simulation_results.mat'), ...
         'results', 'delays', 'cfg', 'PSD');
    
    fprintf('  Results saved to: %s/gcc_simulation_results.mat\n', cfg.results_dir);
    fprintf('  Ket qua da luu vao: %s/gcc_simulation_results.mat\n', cfg.results_dir);
end

% PHAN 10: KET THUC
% In thong bao ket thuc va tong ket mo phong
fprintf('[10/10] Simulation complete!\n');
fprintf('[10/10] Mo phong hoan thanh!\n\n');
fprintf('========================================\n');
fprintf('  Total iterations: %d\n', cfg.Nm * n_SNR);
fprintf('  Tong so lan lap: %d\n', cfg.Nm * n_SNR);
fprintf('  Methods compared: %d\n', n_methods);
fprintf('  So phuong phap so sanh: %d\n', n_methods);
fprintf('  SNR levels: %d\n', n_SNR);
fprintf('  So muc SNR: %d\n', n_SNR);
fprintf('========================================\n\n');
