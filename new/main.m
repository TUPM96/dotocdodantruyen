%% MAIN SCRIPT FOR GCC-BASED MFCV ESTIMATION
% Muscle Fiber Conduction Velocity (MFCV) estimation using
% Generalized Cross-Correlation (GCC) methods
%
% This script implements and compares 7 different GCC methods:
%   1. CC_time  - Time-domain cross-correlation
%   2. GCC      - Basic frequency-domain GCC
%   3. PHAT     - Phase Transform
%   4. ROTH     - Roth processor
%   5. SCOT     - Smoothed Coherence Transform
%   6. ECKART   - Eckart filter
%   7. HT       - Hannan-Thomson (Maximum Likelihood)

clear; close all; clc;

%% ========================================================================
%  SECTION 1: LOAD CONFIGURATION
%  ========================================================================
fprintf('\n========================================\n');
fprintf('  GCC-BASED MFCV ESTIMATION SIMULATION\n');
fprintf('========================================\n\n');

fprintf('[1/10] Loading configuration...\n');
cfg = config();

%% ========================================================================
%  SECTION 2: CALCULATE THEORETICAL PSD
%  ========================================================================
fprintf('[2/10] Calculating Farina-Merletti PSD...\n');
PSD = signal.calculatePSD(cfg.N, cfg.Fs);

%% ========================================================================
%  SECTION 3: INITIALIZE DATA STRUCTURES
%  ========================================================================
fprintf('[3/10] Initializing data structures...\n');

n_methods = length(cfg.methods);
n_SNR = length(cfg.SNR);

% Storage for delay estimates from each iteration
delays = zeros(cfg.Nm, n_methods, n_SNR);

% Storage for computed statistics
results = cell(n_methods, n_SNR);

%% ========================================================================
%  SECTION 4: MONTE CARLO SIMULATION
%  ========================================================================
fprintf('[4/10] Running Monte Carlo simulation (%d iterations)...\n', cfg.Nm);

% Create window for CPSD
win = hanning(cfg.h_Length);
n_overlap = cfg.h_Length / 2;

% Main simulation loop
for iSNR = 1:n_SNR
    fprintf('  SNR = %d dB\n', cfg.SNR(iSNR));

    for iMC = 1:cfg.Nm
        if mod(iMC, 20) == 0
            fprintf('    Iteration %d/%d\n', iMC, cfg.Nm);
        end

        %% Generate signals
        [Vec_Signal, ~, ~] = signal.generateSEMG('simu_semg', cfg.N, cfg.p, ...
                                                  cfg.delay_expected, cfg.Fs);
        s1 = Vec_Signal(:, 1);
        s2 = Vec_Signal(:, 2);

        %% Add noise
        s1_noise = signal.addNoise(s1, cfg.SNR(iSNR));
        s2_noise = signal.addNoise(s2, cfg.SNR(iSNR));

        %% Compute spectra
        [Pxx, Pyy, Pxy] = preprocessing.computeSpectra(s1_noise, s2_noise, ...
                                                       win, n_overlap, cfg.nfft, cfg.Fs);

        %% Compute theoretical spectra
        [Gx1x1, Gx2x2, Gss, Gn1n1, Gn2n2] = preprocessing.computeTheoreticalSpectra(...
                                              PSD, s1, s2, cfg.SNR(iSNR));

        %% Apply GCC methods
        % Method 1: CC_time
        delays(iMC, 1, iSNR) = gcc.ccTime(s1_noise, s2_noise, cfg.N);

        % Method 2: GCC (basic)
        delays(iMC, 2, iSNR) = gcc.gccBasic(Pxy, cfg.N);

        % Method 3: PHAT
        delays(iMC, 3, iSNR) = gcc.gccPHAT(Pxy, Gss, cfg.N);

        % Method 4: ROTH
        delays(iMC, 4, iSNR) = gcc.gccROTH(Pxy, Gx1x1, cfg.N);

        % Method 5: SCOT
        delays(iMC, 5, iSNR) = gcc.gccSCOT(Pxy, Gx1x1, Gx2x2, cfg.N);

        % Method 6: ECKART
        delays(iMC, 6, iSNR) = gcc.gccECKART(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);

        % Method 7: HT (Hannan-Thomson)
        delays(iMC, 7, iSNR) = gcc.gccHT(Pxy, Gss, Gn1n1, Gn2n2, cfg.N);
    end
end

%% ========================================================================
%  SECTION 5: CALCULATE STATISTICS
%  ========================================================================
fprintf('[5/10] Calculating statistics...\n');

for iSNR = 1:n_SNR
    for iMethod = 1:n_methods
        delay_estimates = delays(:, iMethod, iSNR);
        results{iMethod, iSNR} = metrics.calculateStats(delay_estimates, cfg.delay_expected);
    end
end

%% ========================================================================
%  SECTION 6: PRINT RESULTS
%  ========================================================================
fprintf('[6/10] Printing results...\n');
metrics.printResultsTable(results, cfg.SNR, cfg.methods);

%% ========================================================================
%  SECTION 7: FIND BEST METHODS
%  ========================================================================
fprintf('[7/10] Identifying best methods...\n\n');
fprintf('Best methods at each SNR level:\n');
fprintf('--------------------------------\n');

for iSNR = 1:n_SNR
    [best_method, best_rmse] = metrics.findBestMethod(results, cfg.methods, iSNR);
    fprintf('SNR = %2d dB: %s (RMSE = %.4f samples)\n', ...
            cfg.SNR(iSNR), best_method, best_rmse);
end
fprintf('\n');

%% ========================================================================
%  SECTION 8: CREATE VISUALIZATIONS
%  ========================================================================
fprintf('[8/10] Creating visualizations...\n');

if cfg.show_plots
    % Comprehensive results plot
    visualization.plotResults(results, cfg.SNR, cfg.methods, cfg.results_dir);

    % RMSE comparison bar chart
    visualization.plotRMSEComparison(results, cfg.SNR, cfg.methods, cfg.results_dir);
end

%% ========================================================================
%  SECTION 9: SAVE RESULTS
%  ========================================================================
fprintf('[9/10] Saving results...\n');

if cfg.save_results
    % Create results directory if it doesn't exist
    if ~exist(cfg.results_dir, 'dir')
        mkdir(cfg.results_dir);
    end

    % Save workspace
    save(fullfile(cfg.results_dir, 'gcc_simulation_results.mat'), ...
         'results', 'delays', 'cfg', 'PSD');

    fprintf('  Results saved to: %s/gcc_simulation_results.mat\n', cfg.results_dir);
end

%% ========================================================================
%  SECTION 10: COMPLETION
%  ========================================================================
fprintf('[10/10] Simulation complete!\n\n');
fprintf('========================================\n');
fprintf('  Total iterations: %d\n', cfg.Nm * n_SNR);
fprintf('  Methods compared: %d\n', n_methods);
fprintf('  SNR levels: %d\n', n_SNR);
fprintf('========================================\n\n');
