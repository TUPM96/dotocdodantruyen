function [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, varargin)
% GENERATESEMG Tao tin hieu sEMG gia lap voi do tre chi dinh
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tao tin hieu sEMG (surface Electromyography) gia lap
%            voi cac kenh co do tre thoi gian khac nhau
%
% Ung dung: Ước luong toc do dan truyen soi co (Muscle Fiber
%           Conduction Velocity - MFCV) tu tin hieu sEMG
%
% SYNTAX:
%   [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe)
%   [Vec_Signal, T, b] = generateSEMG(Signal_Type, N, p, D, Fe, Signal_Name)
%
% THAM SO DAU VAO:
%   Signal_Type  - Loai tin hieu can tao:
%                  'gwn'       : Nhieu trang Gaussian (White Noise)
%                  'simu_semg' : Tin hieu sEMG gia lap (su dung mo hinh Farina-Merletti)
%                  'real_semg' : Tin hieu sEMG thuc tu file
%   N            - So mau tin hieu
%   p            - Bac bo loc FIR cho mo hinh hoa do tre (Filter order)
%   D            - Do tre tinh theo so mau (co the la hang so hoac vector bien doi)
%   Fe           - Tan so lay mau (Sampling frequency) tinh bang Hz
%   Signal_Name  - (Tuy chon) Ten file tin hieu thuc khi dung 'real_semg'
%
% THAM SO DAU RA:
%   Vec_Signal   - Ma tran N x 4 chua 4 kenh tin hieu voi do tre khac nhau:
%                  Kenh 1: Tin hieu goc (khong co do tre)
%                  Kenh 2: Tin hieu co do tre D
%                  Kenh 3: Tin hieu co do tre 2*D
%                  Kenh 4: Tin hieu co do tre 3*D
%   T            - Vector thoi gian tinh bang giay
%   b            - He so bo loc (chi dung cho 'simu_semg')
%
% MO HINH FARINA-MERLETTI:
%   PSD(f) = k * fh^4 * f^2 / [(f^2 + fl^2) * (f^2 + fh^2)^2]
%   - Trong do: fh = 120 Hz (tan so cao), fl = 60 Hz (tan so thap)
%   - Day la mo hinh pho cong suat (Power Spectral Density) chuan cho tin hieu sEMG
%
% TAI LIEU THAM KHAO:
%   D. Farina and R. Merletti, "Comparison of algorithms for estimation of
%   EMG variables during voluntary contractions", Journal of
%   Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.
%
% VI DU SU DUNG:
%   % Tao tin hieu sEMG gia lap voi do tre 4.9 mau
%   [signal, time, filter] = signal.generateSEMG('simu_semg', 256, 40, 4.9, 2048);
%
% See also: Delay_Modeling_Var, calculatePSD

%% BUOC 1: Kiem tra tham so dau vao
if nargin < 5
    error('signal:generateSEMG:NotEnoughInputs', ...
          'At least 5 input arguments required');
end

Signal_Name = [];
if nargin > 5
    Signal_Name = varargin{1};
end

%% BUOC 2: Tao vector do tre
% Giai thich: Tao vector do tre cho moi mau tin hieu
% - Neu D la hang so: tat ca cac mau co cung do tre
% - Neu D la vector: moi mau co do tre khac nhau (do tre bien thien)
if isscalar(D)
    Delay = ones(1, N) * D;  % Do tre hang so cho tat ca cac mau
else
    Delay = D;                % Do tre bien thien theo thoi gian
end

%% BUOC 3: Tinh do dai tin hieu mo rong de tranh hien tuong bien
n = 1:N;
% DeltaStart: So mau can them vao dau tin hieu
DeltaStart = max([0 (p - n - floor(Delay))]);
% DeltaStop: So mau can them vao cuoi tin hieu
DeltaStop  = max([0 (n + floor(Delay) + p - N)]);

% Dam bao khong am
if DeltaStart < 0
    DeltaStart = 0;
end

if DeltaStop < 0
    DeltaStop = 0;
end

% Np: Tong so mau tin hieu sau khi mo rong
% He so 3 de dam bao du mau cho ca 4 kenh (do tre 0, D, 2D, 3D)
Np = N + 3 * (DeltaStart + DeltaStop);

%% BUOC 4: Khoi tao cac bien dau ra
b = [];                      % He so bo loc (chi dung cho 'simu_semg')
M = 4;                       % So kenh tin hieu (4 kenh voi do tre khac nhau)
Vec_Signal = zeros(N, M);    % Ma tran dau ra N x 4

