%% =====================================================================
%% UỚC LƯỢNG TỐC ĐỘ DẪN TRUYỀN CƠ (MUSCLE CONDUCTION VELOCITY)
%% Sử dụng các phương pháp Generalized Cross-Correlation (GCC)
%% =====================================================================
%
% MÔ TẢ:
%   Chương trình mô phỏng ước lượng độ trễ (time delay) giữa 2 kênh tín hiệu
%   sEMG (surface electromyography) bằng các biến thể của GCC.
%
% CÁC PHƯƠNG PHÁP:
%   1. CC_time - Cross-Correlation trong miền thời gian (xcorr)
%   2. GCC     - Generalized Cross-Correlation: IFFT{Pxy}
%   3. PHAT    - Phase Transform: Pxy / |Pxy|
%   4. ROTH    - Roth Processor: Pxy / Pxx
%   5. SCOT    - Smoothed Coherence Transform: Pxy / sqrt(Pxx*Pyy)
%   6. ECKART  - Eckart Filter
%   7. HT      - Hannan-Thompson (Maximum Likelihood)
%
% KẾT QUẢ:
%   - Tính toán: Bias, Variance, Standard Deviation, MSE (EQM), RMSE
%   - Vẽ biểu đồ so sánh các phương pháp theo SNR
%   - Lưu kết quả vào thư mục ./results/
%
% CÁCH CHẠY:
%   1. Chạy file Parameter_Script_cohF.m để tạo tham số
%   2. Chạy file main.m này
%
% YÊU CẦU:
%   - MATLAB R2016a trở lên
%   - Signal Processing Toolbox
%   - File: Parameter_Script_cohF.mat (tạo bởi Parameter_Script_cohF.m)
%   - Hàm: sEMG_Generator.m
%
% TÁC GIẢ: Research Team
% NGÀY CẬP NHẬT: 2025
%% =====================================================================

clear; clc; close all;
fprintf('=== BẮT ĐẦU MÔ PHỎNG ƯỚC LƯỢNG TỐC ĐỘ DẪN TRUYỀN CƠ ===\n\n');

%% ===== 1. NẠP THAM SỐ HỆ THỐNG =====
fprintf('1. Đang nạp tham số hệ thống...\n');

if exist('Parameter_Script_cohF.mat','file')
    load Parameter_Script_cohF;
    fprintf('   ✓ Đã nạp Parameter_Script_cohF.mat\n');
elseif exist('Parameter_Script_cohF.m','file')
    run('Parameter_Script_cohF.m');
    fprintf('   ✓ Đã chạy Parameter_Script_cohF.m\n');
else
    warning('   ⚠ Không tìm thấy Parameter_Script_cohF. Sử dụng giá trị mặc định.');
end

% Giá trị mặc định an toàn
if ~exist('N','var'),        N  = 2048;  end
if ~exist('Fs','var'),       Fs = 2048;  end
if ~exist('p','var'),        p  = 0.5;   end
if ~exist('h_Length','var') || isempty(h_Length), h_Length = 128; end

fprintf('   - Số mẫu (N): %d\n', N);
fprintf('   - Tần số lấy mẫu (Fs): %d Hz\n', Fs);
fprintf('   - Chiều dài cửa sổ (h_Length): %d\n\n', h_Length(1));

%% ===== 2. CẤU HÌNH MÔ PHỎNG =====
fprintf('2. Cấu hình mô phỏng...\n');

Nm            = 100;              % Số lần Monte Carlo
SNR           = [0 10 20];        % Các mức SNR (dB)
delai_attendu = 4.9;              % Độ trễ thực tế (đơn vị: mẫu)
use_parabolic = true;             % Sử dụng nội suy parabol
epsd          = 1e-6;             % Hằng số nhỏ tránh chia 0

fprintf('   - Số lần Monte Carlo: %d\n', Nm);
fprintf('   - Các mức SNR: [%s] dB\n', num2str(SNR));
fprintf('   - Độ trễ kỳ vọng: %.2f mẫu\n\n', delai_attendu);

% Cửa sổ cho CPSD
winlen   = double(h_Length(1));
win      = hanning(winlen);
noverlap = floor(winlen/2);
nfft     = N;

%% ===== 3. TÍNH PSD CỦA TÍN HIỆU sEMG (Farina-Merletti Model) =====
fprintf('3. Tính Power Spectral Density (Farina-Merletti)...\n');

