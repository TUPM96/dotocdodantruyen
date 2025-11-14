% ==============================================================================
% TEN FILE: validateConfig.m
% CHUC NANG: Kiem tra va xac thuc cau hinh mo phong
% MODULE: validation
% ==============================================================================
%
% Mo ta: Kiem tra tinh hop le cua cau hinh mo phong
%        Dam bao tat ca tham so deu hop le truoc khi chay mo phong
%        Tra ve thong bao loi chi tiet neu co tham so khong hop le
%
function isValid = validateConfig(cfg)

isValid = true;

% Kiem tra tham so Monte Carlo
if ~isfield(cfg, 'Nm') || ~isscalar(cfg.Nm) || cfg.Nm < 1 || ~isnumeric(cfg.Nm)
    warning('validation:validateConfig:InvalidNm', ...
            'Nm phai la so nguyen duong, dat gia tri mac dinh 100');
    cfg.Nm = 100;
end

if ~isfield(cfg, 'SNR') || ~isvector(cfg.SNR) || any(cfg.SNR < -20) || any(cfg.SNR > 50)
    error('validation:validateConfig:InvalidSNR', ...
          'SNR phai la vector cac gia tri trong khoang [-20, 50] dB');
end

% Kiem tra tham so tin hieu
if ~isfield(cfg, 'Fs') || ~isscalar(cfg.Fs) || cfg.Fs <= 0
    error('validation:validateConfig:InvalidFs', ...
          'Fs (tan so lay mau) phai la so duong');
end

if ~isfield(cfg, 'N') || ~isscalar(cfg.N) || cfg.N < 64
    error('validation:validateConfig:InvalidN', ...
          'N (so mau) phai lon hon hoac bang 64');
end

if ~isfield(cfg, 'p') || ~isscalar(cfg.p) || cfg.p < 1
    error('validation:validateConfig:InvalidP', ...
          'p (bac bo loc) phai la so nguyen duong');
end

% Kiem tra tham so phan tich tan so
if ~isfield(cfg, 'nfft') || ~isscalar(cfg.nfft) || cfg.nfft < cfg.N
    warning('validation:validateConfig:InvalidNfft', ...
            'nfft nen lon hon hoac bang N, dat gia tri 2*N');
    cfg.nfft = 2 * cfg.N;
end

if ~isfield(cfg, 'h_Length') || ~isscalar(cfg.h_Length) || cfg.h_Length < 32
    error('validation:validateConfig:InvalidHLength', ...
          'h_Length phai lon hon hoac bang 32');
end

% Kiem tra tham so co bap
if ~isfield(cfg, 'CV_Scale') || ~isvector(cfg.CV_Scale) || length(cfg.CV_Scale) ~= 2
    error('validation:validateConfig:InvalidCVScale', ...
          'CV_Scale phai la vector 2 phan tu [min, max]');
end

if cfg.CV_Scale(1) >= cfg.CV_Scale(2) || any(cfg.CV_Scale <= 0)
    error('validation:validateConfig:InvalidCVRange', ...
          'CV_Scale phai co min < max va ca hai deu duong');
end

if ~isfield(cfg, 'DeltaE') || ~isscalar(cfg.DeltaE) || cfg.DeltaE <= 0
    error('validation:validateConfig:InvalidDeltaE', ...
          'DeltaE (khoang cach dien cuc) phai la so duong');
end

% Kiem tra danh sach phuong phap
if ~isfield(cfg, 'methods') || ~iscell(cfg.methods) || isempty(cfg.methods)
    error('validation:validateConfig:InvalidMethods', ...
          'methods phai la cell array khong rong');
end

valid_methods = {'CC_time', 'PHAT', 'ROTH', 'SCOT', 'ECKART', 'HT', 'GCC_Basic'};
for i = 1:length(cfg.methods)
    if ~ismember(cfg.methods{i}, valid_methods)
        warning('validation:validateConfig:UnknownMethod', ...
                'Phuong phap "%s" khong duoc ho tro, bo qua', cfg.methods{i});
    end
end

% Kiem tra cau hinh dau ra
if ~isfield(cfg, 'save_results')
    cfg.save_results = true;
end

if ~isfield(cfg, 'results_dir')
    cfg.results_dir = 'results';
end

if ~isfield(cfg, 'show_plots')
    cfg.show_plots = true;
end

end

