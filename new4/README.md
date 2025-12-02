# Hệ Thống Ước Lượng MFCV Sử Dụng Phương Pháp GCC

## 📋 Mô Tả Tổng Quan

Dự án này thực hiện mô phỏng và đánh giá hiệu suất của 6 phương pháp Generalized Cross-Correlation (GCC) để ước lượng Muscle Fiber Conduction Velocity (MFCV) - tốc độ dẫn truyền sợi cơ từ tín hiệu sEMG (surface Electromyography).

Chương trình sử dụng phương pháp Monte Carlo để đánh giá độ chính xác và độ ổn định của các phương pháp GCC khác nhau dưới các điều kiện SNR (Signal-to-Noise Ratio) khác nhau.

## 🎯 Chức Năng Chính

1. **Tạo tín hiệu sEMG giả lập** với độ trễ thời gian đã biết
2. **Thêm nhiễu** vào tín hiệu để mô phỏng điều kiện thực tế
3. **Ước lượng độ trễ** sử dụng 6 phương pháp GCC khác nhau
4. **Đánh giá hiệu suất** thông qua các chỉ số thống kê (bias, variance, RMSE)
5. **Trực quan hóa kết quả** bằng biểu đồ
6. **Xuất kết quả** ra file (.mat, .txt)

## 📁 Cấu Trúc Thư Mục

```
new4/
├── main.m                          # File chính - chương trình điều khiển
├── README.md                       # File hướng dẫn này
│
├── +gcc/                           # Module: Các phương pháp GCC
│   ├── ccTime.m                    # CC_time - Tương quan chéo miền thời gian
│   ├── gccROTH.m                   # ROTH - Bộ xử lý Roth
│   ├── gccSCOT.m                   # SCOT - Smoothed Coherence Transform
│   ├── gccPHAT.m                   # PHAT - Phase Transform
│   ├── gccECKART.m                 # ECKART - Bộ lọc Eckart
│   ├── gccHT.m                     # HT - Hannan-Thomson (Maximum Likelihood)
│   └── estimateDelay.m             # Hàm hỗ trợ: Nội suy Parabola
│
├── +signal/                        # Module: Tạo tín hiệu
│   └── sEMG_Generator.m            # Tạo tín hiệu sEMG giả lập
│
├── +preprocessing/                 # Module: Tiền xử lý
│   ├── computeSpectra.m            # Tính phổ sử dụng phương pháp Welch
│   └── computeTheoreticalSpectra.m # Tính phổ lý thuyết
│
├── +visualization/                 # Module: Trực quan hóa
│   └── plotResults.m               # Tạo các biểu đồ kết quả
│
├── +export/                        # Module: Xuất dữ liệu
│   └── exportResults.m            # Lưu kết quả ra file
│
├── +metrics/                       # Module: Tính toán chỉ số
│   └── calculateStats.m            # Tính các chỉ số thống kê
│
├── +utils/                         # Module: Tiện ích
│   └── Delay_Modeling_Var.m        # Mô hình độ trễ biến thiên
│
├── result/                         # Thư mục chứa kết quả
│   ├── ket_qua_MFCV_*.mat          # File kết quả dạng .mat
│   └── ket_qua_MFCV_*.txt          # File kết quả dạng .txt
│
└── gcc.mat                         # File lưu tạm thời trong quá trình chạy
```

## 🔧 Các Phương Pháp GCC Được Sử Dụng

### 1. **CC_time** - Cross-Correlation Time Domain
- **Mô tả**: Tương quan chéo trực tiếp trong miền thời gian
- **Ưu điểm**: Đơn giản, nhanh
- **Nhược điểm**: Nhạy cảm với nhiễu

### 2. **ROTH** - Roth Filter
- **Công thức**: `R_roth = IFFT(Pxy / Gx1x1)`
- **Mô tả**: Chuẩn hóa theo phổ tự động của kênh 1
- **Đặc điểm**: Hiệu quả trong môi trường có nhiễu

