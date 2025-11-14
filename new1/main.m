% ==============================================================================
% TEN FILE: main.m
% CHUC NANG: Chuong trinh chinh nang cao uoc luong MFCV su dung cac phuong phap GCC
% MODULE: main
% ==============================================================================
%
% Mo ta: Chuong trinh chinh nang cao uoc luong toc do dan truyen soi co bap (MFCV)
%        su dung cac phuong phap tuong quan cheo tong quat (GCC)
%
% Tinh nang nang cao:
% - Validation dau vao tu dong
% - Logging va error handling tot hon
% - Ho tro parallel processing
% - Export nhieu dinh dang
% - Visualization nang cao
% - Batch processing
%
clear; close all; clc;

% Khoi tao logger
logger = logger.Logger(true, '');

% PHAN 1: NAP CAU HINH
logger.info('========================================');
logger.info('  GCC-BASED MFCV ESTIMATION SIMULATION');
logger.info('  MO PHONG UOC LUONG MFCV BANG GCC');
logger.info('  PHIEN BAN NANG CAO');
logger.info('========================================\n');

logger.info('[1/10] Loading configuration...');
cfg = config();

% Validation cau hinh
if cfg.validate_config
    try
        validation.validateConfig(cfg);
        logger.info('Configuration validated successfully');
    catch ME
        logger.error('Configuration validation failed: %s', ME.message);
        if cfg.stop_on_error
            error('Stopping due to configuration error');
        end
    end
end

% PHAN 2: TINH PSD LY THUYET
logger.info('[2/10] Calculating Farina-Merletti PSD...');
PSD = signal.calculatePSD(cfg.N, cfg.Fs);
logger.info('PSD calculated: %d points', length(PSD));

% PHAN 3: KHOI TAO CAU TRUC DU LIEU
logger.info('[3/10] Initializing data structures...');
n_methods = length(cfg.methods);
n_SNR = length(cfg.SNR);

delays = zeros(cfg.Nm, n_methods, n_SNR);
results = cell(n_methods, n_SNR);

logger.info('Initialized: %d methods, %d SNR levels, %d MC iterations', ...
            n_methods, n_SNR, cfg.Nm);

% PHAN 4: MO PHONG MONTE CARLO
logger.info('[4/10] Running Monte Carlo simulation (%d iterations)...', cfg.Nm);

% Tao ham cua so cho phuong phap Welch
switch lower(cfg.window_type)
    case 'hanning'
        win = hanning(cfg.h_Length);
    case 'hamming'
        win = hamming(cfg.h_Length);
    case 'blackman'
        win = blackman(cfg.h_Length);
    otherwise
        win = hanning(cfg.h_Length);
        logger.warning('Unknown window type "%s", using hanning', cfg.window_type);
end

n_overlap = round(cfg.h_Length * cfg.overlap_ratio);

% Vong lap mo phong chinh
total_iterations = cfg.Nm * n_SNR;
current_iteration = 0;

for iSNR = 1:n_SNR
    logger.info('  Processing SNR = %d dB', cfg.SNR(iSNR));
    
    % Kiem tra parallel processing
    if cfg.use_parallel && exist('parfor', 'builtin')
        % Parallel processing (neu co Parallel Toolbox)
        try
            parfor iMC = 1:cfg.Nm
                [delays(iMC, :, iSNR), ~] = runSingleIteration(...
                    cfg, PSD, win, n_overlap, iSNR, iMC);
            end
            logger.info('    Completed %d iterations using parallel processing', cfg.Nm);
        catch ME
            logger.warning('Parallel processing failed: %s. Using sequential.', ME.message);
            cfg.use_parallel = false;
        end
    end
    
    % Sequential processing (mac dinh hoac neu parallel that bai)
    if ~cfg.use_parallel || ~exist('parfor', 'builtin')
        for iMC = 1:cfg.Nm
            [delays(iMC, :, iSNR), ~] = runSingleIteration(...
                cfg, PSD, win, n_overlap, iSNR, iMC);
            
            current_iteration = current_iteration + 1;
            if mod(current_iteration, 20) == 0
                logger.progress(current_iteration, total_iterations, 'Progress');
            end
        end
    end
end

logger.info('\nMonte Carlo simulation completed');

% PHAN 5: TINH CAC CHI SO THONG KE
logger.info('[5/10] Calculating statistics...');
for iSNR = 1:n_SNR
    for iMethod = 1:n_methods
        delay_estimates = delays(:, iMethod, iSNR);
        results{iMethod, iSNR} = metrics.calculateStats(delay_estimates, cfg.delay_expected);
    end
end
logger.info('Statistics calculated');

% PHAN 6: IN KET QUA
logger.info('[6/10] Printing results...');
metrics.printResultsTable(results, cfg.SNR, cfg.methods);

% PHAN 7: TIM PHUONG PHAP TOT NHAT
logger.info('[7/10] Identifying best methods...\n');
logger.info('Best methods at each SNR level:');
logger.info('--------------------------------');