fh = 120; fl = 60; kPSD = 1;
f  = linspace(0, Fs, N);
PSD = kPSD * fh^4 .* f.^2 ./ ((f.^2 + fl^2) .* (f.^2 + fh^2).^2);
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
PSD = PSD ./ max(PSD);
Gss = PSD(:);

fprintf('   ✓ Đã tính PSD\n\n');

%% ===== 4. KHỞI TẠO CẤU TRÚC DỮ LIỆU =====
fprintf('4. Khởi tạo cấu trúc dữ liệu...\n');

meth_list = {'CC_time', 'GCC', 'PHAT', 'ROTH', 'SCOT', 'ECKART', 'HT'};
M = numel(meth_list);
delay_est = struct();
for k = 1:M
    delay_est.(meth_list{k}) = nan(Nm, numel(SNR));
end

fprintf('   ✓ Đã khởi tạo cho %d phương pháp\n\n', M);

%% ===== 5. HÀM PHỤ TRỢ: NỘI SUY PARABOL =====
% Hàm nội suy parabol để tăng độ chính xác ước lượng đỉnh
parabolic_refine = @(r, idx) ...
    ( idx > 1 && idx < numel(r) ) .* ...
    ( idx - 0.5 * (r(idx+1) - r(idx-1)) / (r(idx+1) - 2*r(idx) + r(idx-1) + epsd) ) ...
    + ( (idx <= 1) | (idx >= numel(r)) ) .* idx;

%% ===== 6. VÒNG LẶP MÔ PHỎNG MONTE CARLO =====
fprintf('5. Bắt đầu mô phỏng Monte Carlo...\n');
fprintf('   Tổng số lần chạy: %d x %d = %d\n', numel(SNR), Nm, numel(SNR)*Nm);
fprintf('   Tiến độ: ');

total_iter = numel(SNR) * Nm;
current_iter = 0;

for ns = 1:numel(SNR)
    for i = 1:Nm
        current_iter = current_iter + 1;

        % Hiển thị tiến độ
        if mod(current_iter, 50) == 0 || current_iter == total_iter
            fprintf('%.0f%% ', (current_iter/total_iter)*100);
        end

        % --- Sinh tín hiệu sEMG ---
        [Vec_Signal, ~, ~] = sEMG_Generator('simu_semg', N, p, delai_attendu, Fs);
        s1 = Vec_Signal(:,1);
        s2 = Vec_Signal(:,2);

        % --- Chèn nhiễu Gaussian theo SNR ---
        sigma1 = sqrt(var(s1) * 10^(-SNR(ns)/10));
        sigma2 = sqrt(var(s2) * 10^(-SNR(ns)/10));
        s1n = s1 + sigma1 * randn(size(s1));
        s2n = s2 + sigma2 * randn(size(s2));

        % --- Tính Power Spectral Density (PSD) - Two-sided ---
        [Pxy, ~] = cpsd(s1n, s2n, win, noverlap, nfft, Fs, 'twosided');
        Pxx      = cpsd(s1n, s1n, win, noverlap, nfft, Fs, 'twosided');
        Pyy      = cpsd(s2n, s2n, win, noverlap, nfft, Fs, 'twosided');

        % ===== PHƯƠNG PHÁP 1: CC_time (Cross-Correlation trong miền thời gian) =====
        [Rxt, ~] = xcorr(s1n, s2n, floor(N/2));
        [~, idx_t] = max(abs(Rxt));
        if use_parabolic
            idx_t = round(parabolic_refine(abs(Rxt), idx_t));
        end
        center_t = floor(numel(Rxt)/2) + 1;
        delay_CC_time = abs(idx_t - center_t);
        delay_est.CC_time(i, ns) = delay_CC_time;

        % ===== PHƯƠNG PHÁP 2-7: GCC các biến thể trong miền tần số =====
        AbsPxy = abs(Pxy);
        F = struct();

        % Định nghĩa các bộ lọc GCC
        F.GCC    = Pxy;                                                    % GCC cơ bản
        F.PHAT   = Pxy ./ (AbsPxy + epsd);                                 % Phase Transform
        F.ROTH   = Pxy ./ (Pxx + epsd);                                    % Roth Processor
        F.SCOT   = Pxy ./ sqrt(Pxx .* Pyy + epsd);                        % SCOT
        F.ECKART = (Pxy .* AbsPxy) ./ ((Pxx - AbsPxy).*(Pyy - AbsPxy) + epsd); % Eckart
        F.HT     = Pxy ./ (Pxx + Pyy + epsd);                             % Hannan-Thompson

        % Tính toán độ trễ cho mỗi phương pháp GCC
        gcc_names = fieldnames(F);
        for m = 1:numel(gcc_names)
            R = fftshift(ifft(F.(gcc_names{m})));
            [~, idx] = max(abs(R));
            if use_parabolic
                idx = round(parabolic_refine(abs(R), idx));
            end
            center = floor(numel(R)/2) + 1;
            dly = abs(idx - center);

            % Lưu kết quả
            switch gcc_names{m}
                case 'GCC',    delay_est.GCC(i, ns)    = dly;
                case 'PHAT',   delay_est.PHAT(i, ns)   = dly;
                case 'ROTH',   delay_est.ROTH(i, ns)   = dly;
                case 'SCOT',   delay_est.SCOT(i, ns)   = dly;
                case 'ECKART', delay_est.ECKART(i, ns) = dly;
                case 'HT',     delay_est.HT(i, ns)     = dly;
            end
        end
    end
