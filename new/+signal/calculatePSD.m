function PSD = calculatePSD(N, Fs)
% CALCULATEPSD Calculate Farina-Merletti PSD model for sEMG signals
%
% TAI LIEU TIENG VIET KHONG DAU:
% ================================
% Chuc nang: Tinh toan mo hinh PSD (Power Spectral Density - Mat do pho
%            cong suat) Farina-Merletti cho tin hieu sEMG
%
% Giai thich chi tiet:
% - Mo hinh Farina-Merletti la mo hinh toan hoc mo ta pho tan so cua tin
%   hieu sEMG (Surface Electromyography)
% - Mo hinh nay duoc xay dung dua tren du lieu thuc nghiem va duoc su dung
%   rong rai trong mo phong tin hieu sEMG
% - PSD giup xac dinh cach nang luong tin hieu phan bo theo tan so
%
% Thuat toan:
%   PSD(f) = k * fh^4 * f^2 / [(f^2 + fl^2) * (f^2 + fh^2)^2]
%   Trong do:
%   - f: Tan so (Hz)
%   - fh = 120 Hz: Tham so tan so cao
%   - fl = 60 Hz: Tham so tan so thap
%   - k = 1: He so ty le
%
% SYNTAX:
%   PSD = calculatePSD(N, Fs)
%
% INPUTS:
%   N   - Number of samples (So mau tin hieu)
%   Fs  - Sampling frequency in Hz (Tan so lay mau, don vi Hz)
%
% OUTPUTS:
%   PSD - Power spectral density (Mat do pho cong suat) - normalized, length N
%
% REFERENCE:
%   D. Farina and R. Merletti, "Comparison of algorithms for estimation of
%   EMG variables during voluntary contractions", Journal of
%   Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.

%% BUOC 1: Dinh nghia cac tham so mo hinh Farina-Merletti
% Cac tham so nay duoc xac dinh tu du lieu thuc nghiem
fh = 120;       % Tan so cao (High frequency parameter) - Hz
fl = 60;        % Tan so thap (Low frequency parameter) - Hz
k = 1;          % He so ty le (Scaling factor)

%% BUOC 2: Tao truc tan so
% Tao vector tan so tu 0 den Fs (tan so lay mau) voi N diem deu nhau
f = linspace(0, Fs, N);

%% BUOC 3: Tinh PSD theo cong thuc Farina-Merletti
% Giai thich cong thuc:
% - Tu so: k * fh^4 * f^2 -> Tang theo f^2 o tan so thap
% - Mau so: (f^2 + fl^2) * (f^2 + fh^2)^2 -> Lam giam nhanh o tan so cao
% - Ket qua: PSD co dinh o tan so trung binh (50-150 Hz) - dac trung cua sEMG
PSD = k * fh.^4 .* f.^2 ./ ((f.^2 + fl.^2) .* (f.^2 + fh.^2).^2);

%% BUOC 4: Tao pho doi xung cho tin hieu thuc
% Giai thich: Tin hieu thuc (real-valued) can co pho doi xung quanh tan so 0
% - Giu tan so duong (1:N/2+1) bao gom ca DC va Nyquist
% - Dao nguoc tan so duong (tru DC va Nyquist) de tao tan so am
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];

%% BUOC 5: Chuan hoa PSD
% Chia cho gia tri lon nhat de PSD co dinh = 1
% Giup on dinh tinh toan va de so sanh
PSD = PSD ./ max(PSD);

end
