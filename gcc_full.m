%% ================== gcc_full.m ==================
% Mo ta:
% - Mo phong uoc luong do tre (delay) giua 2 kenh sEMG bang cac bien the GCC:
%   CC_time (xcorr thoi gian), GCC (Pxy), PHAT, ROTH, SCOT, ECKART, HT (ML gan dung).
% - Tinh bias, Var, ecart_type (Std), EQM (MSE), RMSE theo tung muc SNR va ve bieu do.
% - Luu ket qua vao ./results/ (khong ghi file "gcc" trong vong lap).
%
% Yeu cau:
% - Can file Parameter_Script_cohF.mat hoac .m de co N, Fs, p (tham so tao tin hieu).
% - Ham sEMG_Generator('simu_semg', N, p, delay, Fs) tra ve Vec_Signal(:,1:2).

clear; clc; close all;

%% ===== Nap tham so he thong =====
if exist('Parameter_Script_cohF.mat','file')
    load Parameter_Script_cohF;     % ky vong co N, Fs, p, (co the co h_Length)
elseif exist('Parameter_Script_cohF.m','file')
    run('Parameter_Script_cohF.m');
else
    warning('Khong tim thay Parameter_Script_cohF.*. Dung gia tri mac dinh.');
end

% Gia tri mac dinh an toan
if ~exist('N','var'),        N  = 2048;  end
if ~exist('Fs','var'),       Fs = 2048;  end
if ~exist('p','var'),        p  = 0.5;   end
if ~exist('h_Length','var') || isempty(h_Length), h_Length = 128; end

%% ===== Cau hinh mo phong =====
Nm            = 100;              % so lan Monte Carlo
SNR           = [0 10 20];        % muc SNR (dB) theo file goc
delai_attendu = 4.9;              % delay thuc te (don vi: mau)
use_parabolic = true;             % noi suy parabol quanh dinh (bao ve bien)
epsd          = 1e-6;             % hang nho tranh chia 0

% Cua so cho CPSD (lay phan tu dau cua h_Length neu no la vector)
winlen   = double(h_Length(1));
win      = hanning(winlen);
noverlap = floor(winlen/2);
nfft     = N;

%% ===== PSD sEMG (Farina-Merletti) de giu tinh dong nhat voi de tai =====
fh = 120; fl = 60; kPSD = 1;
f  = linspace(0,Fs,N);
PSD = kPSD*fh.^4.*f.^2 ./ ((f.^2+fl.^2).*(f.^2+fh.^2).^2);
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
PSD = PSD./max(PSD);
Gss = PSD(:);

%% ===== Danh sach phuong phap va bo nho =====
meth_list = {'CC_time','GCC','PHAT','ROTH','SCOT','ECKART','HT'};
M = numel(meth_list);
delay_est = struct();
for k = 1:M
    delay_est.(meth_list{k}) = nan(Nm, numel(SNR));   % [Nm x |SNR|]
end

%% ===== Ham phu tro =====
parabolic_refine = @(r, idx) ...
    ( idx > 1 && idx < numel(r) ) .* ...
    ( idx - 0.5 * (r(idx+1) - r(idx-1)) / (r(idx+1) - 2*r(idx) + r(idx-1) + epsd) ) ...
    + ( (idx <= 1) | (idx >= numel(r)) ) .* idx;

%% ===== Vong lap Monte Carlo =====
for ns = 1:numel(SNR)
    for i = 1:Nm
        % --- Sinh tin hieu ---
        [Vec_Signal, ~, ~] = sEMG_Generator('simu_semg', N, p, delai_attendu, Fs);
        s1 = Vec_Signal(:,1);
        s2 = Vec_Signal(:,2);

        % --- Chen nhieu Gaussian theo SNR (khong dung std truc tiep) ---
        sigma1 = sqrt(var(s1) * 10^(-SNR(ns)/10));
        sigma2 = sqrt(var(s2) * 10^(-SNR(ns)/10));
        s1n = s1 + sigma1 * randn(size(s1));
        s2n = s2 + sigma2 * randn(size(s2));

        % --- Pho cong suat cheo/tu (two-sided) ---
        [Pxy, ~] = cpsd(s1n, s2n, win, noverlap, nfft, Fs, 'twosided');
        Pxx      = cpsd(s1n, s1n, win, noverlap, nfft, Fs, 'twosided');
        Pyy      = cpsd(s2n, s2n, win, noverlap, nfft, Fs, 'twosided');

        % ===== 1) CC_time: xcorr thoi gian =====
        [Rxt, ~] = xcorr(s1n, s2n, floor(N/2));
        [~, idx_t] = max(abs(Rxt));
        if use_parabolic, idx_t = round(parabolic_refine(abs(Rxt), idx_t)); end
        center_t = floor(numel(Rxt)/2) + 1;
        delay_CC_time = abs(idx_t - center_t);
        delay_est.CC_time(i, ns) = delay_CC_time;

        % ===== 2..7) GCC bien the trong mien tan so =====
        AbsPxy = abs(Pxy);
        F = struct();
        F.GCC    = Pxy;                                 % GCC ~ IFFT{Pxy}
        F.PHAT   = Pxy ./ (AbsPxy + epsd);              % PHAT
        F.ROTH   = Pxy ./ (Pxx + epsd);                 % Roth
        F.SCOT   = Pxy ./ sqrt(Pxx.*Pyy + epsd);        % SCOT
        F.ECKART = (Pxy .* AbsPxy) ./ ((Pxx - AbsPxy).*(Pyy - AbsPxy) + epsd); % Eckart
        F.HT     = Pxy ./ (Pxx + Pyy + epsd);           % HT (Hannan-Thompson/ML don gian)

        gcc_names = fieldnames(F);
        for m = 1:numel(gcc_names)
            R = fftshift(ifft(F.(gcc_names{m})));
            [~, idx] = max(abs(R));
            if use_parabolic, idx = round(parabolic_refine(abs(R), idx)); end
            center = floor(numel(R)/2) + 1;
            dly = abs(idx - center);

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