end

fprintf('\n   ✓ Hoàn thành mô phỏng\n\n');

%% ===== 7. TÍNH TOÁN THỐNG KÊ =====
fprintf('6. Tính toán các chỉ số thống kê...\n');

bias = struct();
Var = struct();
Std = struct();
EQM = struct();
RMSE = struct();

for k = 1:M
    name = meth_list{k};
    mu   = mean(delay_est.(name), 1, 'omitnan');      % Giá trị trung bình
    vv   = var(delay_est.(name), 0, 1, 'omitnan');    % Phương sai

    bias.(name) = mu - delai_attendu;                 % Bias (độ lệch)
    Var.(name)  = vv;                                 % Variance (phương sai)
    Std.(name)  = sqrt(vv);                           % Standard Deviation (độ lệch chuẩn)
    EQM.(name)  = bias.(name).^2 + vv;                % MSE - Mean Squared Error
    RMSE.(name) = sqrt(EQM.(name));                   % RMSE - Root Mean Squared Error
end

fprintf('   ✓ Đã tính: Bias, Variance, Std, MSE, RMSE\n\n');

%% ===== 8. VẼ BIỂU ĐỒ =====
fprintf('7. Vẽ biểu đồ...\n');

% 8.1) Biểu đồ Standard Deviation cho từng phương pháp
fprintf('   - Vẽ biểu đồ Standard Deviation (Std)...\n');
names_for_std = {'CC_time', 'ECKART', 'ROTH', 'HT', 'PHAT', 'SCOT', 'GCC'};
titles_for_std = { ...
    'Phương pháp: CC\_time (Cross-Correlation)', ...
    'Phương pháp: ECKART (Eckart Filter)', ...
    'Phương pháp: ROTH (Roth Processor)', ...
    'Phương pháp: HT (Hannan-Thompson)', ...
    'Phương pháp: PHAT (Phase Transform)', ...
    'Phương pháp: SCOT (Smoothed Coherence Transform)', ...
    'Phương pháp: GCC (Generalized Cross-Correlation)'
};

for jj = 1:numel(names_for_std)
    figure('Name', ['Std - ' names_for_std{jj}]);
    bar(Std.(names_for_std{jj}));
    set(gca, 'XTick', 1:length(SNR), 'XTickLabel', string(SNR(:)));
    xlabel('SNR (dB)');
    ylabel('Độ lệch chuẩn (mẫu)');
    title(titles_for_std{jj});
    grid on;
end

% 8.2) Biểu đồ MSE (EQM) cho từng phương pháp
fprintf('   - Vẽ biểu đồ Mean Squared Error (MSE)...\n');
for jj = 1:numel(names_for_std)
    figure('Name', ['MSE - ' names_for_std{jj}]);
    bar(EQM.(names_for_std{jj}));
    set(gca, 'XTick', 1:length(SNR), 'XTickLabel', string(SNR(:)));
    xlabel('SNR (dB)');
    ylabel('MSE (mẫu^2)');
    title(['MSE - ' titles_for_std{jj}]);
    grid on;
end