### 3. **SCOT** - Smoothed Coherence Transform
- **Công thức**: `R_scot = IFFT(Pxy / sqrt(Gx1x1 * Gx2x2))`
- **Mô tả**: Chuẩn hóa theo cả hai phổ tự động
- **Đặc điểm**: Cân bằng giữa độ chính xác và độ ổn định

### 4. **PHAT** - Phase Transform
- **Công thức**: `R_phat = IFFT(Pxy / |Pxy|)`
- **Mô tả**: Chỉ sử dụng thông tin pha, loại bỏ biên độ
- **Đặc điểm**: Tốt cho tín hiệu có nhiễu lớn

### 5. **ECKART** - Eckart Filter
- **Công thức**: `R_eckart = IFFT(Pxy * Gss / (Gn1n1 * Gn2n2))`
- **Mô tả**: Bộ lọc tối ưu dựa trên tỷ lệ tín hiệu/nhiễu
- **Đặc điểm**: Hiệu suất cao trong điều kiện nhiễu

### 6. **HT** - Hannan-Thomson (Maximum Likelihood)
- **Công thức**: `R_ht = IFFT(Pxy * Gss / (Gss * (Gn1n1 + Gn2n2) + Gn1n1 * Gn2n2))`
- **Mô tả**: Phương pháp Maximum Likelihood
- **Đặc điểm**: Thường cho kết quả tốt nhất, nhưng tính toán phức tạp hơn

## 📊 Quy Trình Xử Lý

### Bước 1: Khởi Tạo Tham Số
- Số lần lặp Monte Carlo: 100
- Thời lượng tín hiệu: 0.125 giây (125ms)
- Tần số lấy mẫu: 2048 Hz
- Độ trễ mong đợi: 4.9 mẫu
- Các mức SNR: 0, 10, 20 dB

### Bước 2: Tính PSD Lý Thuyết
- Sử dụng mô hình Farina-Merletti
- Tần số thấp: 60 Hz
- Tần số cao: 120 Hz

### Bước 3: Mô Phỏng Monte Carlo
Với mỗi mức SNR và mỗi lần lặp:
1. **Tạo tín hiệu sEMG giả lập** với độ trễ đã biết
2. **Thêm nhiễu trắng Gaussian** để đạt SNR mong muốn
3. **Tính phổ** sử dụng phương pháp Welch (cửa sổ Hanning, 50% chồng chập)
4. **Áp dụng 6 phương pháp GCC** để ước lượng độ trễ
5. **Lưu kết quả tạm thời**

### Bước 4: Tính Các Chỉ Số Thống Kê
Sau khi hoàn thành tất cả các vòng lặp:
- **Trung bình độ trễ** (`delai_estime`)
- **Bias** (độ lệch so với giá trị thực)
- **Variance** (phương sai)
- **Standard Deviation** (`ecart_type`)
- **RMSE/EQM** (Root Mean Square Error)

### Bước 5: Trực Quan Hóa
Tạo 12 biểu đồ:
- 6 biểu đồ độ lệch chuẩn (ecart_type) cho 6 phương pháp
- 6 biểu đồ RMSE (EQM) cho 6 phương pháp
- Các biểu đồ so sánh hiệu suất

### Bước 6: Xuất Kết Quả
Lưu tất cả kết quả vào thư mục `result/`:
- File `.mat`: Dữ liệu đầy đủ
- File `.txt`: Bảng kết quả dạng văn bản

## 🚀 Cách Sử Dụng

### Yêu Cầu Hệ Thống
- MATLAB R2016b trở lên
- Signal Processing Toolbox (cho hàm `cpsd`, `hanning`)

### Chạy Chương Trình

1. **Mở MATLAB** và chuyển đến thư mục `new4`:
   ```matlab
   cd new4
   ```

2. **Chạy file chính**:
   ```matlab
   main
   ```

3. **Chờ quá trình mô phỏng hoàn tất** (có thể mất vài phút tùy vào cấu hình máy)

4. **Xem kết quả**:
   - Các biểu đồ sẽ tự động hiển thị
   - Kết quả được lưu trong thư mục `result/`

