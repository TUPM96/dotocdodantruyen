% ==============================================================================
% TEN FILE: config.m
% CHUC NANG: Cau hinh nang cao cho mo phong uoc luong MFCV su dung GCC
% MODULE: config
% ==============================================================================
%
% Mo ta: Cau hinh tap trung va nang cao cho mo phong uoc luong toc do dan truyen
%        soi co (MFCV) su dung cac phuong phap GCC
%
% Tinh nang nang cao:
% - Nhieu tuy chon cau hinh hon
% - Ho tro parallel processing
% - Cau hinh export nhieu dinh dang
% - Tuy chon visualization nang cao
% - Validation tu dong
%
function cfg = config()

% ============================================================================
% THAM SO MO PHONG MONTE CARLO
% ============================================================================
cfg.Nm = 100;                    % So lan lap Monte Carlo
cfg.SNR = [0 10 20];            % Cac muc SNR (dB)
cfg.use_parallel = false;        % Su dung parallel processing (neu co Parallel Toolbox)
cfg.parallel_workers = 4;        % So worker cho parallel processing

% ============================================================================
% THAM SO TIN HIEU
% ============================================================================
cfg.Duration = 0.125;            % Thoi luong tin hieu (giay)
cfg.Fs = 2048;                   % Tan so lay mau (Hz)
cfg.N = cfg.Duration * cfg.Fs;   % So mau tin hieu
cfg.p = 40;                      % Bac bo loc FIR cho mo hinh hoa do tre phan so

% ============================================================================
% THAM SO PHAN TICH TAN SO
% ============================================================================
cfg.nfft = 2048;                 % Do dai FFT (nen la luy thua 2)
cfg.Bandwidth = [15 200];        % Dai tan so phan tich (Hz)
cfg.h_Length = 128;              % Do dai cua so cho tinh CPSD (Welch method)
cfg.window_type = 'hanning';     % Loai cua so: 'hanning', 'hamming', 'blackman'
cfg.overlap_ratio = 0.5;        % Ty le chong chap (0-1)

% ============================================================================
% THAM SO SOI CO BAP
% ============================================================================
cfg.CV_Scale = [2 6];            % Khoang toc do dan truyen (m/s)
cfg.DeltaE = 5e-3;               % Khoang cach giua dien cuc (m) = 5mm

% Tinh do tre mong doi
cfg.CV_expected = mean(cfg.CV_Scale);
cfg.delay_expected = cfg.DeltaE * cfg.Fs / cfg.CV_expected;

% ============================================================================
% DANH SACH CAC PHUONG PHAP GCC
% ============================================================================
% 6 phuong phap chinh + GCC Basic
cfg.methods = {
    'CC_time'   % 1. Tuong quan cheo mien thoi gian (co ban nhat)
    'PHAT'      % 2. Phase Transform - Tay trang pho
    'ROTH'      % 3. Bo xu ly Roth - Chuan hoa theo pho kenh 1
    'SCOT'      % 4. Smoothed Coherence Transform - Chuan hoa doi xung
    'ECKART'    % 5. Bo loc Eckart - Toi uu SNR
    'HT'        % 6. Hannan-Thomson (ML) - Toi uu nhat theo ly thuyet
};

% ============================================================================
% CAU HINH DAU RA
% ============================================================================
cfg.save_results = true;         % Luu ket qua vao file
cfg.results_dir = 'results';     % Thu muc luu ket qua
cfg.show_plots = true;           % Hien thi bieu do
cfg.verbose = true;              % In thong bao tien trinh

% Cau hinh export
cfg.export_formats = {'mat', 'csv'};  % Cac dinh dang xuat: 'mat', 'csv', 'json', 'xlsx'
cfg.export_detailed = true;      % Xuat ket qua chi tiet

% ============================================================================
% CAU HINH VISUALIZATION
% ============================================================================
cfg.plot_style = 'default';      % 'default', 'publication', 'presentation'
cfg.plot_format = 'png';         % 'png', 'fig', 'pdf', 'eps'
cfg.plot_dpi = 300;             % Do phan giai cho anh (DPI)
cfg.plot_fontsize = 12;         % Co chu mac dinh

% ============================================================================
% CAU HINH LOGGING
% ============================================================================
cfg.log_file = '';               % Duong dan file log (rong = khong ghi file)
cfg.log_level = 'INFO';         % Muc do log: 'INFO', 'WARNING', 'ERROR'

% ============================================================================
% CAU HINH VALIDATION
% ============================================================================
cfg.validate_inputs = true;      % Kiem tra dau vao truoc khi chay
cfg.validate_config = true;      % Kiem tra cau hinh truoc khi chay
cfg.stop_on_error = false;       % Dung lai khi gap loi (false = tiep tuc)

% ============================================================================
% CAU HINH NOI SUY DO TRE
% ============================================================================
cfg.use_interpolation = true;    % Su dung noi suy Parabola
cfg.interpolation_method = 'parabolic';  % 'parabolic', 'sinc', 'none'

% ============================================================================
% CAU HINH XU LY TIN HIEU
% ============================================================================
cfg.preprocess_signal = false;   % Tien xu ly tin hieu (loc nhieu, normalize)
cfg.normalize_signals = false;   % Chuan hoa tin hieu ve [0, 1] hoac [-1, 1]
cfg.remove_dc = true;           % Loai bo thanh phan DC

% ============================================================================
% VALIDATION TU DONG
% ============================================================================
if cfg.validate_config
    try
        validation.validateConfig(cfg);
    catch ME
        warning('config:validation:Failed', ...
                'Loi validation cau hinh: %s. Su dung cau hinh mac dinh.', ME.message);
    end
end

end

