%% ===================== THAM SO HE THONG =====================
% Thiet lap cac tham so mo phong chinh

N  = 2048;             % so diem mau
Fs = 2048;             % tan so lay mau
p  = 0.5;              % he so tuong quan
h_Length = 128;        % do dai cua so tinh PSD
SNR = 10;              % muc SNR (dB)
delai_attendu = 4.9;   % do tre that su (mau)

% Pho cong suat tin hieu EMG (Farina–Merletti)
fh = 120; fl = 60; kPSD = 1;
f  = linspace(0,Fs,N);
PSD = kPSD*fh.^4.*f.^2 ./ ((f.^2+fl.^2).*(f.^2+fh.^2).^2);
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
PSD = PSD./max(PSD);
Gss = PSD(:);