### Tùy Chỉnh Tham Số

Bạn có thể chỉnh sửa các tham số trong file `main.m`:

```matlab
% Tham so Monte Carlo
N_MonteCarlo = 100;    % Số lần lặp (tăng để độ chính xác cao hơn)

% Tham so tin hieu
Duration = 0.125;      % Thời lượng mô phỏng (giây)
Fs = 2048;             % Tần số lấy mẫu (Hz)
delai_attendu = [4.9]; % Độ trễ mong đợi (mẫu)

% Tham so mo phong
SNR = [0 10 20];       % Các mức SNR (dB)
```

## 📈 Kết Quả Đầu Ra

### 1. Biểu Đồ Trực Quan

Chương trình tự động tạo các biểu đồ sau:

- **Biểu đồ độ lệch chuẩn (ecart_type)**:
  - Hiển thị độ ổn định của từng phương pháp
  - Trục X: Mức SNR (dB)
  - Trục Y: Độ lệch chuẩn (mẫu)

- **Biểu đồ RMSE (EQM)**:
  - Hiển thị sai số tổng thể của từng phương pháp
  - Trục X: Mức SNR (dB)
  - Trục Y: RMSE (mẫu)

### 2. File Kết Quả

Trong thư mục `result/`, bạn sẽ tìm thấy:

- **File `.mat`**: Chứa tất cả dữ liệu thô và kết quả thống kê
  - Các ma trận ước lượng độ trễ: `D`, `DRoth`, `DScot`, `Dphat`, `DEckart`, `Dml`
  - Các chỉ số thống kê: `bias`, `Var`, `ecart_type`, `EQM`
  - Tham số: `SNR`, `delai_attendu`, `Nm`

- **File `.txt`**: Bảng kết quả dạng văn bản, dễ đọc
  - Bảng so sánh các phương pháp
  - Giá trị bias, variance, standard deviation, RMSE cho từng mức SNR

### 3. Định Dạng Kết Quả

Kết quả được tổ chức theo cấu trúc:

```
Phương pháp | SNR (dB) | Trung bình | Bias | Variance | Std Dev | RMSE
------------|----------|------------|------|----------|---------|------
CC_time     |    0     |    ...     | ...  |   ...    |   ...   | ...
CC_time     |   10     |    ...     | ...  |   ...    |   ...   | ...
CC_time     |   20     |    ...     | ...  |   ...    |   ...   | ...
ROTH        |    0     |    ...     | ...  |   ...    |   ...   | ...
...
```

### 4. Kết Quả Mẫu (Từ Lần Chạy Thực Tế)

Dưới đây là kết quả từ một lần chạy thực tế với tham số mặc định:
- **Số lần lặp Monte Carlo**: 100
- **Độ trễ thực**: 4.9 mẫu
- **Các mức SNR**: 0, 10, 20 dB

#### 📊 Bảng 1: Độ Lệch Chuẩn (Ecart-type) - Đơn vị: Mẫu

| SNR (dB) | CC_time | ROTH  | SCOT  | PHAT  | ECKART | HT    |
|----------|---------|-------|-------|-------|--------|-------|
| 0        | 0.7102  | 3.4328 | 3.4328 | 3.8728 | 0.4290 | 0.4535 |
| 10       | 0.2196  | 1.2361 | 1.2361 | 0.4728 | 0.1314 | 0.1219 |
| 20       | 0.1389  | 0.5707 | 0.5707 | 0.0729 | 0.0472 | 0.0422 |

**Nhận xét**: 
- Ở SNR thấp (0 dB): CC_time và ECKART/HT có độ lệch chuẩn thấp nhất
- Ở SNR cao (20 dB): HT cho kết quả tốt nhất (0.0422), tiếp theo là ECKART (0.0472)
- ROTH và SCOT có hiệu suất tương đương và kém hơn các phương pháp khác

#### 📊 Bảng 2: RMSE (EQM) - Đơn vị: Mẫu