%% ===== Thong ke: bias, Var, Std (ecart_type), EQM, RMSE =====
bias = struct(); Var = struct(); Std = struct(); EQM = struct(); RMSE = struct();
for k = 1:M
    name = meth_list{k};
    mu   = mean(delay_est.(name), 1, 'omitnan');          % [1 x |SNR|]
    vv   = var(delay_est.(name),  0, 1, 'omitnan');
    bias.(name) = mu - delai_attendu;
    Var.(name)  = vv;
    Std.(name)  = sqrt(vv);                               % ecart_type
    EQM.(name)  = bias.(name).^2 + vv;                    % MSE (samples^2)
    RMSE.(name) = sqrt(EQM.(name));                       % RMSE (samples)
end

%% ===== Ve bieu do giong file goc =====
% 1) Bar ecart_type (Std) cho tung phuong phap rieng le (giong cac figure rieng)
%    File goc ve rieng: CC, Eckart, Roth, HT, PHAT (SCOT co the bo sung tuong tu).
%    ? ?ây v? ??y ?? cho: CC_time, ECKART, ROTH, HT, PHAT, SCOT, GCC.
names_for_std = {'CC_time','ECKART','ROTH','HT','PHAT','SCOT','GCC'};
titles_for_std = { ...
    'Phuong phap: "CC\_time"', ...
    'Phuong phap: "Eckart"', ...
    'Phuong phap: "Roth"', ...
    'Phuong phap: "HT"', ...
    'Phuong phap: "PHAT"', ...
    'Phuong phap: "SCOT"', ...
    'Phuong phap: "GCC"'
};
for jj = 1:numel(names_for_std)
    figure;
    bar(Std.(names_for_std{jj}));
    set(gca,'XTick',1:length(SNR),'XTickLabel',string(SNR(:)));
    xlabel('SNR (dB)'); ylabel('Ecart-type (mau)');
    title(titles_for_std{jj}); grid on;
end

% 2) Bar EQM (MSE) cho tung phuong phap rieng (nhu file goc)
for jj = 1:numel(names_for_std)
    figure;
    bar(EQM.(names_for_std{jj}));
    set(gca,'XTick',1:length(SNR),'XTickLabel',string(SNR(:)));
    xlabel('SNR (dB)'); ylabel('EQM (mau^2)');
    title(['EQM - ' titles_for_std{jj}]); grid on;
end

% 3) ???ng RMSE t?ng h?p (t?t c? ph??ng pháp trên cùng m?t hình)
figure; hold on; grid on;
for k = 1:M
    plot(SNR, RMSE.(meth_list{k}), '-o', 'LineWidth', 1.5, 'DisplayName', meth_list{k});
end
xlabel('SNR (dB)'); ylabel('RMSE (mau)');
title('So sanh RMSE uoc luong delay theo SNR'); legend('Location','northwest');

%% ===== In bang tong ket (SNR x phuong phap) =====
fprintf('\n=== Tong ket (theo SNR) ===\n');
fprintf('Phuong phap\\SNR\t'); fprintf('%6.0f dB\t', SNR); fprintf('\n');
for k = 1:M
    fprintf('%-10s\t', meth_list{k});
    fprintf('%8.4f\t', RMSE.(meth_list{k}));
    fprintf('\n');
end

%% ===== Luu ket qua =====
outdir = fullfile(pwd, 'results');
if ~exist(outdir,'dir'), mkdir(outdir); end

outfile_mat = fullfile(outdir, 'gcc_results.mat');
save(outfile_mat, 'delay_est','bias','Var','Std','EQM','RMSE','SNR','Fs','N','delai_attendu','winlen','nfft','Nm','-v7.3');

% Luu CSV: RMSE + Std + EQM cho moi phuong phap
T = table(); T.SNR_dB = SNR(:);
for k = 1:M
    T.([meth_list{k} '_RMSE']) = RMSE.(meth_list{k})(:);
    T.([meth_list{k} '_Std'])  = Std.(meth_list{k})(:);
    T.([meth_list{k} '_EQM'])  = EQM.(meth_list{k})(:);
end
outfile_csv = fullfile(outdir, 'gcc_metrics.csv');
writetable(T, outfile_csv);

fprintf('Da luu ket qua vao:\n  %s\n  %s\n', outfile_mat, outfile_csv);