% 8.3) Biểu đồ so sánh RMSE tất cả phương pháp
fprintf('   - Vẽ biểu đồ so sánh RMSE tổng hợp...\n');
figure('Name', 'So sánh RMSE');
hold on; grid on;
colors = lines(M);
for k = 1:M
    plot(SNR, RMSE.(meth_list{k}), '-o', ...
        'LineWidth', 2, ...
        'MarkerSize', 8, ...
        'Color', colors(k,:), ...
        'DisplayName', meth_list{k});
end
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('RMSE (mẫu)', 'FontSize', 12);
title('So sánh RMSE ước lượng độ trễ theo SNR', 'FontSize', 14);
legend('Location', 'northeast', 'FontSize', 10);
hold off;

fprintf('   ✓ Đã vẽ %d biểu đồ\n\n', 2*numel(names_for_std) + 1);

%% ===== 9. IN BẢNG TỔNG KẾT =====
fprintf('8. Bảng tổng kết kết quả:\n\n');
fprintf('┌─────────────┬');
for ns = 1:numel(SNR)
    fprintf('──────────┬');
end
fprintf('\n');
fprintf('│ Phương pháp │');
for ns = 1:numel(SNR)
    fprintf(' SNR=%2ddB │', SNR(ns));
end
fprintf('\n');
fprintf('├─────────────┼');
for ns = 1:numel(SNR)
    fprintf('──────────┼');
end
fprintf('\n');

for k = 1:M
    fprintf('│ %-11s │', meth_list{k});
    for ns = 1:numel(SNR)
        fprintf(' %8.4f │', RMSE.(meth_list{k})(ns));
    end
    fprintf('\n');
end

fprintf('└─────────────┴');
for ns = 1:numel(SNR)
    fprintf('──────────┴');
end
fprintf('\n\n');

%% ===== 10. LƯU KẾT QUẢ =====
fprintf('9. Lưu kết quả...\n');

% Tạo thư mục results nếu chưa có
outdir = fullfile(pwd, 'results');
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

% Lưu file .mat
outfile_mat = fullfile(outdir, 'gcc_results.mat');
save(outfile_mat, 'delay_est', 'bias', 'Var', 'Std', 'EQM', 'RMSE', ...
     'SNR', 'Fs', 'N', 'delai_attendu', 'winlen', 'nfft', 'Nm', ...
     'meth_list', '-v7.3');
fprintf('   ✓ Đã lưu file MAT: %s\n', outfile_mat);

% Lưu file CSV
T = table();
T.SNR_dB = SNR(:);
for k = 1:M
    T.([meth_list{k} '_RMSE']) = RMSE.(meth_list{k})(:);
    T.([meth_list{k} '_Std'])  = Std.(meth_list{k})(:);
    T.([meth_list{k} '_MSE'])  = EQM.(meth_list{k})(:);
    T.([meth_list{k} '_Bias']) = bias.(meth_list{k})(:);
end
outfile_csv = fullfile(outdir, 'gcc_metrics.csv');
writetable(T, outfile_csv);
fprintf('   ✓ Đã lưu file CSV: %s\n', outfile_csv);

% Lưu hình ảnh
fprintf('   - Đang lưu biểu đồ...\n');
figHandles = findall(0, 'Type', 'figure');
for i = 1:length(figHandles)
    fig = figHandles(i);
    figname = get(fig, 'Name');
    if ~isempty(figname)
        % Thay thế ký tự không hợp lệ trong tên file
        figname = strrep(figname, ' ', '_');
        figname = strrep(figname, '-', '_');
        figname = strrep(figname, ':', '');
        filename = fullfile(outdir, [figname '.png']);
        saveas(fig, filename);
    end
end
fprintf('   ✓ Đã lưu %d biểu đồ\n\n', length(figHandles));

%% ===== KẾT THÚC =====
fprintf('=== HOÀN THÀNH MÔ PHỎNG ===\n');
fprintf('Kết quả đã được lưu vào thư mục: %s\n\n', outdir);
fprintf('Phương pháp tốt nhất (RMSE thấp nhất ở SNR=20dB):\n');

% Tìm phương pháp tốt nhất
[min_rmse, best_idx] = min(cellfun(@(x) RMSE.(x)(end), meth_list));
fprintf('  → %s: RMSE = %.4f mẫu\n\n', meth_list{best_idx}, min_rmse);