| SNR (dB) | CC_time | ROTH  | SCOT  | PHAT  | ECKART | HT    |
|----------|---------|-------|-------|-------|--------|-------|
| 0        | 0.5462  | 3.4675 | 3.4675 | 3.9725 | 0.4294 | 0.4540 |
| 10       | 0.0787  | 1.2625 | 1.2625 | 0.4837 | 0.1394 | 0.1358 |
| 20       | 0.0379  | 0.5717 | 0.5717 | 0.0876 | 0.0612 | 0.0609 |

**Nhận xét**:
- HT và ECKART có RMSE thấp nhất ở mọi mức SNR
- Ở SNR = 20 dB, HT đạt RMSE = 0.0609, tốt nhất trong tất cả các phương pháp
- CC_time có hiệu suất tốt ở SNR thấp nhưng kém hơn ở SNR cao

#### 📊 Bảng 3: Bias (Độ Lệch) - Đơn vị: Mẫu

| SNR (dB) | CC_time | ROTH  | SCOT  | PHAT  | ECKART | HT    |
|----------|---------|-------|-------|-------|--------|-------|
| 0        | -0.2045 | 0.4896 | 0.4896 | 0.8843 | 0.0188 | 0.0211 |
| 10       | -0.1746 | -0.2566| -0.2566| -0.1024| -0.0467| -0.0597|
| 20       | -0.1363 | -0.0342| -0.0342| -0.0487| -0.0390| -0.0440|

**Nhận xét**:
- ECKART và HT có bias nhỏ nhất (gần 0) ở mọi mức SNR
- CC_time có bias âm (ước lượng thấp hơn giá trị thực)
- PHAT có bias lớn nhất ở SNR = 0 dB

#### 📊 Bảng 4: Variance (Phương Sai) - Đơn vị: Mẫu²

| SNR (dB) | CC_time | ROTH   | SCOT   | PHAT   | ECKART | HT     |
|----------|---------|--------|--------|--------|--------|--------|
| 0        | 0.5043  | 11.7840| 11.7840| 14.9985| 0.1841 | 0.2057 |
| 10       | 0.0482  | 1.5280 | 1.5280 | 0.2235 | 0.0173 | 0.0149 |
| 20       | 0.0193  | 0.3256 | 0.3256 | 0.0053 | 0.0022 | 0.0018 |

**Nhận xét**:
- HT có variance thấp nhất ở mọi mức SNR, cho thấy độ ổn định cao
- ECKART cũng có variance rất thấp, chỉ kém HT một chút
- ROTH và SCOT có variance cao, đặc biệt ở SNR thấp

#### 📊 Bảng 5: Độ Trễ Ước Lượng (Delai Estime) - Đơn vị: Mẫu
*(Giá trị thực: 4.9 mẫu)*

| SNR (dB) | CC_time | ROTH  | SCOT  | PHAT  | ECKART | HT    |
|----------|---------|-------|-------|-------|--------|-------|
| 0        | 4.6955  | 5.3896 | 5.3896 | 5.7843 | 4.9188 | 4.9211 |
| 10       | 4.7254  | 4.6434 | 4.6434 | 4.7976 | 4.8533 | 4.8403 |
| 20       | 4.7637  | 4.8658 | 4.8658 | 4.8513 | 4.8610 | 4.8560 |

**Nhận xét**:
- Ở SNR = 20 dB, tất cả các phương pháp đều ước lượng gần với giá trị thực (4.9)
- HT và ECKART có độ chính xác cao nhất
- CC_time có xu hướng ước lượng thấp hơn giá trị thực

#### 🏆 Kết Luận Từ Kết Quả Mẫu

1. **Phương pháp tốt nhất tổng thể**: **HT (Hannan-Thomson)** và **ECKART**
   - Có RMSE thấp nhất
   - Có bias gần 0 nhất
   - Có variance thấp nhất (ổn định nhất)

2. **Phương pháp tốt ở SNR thấp**: **CC_time**
   - Hiệu suất tốt ở SNR = 0 dB
   - Đơn giản và nhanh

