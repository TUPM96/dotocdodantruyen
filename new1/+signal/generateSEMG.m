% ==============================================================================
% TEN FILE: generateSEMG.m
% CHUC NANG: Tao tin hieu sEMG gia lap voi cac kenh co do tre khac nhau
% MODULE: signal
% ==============================================================================
%
% Mo ta: Tao tin hieu sEMG (surface Electromyography) gia lap
%        voi cac kenh co do tre thoi gian khac nhau
%
% Ung dung: Uoc luong toc do dan truyen soi co (Muscle Fiber Conduction Velocity - MFCV)
%
% Mo hinh: Tao 4 kenh tin hieu mo phong 4 dien cuc ghi tin hieu sEMG
%          Moi kenh cach nhau mot khoang cach va co do tre tang dan
%          Kenh 1 (tham chieu): Khong co do tre (delay = 0)
%          Kenh 2: Do tre D mau
%          Kenh 3: Do tre 2*D mau
%          Kenh 4: Do tre 3*D mau
%
function [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, varargin)

% Kiem tra tham so dau vao
if nargin < 5
    error('signal:generateSEMG:NotEnoughInputs', ...
          'At least 5 input arguments required');
end

Signal_Name = [];
if nargin > 5
    Signal_Name = varargin{1};
end

% Tao vector do tre
% Neu D la hang so: tat ca cac mau co cung do tre
% Neu D la vector: moi mau co do tre khac nhau (do tre bien thien)
if isscalar(D)
    Delay = ones(1, N) * D;
else
    Delay = D;
end

% Tinh do dai tin hieu mo rong de tranh hien tuong bien
n = 1:N;
DeltaStart = max([0 (p - n - floor(Delay))]);
DeltaStop  = max([0 (n + floor(Delay) + p - N)]);

if DeltaStart < 0
    DeltaStart = 0;
end

if DeltaStop < 0
    DeltaStop = 0;
end

% Np: Tong so mau tin hieu sau khi mo rong
% He so 3 de dam bao du mau cho ca 4 kenh (do tre 0, D, 2D, 3D)
Np = N + 3 * (DeltaStart + DeltaStop);

% Khoi tao cac bien dau ra
b = [];
M = 4;
Vec_Signal = zeros(N, M);

% Tao tin hieu goc theo loai duoc chon
switch lower(Signal_Type)
    case 'gwn'
        % Tao nhieu trang Gaussian (Gaussian White Noise)
        % Nhieu trang co pho cong suat phang tren tat ca cac tan so
        Signal = randn(1, Np);
        
    case 'simu_semg'
        % Tao tin hieu sEMG gia lap bang mo hinh Farina-Merletti
        % Su dung mo hinh pho cong suat (PSD) Farina-Merletti
        % de tao tin hieu sEMG gia lap co dac tinh tan so giong tin hieu thuc
        
        % Dinh nghia cac tham so mo hinh Farina-Merletti
        fh = 120;
        fl = 60;
        k = 1;
        Fs = Fe;
        
        % Tao truc tan so
        f = linspace(0, Fs, N);
        
        % Tinh PSD theo mo hinh Farina-Merletti
        PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);
        
        % Tao pho doi xung
        PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
        
        % Chuan hoa PSD ve gia tri lon nhat = 1
        PSD = PSD ./ max(PSD);
        
        % Tao nhieu trang Gaussian
        Signal = randn(1, Np);
        
        % Thiet ke bo loc FIR tu PSD
        % Lay can bac hai cua PSD de co dap ung tan so mong muon
        % Su dung IFFT de chuyen ve mien thoi gian
        b = fftshift(real(ifft(sqrt(PSD))));
        
        % Tinh do dai bo loc tuy thuoc vao tan so lay mau
        Ncoef = round(Fs / 4096 * 100);
        
        % Cat he so bo loc quanh trung tam
        b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);
        
        % Loc tin hieu nhieu trang
        % Su dung filtfilt de tranh lech pha (zero-phase filtering)
        Signal = filtfilt(b, 1, Signal);
        
    case 'real_semg'
        % Tai tin hieu sEMG thuc tu file
        % Nap tin hieu sEMG da ghi tu thuc nghiem
        
        if isempty(Signal_Name)
            error('signal:generateSEMG:MissingSignalName', ...
                  'Signal_Name required for real_semg option');
        end
        
        load(Signal_Name, 'sEMG');
        
        % Lay mau lai tin hieu neu can thiet
        Signal = sEMG(1:round(4096/Fe):Np*round(4096/Fe));
        
    otherwise
        error('signal:generateSEMG:InvalidSignalType', ...
              'Signal_Type must be: gwn, simu_semg, or real_semg');
end

% Tao vector thoi gian
% Tao truc thoi gian tu 0 den N mau, chia cho tan so lay mau de co don vi giay
T = linspace(0, N, N) ./ Fe;

% Tao cac tin hieu co do tre
% Ham Delay_Modeling_Var su dung bo loc FIR bac p de tao do tre phan so chinh xac
% cho phep do tre khong phai la so nguyen
Vec_Signal(:, 1) = Signal(1:N);
Vec_Signal(:, 2) = utils.Delay_Modeling_Var(Signal, 1, p, Delay, N);
Vec_Signal(:, 3) = utils.Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);
Vec_Signal(:, 4) = utils.Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);

end