%% BUOC 5: Tao tin hieu goc theo loai duoc chon
switch lower(Signal_Type)
    case 'gwn'
        % ===== TAO NHIEU TRANG GAUSSIAN (GAUSSIAN WHITE NOISE) =====
        % Giai thich: Tao tin hieu nhieu trang de kiem tra thuat toan
        % Nhieu trang co pho cong suat phang tren tat ca cac tan so
        Signal = randn(1, Np);  % Tao Np mau nhieu Gaussian

    case 'simu_semg'
        % ===== TAO TIN HIEU sEMG GIA LAP BANG MO HINH FARINA-MERLETTI =====
        % Giai thich: Su dung mo hinh pho cong suat (PSD) Farina-Merletti
        % de tao tin hieu sEMG gia lap co dac tinh tan so giong tin hieu thuc

        % Buoc 5a: Dinh nghia cac tham so mo hinh Farina-Merletti
        fh = 120;       % Tan so cao (High frequency parameter) - Hz
        fl = 60;        % Tan so thap (Low frequency parameter) - Hz
        k = 1;          % He so ty le (Scaling factor)
        Fs = Fe;        % Tan so lay mau

        % Buoc 5b: Tao truc tan so
        % Tao vector tan so tu 0 den Fs voi N diem
        f = linspace(0, Fs, N);

        % Buoc 5c: Tinh PSD theo mo hinh Farina-Merletti
        % Cong thuc: PSD(f) = k * fh^4 * f^2 / [(f^2 + fl^2) * (f^2 + fh^2)^2]
        % Mo hinh nay mo phong dac tinh pho cong suat cua tin hieu sEMG thuc te
        PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);

        % Buoc 5d: Tao pho doi xung
        % Pho doi xung can thiet cho tin hieu thuc (real-valued signal)
        % Giu tan so duong + DC, sau do dao nguoc cho tan so am
        PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

        % Buoc 5e: Chuan hoa PSD ve gia tri lon nhat = 1
        % Dam bao pho khong vuot qua gia tri cho phep
        PSD = PSD ./ max(PSD);

        % Buoc 5f: Tao nhieu trang Gaussian
        % Day la tin hieu nguon se duoc loc
        Signal = randn(1, Np);

        % Buoc 5g: Thiet ke bo loc FIR tu PSD
        % Lay can bac hai cua PSD de co dap ung tan so mong muon
        % Su dung IFFT de chuyen ve mien thoi gian
        b = fftshift(real(ifft(sqrt(PSD))));

        % Tinh do dai bo loc tuy thuoc vao tan so lay mau
        % He so 100 duoc chon dua tren kinh nghiem thuc nghiem
        Ncoef = round(Fs / 4096 * 100);

        % Cat he so bo loc quanh trung tam
        b = b(N/2+1-Ncoef/2 : N/2+1+Ncoef/2);

        % Buoc 5h: Loc tin hieu nhieu trang
        % Su dung filtfilt de tranh lech pha (zero-phase filtering)
        Signal = filtfilt(b, 1, Signal);

    case 'real_semg'
        % ===== TAI TIN HIEU sEMG THUC TU FILE =====
        % Giai thich: Nap tin hieu sEMG da ghi tu thuc nghiem

        % Kiem tra xem ten file co duoc cung cap khong
        if isempty(Signal_Name)
            error('signal:generateSEMG:MissingSignalName', ...
                  'Signal_Name required for real_semg option');
        end

        % Nap file chua tin hieu sEMG thuc
        load(Signal_Name, 'sEMG');

        % Lay mau lai tin hieu neu can thiet
        % Gia su tin hieu goc co tan so lay mau 4096 Hz
        Signal = sEMG(1:round(4096/Fe):Np*round(4096/Fe));

    otherwise
        error('signal:generateSEMG:InvalidSignalType', ...
              'Signal_Type must be: gwn, simu_semg, or real_semg');
end

%% BUOC 6: Tao vector thoi gian
% Tao truc thoi gian tu 0 den N mau, chia cho tan so lay mau de co don vi giay
T = linspace(0, N, N) ./ Fe;

%% BUOC 7: Tao cac tin hieu co do tre
% Giai thich: Tao 4 kenh tin hieu mo phong 4 dien cuc ghi tin hieu sEMG
% Moi kenh cach nhau mot khoang cach DeltaE va co do tre tang dan
%
% Mo hinh: Kenh i co do tre = (i-1) * D mau
%   - Kenh 1 (tham chieu): Khong co do tre (delay = 0)
%   - Kenh 2: Do tre D mau
%   - Kenh 3: Do tre 2*D mau
%   - Kenh 4: Do tre 3*D mau
%
% Ham Delay_Modeling_Var su dung bo loc FIR bac p de tao do tre phan so
% chinh xac (fractional delay), cho phep do tre khong phai la so nguyen

Vec_Signal(:, 1) = Signal(1:N);                                    % Kenh 1: Tham chieu
Vec_Signal(:, 2) = Delay_Modeling_Var(Signal, 1, p, Delay, N);    % Kenh 2: Do tre D
Vec_Signal(:, 3) = Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);  % Kenh 3: Do tre 2*D
Vec_Signal(:, 4) = Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);  % Kenh 4: Do tre 3*D

end