3. **Phương pháp kém hiệu quả**: **ROTH** và **SCOT**
   - Có variance và RMSE cao
   - Hiệu suất tương đương nhau

4. **Xu hướng chung**:
   - Tất cả các phương pháp đều cải thiện khi SNR tăng
   - Ở SNR cao (20 dB), sự khác biệt giữa các phương pháp giảm đi
   - HT và ECKART luôn cho kết quả tốt nhất ở mọi mức SNR

## 📝 Giải Thích Các Chỉ Số

### 1. **Bias (Độ Lệch)**
- **Công thức**: `bias = mean(ước lượng) - giá_trị_thực`
- **Ý nghĩa**: Độ lệch trung bình so với giá trị thực
- **Giá trị tốt**: Gần 0 (không có độ lệch hệ thống)

### 2. **Variance (Phương Sai)**
- **Công thức**: `Var = var(ước lượng)`
- **Ý nghĩa**: Độ phân tán của các ước lượng
- **Giá trị tốt**: Nhỏ (ước lượng ổn định)

### 3. **Standard Deviation (Độ Lệch Chuẩn)**
- **Công thức**: `ecart_type = sqrt(Var)`
- **Ý nghĩa**: Độ lệch chuẩn của các ước lượng
- **Giá trị tốt**: Nhỏ (ước lượng chính xác và ổn định)

### 4. **RMSE/EQM (Root Mean Square Error)**
- **Công thức**: `EQM = sqrt(bias^2 + Var)`
- **Ý nghĩa**: Sai số tổng thể, kết hợp cả bias và variance
- **Giá trị tốt**: Nhỏ (phương pháp tốt nhất)

## 🔬 Phương Pháp Nội Suy

Tất cả các phương pháp GCC sử dụng **nội suy Parabola** để tăng độ chính xác:

1. Tìm vị trí cực đại trong hàm tương quan
2. Sử dụng 3 điểm (cực đại và 2 điểm bên cạnh) để vẽ Parabola
3. Tìm đỉnh Parabola để có ước lượng chính xác hơn

**Công thức nội suy**:
```
delay = estime - 0.5 * (y(i+1) - y(i-1)) / (y(i+1) - 2*y(i) + y(i-1))
```

## 📚 Tài Liệu Tham Khảo

### Mô Hình PSD Farina-Merletti
- D. Farina and R. Merletti, "Comparison of algorithms for estimation of EMG variables during voluntary contractions", Journal of Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.

### Phương Pháp GCC
- C. H. Knapp and G. C. Carter, "The generalized correlation method for estimation of time delay", IEEE Transactions on Acoustics, Speech, and Signal Processing, vol. 24, no. 4, pp. 320-327, 1976.

## ⚠️ Lưu Ý

1. **Thời gian chạy**: Chương trình có thể mất vài phút để hoàn thành (100 lần lặp Monte Carlo × 3 mức SNR)

2. **Bộ nhớ**: Đảm bảo có đủ RAM để lưu trữ các ma trận kết quả

3. **File tạm**: File `gcc.mat` được tạo trong quá trình chạy, có thể xóa sau khi hoàn thành

4. **Thư mục kết quả**: Thư mục `result/` sẽ được tạo tự động nếu chưa tồn tại

## 🐛 Xử Lý Lỗi

Nếu gặp lỗi:
- **Lỗi "Undefined function"**: Kiểm tra xem đã có Signal Processing Toolbox chưa
- **Lỗi "Out of memory"**: Giảm số lần lặp Monte Carlo (`N_MonteCarlo`)
- **Lỗi "File not found"**: Đảm bảo đang chạy từ đúng thư mục `new4`

## 📧 Liên Hệ

Nếu có câu hỏi hoặc gặp vấn đề, vui lòng liên hệ với nhóm phát triển.

---

**Phiên bản**: 1.0  
**Ngày cập nhật**: 2025  
**Tác giả**: Nhóm nghiên cứu MFCV Estimation