for iSNR = 1:n_SNR
    [best_method, best_rmse] = metrics.findBestMethod(results, cfg.methods, iSNR);
    logger.info('SNR = %2d dB: %s (RMSE = %.4f samples)', ...
                cfg.SNR(iSNR), best_method, best_rmse);
end

% PHAN 8: TAO BIEU DO TRUC QUAN
logger.info('\n[8/10] Creating visualizations...');
if cfg.show_plots
    visualization.plotResults(results, cfg.SNR, cfg.methods, cfg.results_dir);
    visualization.plotRMSEComparison(results, cfg.SNR, cfg.methods, cfg.results_dir);
    logger.info('Plots created and saved');
end

% PHAN 9: XUAT KET QUA
logger.info('[9/10] Exporting results...');
if cfg.save_results
    if ~exist(cfg.results_dir, 'dir')
        mkdir(cfg.results_dir);
    end
    
    % Xuat ra MAT (mac dinh)
    mat_file = fullfile(cfg.results_dir, 'gcc_simulation_results.mat');
    save(mat_file, 'results', 'delays', 'cfg', 'PSD');
    logger.info('Results saved to: %s', mat_file);
    
    % Xuat ra cac dinh dang khac neu duoc yeu cau
    if ~isempty(cfg.export_formats)
        exporter.exportResults(results, delays, cfg, cfg.results_dir, cfg.export_formats);
    end
end

% PHAN 10: KET THUC
logger.info('[10/10] Simulation complete!\n');
logger.info('========================================');
logger.info('  Total iterations: %d', cfg.Nm * n_SNR);
logger.info('  Methods compared: %d', n_methods);
logger.info('  SNR levels: %d', n_SNR);
logger.info('========================================\n');

% ============================================================================
% HAM HO TRO: CHAY MOT LAN LAP MONTE CARLO
% ============================================================================
function [method_delays, success] = runSingleIteration(cfg, PSD, win, n_overlap, iSNR, iMC)

method_delays = zeros(1, length(cfg.methods));
success = true;

try
    % Buoc 1: Tao tin hieu sEMG gia lap
    [Vec_Signal, ~, ~] = signal.generateSEMG('simu_semg', cfg.N, cfg.p, ...
                                              cfg.delay_expected, cfg.Fs);
    s1 = Vec_Signal(:, 1);
    s2 = Vec_Signal(:, 2);
    
    % Buoc 2: Them nhieu vao tin hieu
    s1_noise = signal.addNoise(s1, cfg.SNR(iSNR));
    s2_noise = signal.addNoise(s2, cfg.SNR(iSNR));
    
    % Tien xu ly tin hieu neu duoc yeu cau
    if cfg.remove_dc
        s1_noise = s1_noise - mean(s1_noise);
        s2_noise = s2_noise - mean(s2_noise);
    end
    
    if cfg.normalize_signals
        s1_noise = s1_noise / max(abs(s1_noise));
        s2_noise = s2_noise / max(abs(s2_noise));
    end
    
    % Buoc 3: Tinh cac pho (PSD)
    [Pxx, Pyy, Pxy] = preprocessing.computeSpectra(s1_noise, s2_noise, ...
                                                   win, n_overlap, cfg.nfft, cfg.Fs);
    
    % Buoc 4: Tinh pho ly thuyet (can cho ECKART va HT)
    [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = preprocessing.computeTheoreticalSpectra(...
                                          PSD, s1, s2, cfg.SNR(iSNR));
    
    % Buoc 5: Ap dung cac phuong phap GCC
    for iMethod = 1:length(cfg.methods)
        try
            switch cfg.methods{iMethod}
                case 'CC_time'
                    method_delays(iMethod) = gcc.ccTime(s1_noise, s2_noise, cfg.N);
                    
                case 'PHAT'
                    method_delays(iMethod) = gcc.gccPHAT(Pxy, Gss, cfg.N);
                    
                case 'ROTH'
                    method_delays(iMethod) = gcc.gccROTH(Pxy, Gx1x1, cfg.N);
                    
                case 'SCOT'
                    method_delays(iMethod) = gcc.gccSCOT(Pxy, Gx1x1, Gx2x2, cfg.N);
                    
                case 'ECKART'
                    method_delays(iMethod) = gcc.gccECKART(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);
                    
                case 'HT'
                    method_delays(iMethod) = gcc.gccHT(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);
                    
                case 'GCC_Basic'
                    method_delays(iMethod) = gcc.gccBasic(Pxy, cfg.N);
                    
                otherwise
                    warning('Unknown method: %s', cfg.methods{iMethod});
                    method_delays(iMethod) = NaN;
            end
        catch ME
            warning('Error in method %s: %s', cfg.methods{iMethod}, ME.message);
            method_delays(iMethod) = NaN;
            if cfg.stop_on_error
                rethrow(ME);
            end
        end
    end
    
catch ME
    warning('Error in iteration %d: %s', iMC, ME.message);
    method_delays(:) = NaN;
    success = false;
    if cfg.stop_on_error
        rethrow(ME);
    end
end

end

