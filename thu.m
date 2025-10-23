Fs = 2048;           % Tần số lấy mẫu [Hz]
T  = 2;              % Thời gian tín hiệu [s]
N  = Fs * T;         % Số mẫu tín hiệu
t  = (0:N-1)'/Fs;    % Trục thời gian

delay_true = 0.01;   % Độ trễ thực tế giữa 2 tín hiệu [s]
delay_samples = round(delay_true * Fs); % Độ trễ tính theo số mẫu

SNR_dB = 10;         % SNR mong muốn [dB]

%% 1. TẠO TÍN HIỆU sEMG (tín hiệu gốc)
% Sử dụng nhiều thành phần sin/cos với tần số cao và biên độ ngẫu nhiên
num_components = 20; % Số thành phần để mô phỏng tính phức tạp của sEMG
emg_signal = zeros(N,1);

for k = 1:num_components
    freq = 20 + (200-20)*rand;         % Tần số từ 20-200 Hz
    phase = 2*pi*rand;                 % Pha ngẫu nhiên
    amp = 0.5 + rand;                  % Biên độ ngẫu nhiên
    emg_signal = emg_signal + amp*sin(2*pi*freq*t + phase);
end

% Chuẩn hóa tín hiệu về biên độ [-1,1]
emg_signal = emg_signal / max(abs(emg_signal));

%% 2. Tạo hai kênh: kênh 2 là bản dịch trễ của kênh 1
s1 = emg_signal;
s2 = [zeros(delay_samples,1); emg_signal(1:end-delay_samples)];

%% 3. Thêm nhiễu Gaussian trắng (AWGN)
% Công thức sigma = sqrt(P_signal * 10^(-SNR/10))
P_signal = var(s1);  % Công suất tín hiệu gốc

sigma = sqrt(P_signal * 10^(-SNR_dB/10)); 

s1_noise = s1 + sigma * randn(size(s1));
s2_noise = s2 + sigma * randn(size(s2));

%% 4. Hiển thị kết quả
figure;
subplot(2,1,1);
plot(t, s1_noise); grid on;
title('Tín hiệu sEMG kênh 1 (có nhiễu)');
xlabel('Thời gian (s)');
ylabel('Biên độ');

subplot(2,1,2);
plot(t, s2_noise); grid on;
title('Tín hiệu sEMG kênh 2 (có nhiễu và trễ)');
xlabel('Thời gian (s)');
ylabel('Biên độ');

%% 5. In thông tin
fprintf('Số mẫu: %d\n', N);
fprintf('Độ trễ thực tế: %.4f giây ~ %d mẫu\n', delay_true, delay_samples);

%% 6. Lưu dữ liệu vào file .mat (nếu cần)
save('simu_emg.mat','s1','s2','s1_noise','s2_noise','t','Fs','delay_true','delay_samples');
disp('Đã lưu dữ liệu vào file simu_emg.mat');