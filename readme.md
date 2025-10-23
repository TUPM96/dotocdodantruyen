# README – Mô phỏng ước lượng độ trễ sEMG bằng GCC

## 📘 Tổng quan

Đây là mã mô phỏng **ước lượng độ trễ (time delay)** giữa hai tín hiệu sEMG bằng các biến thể của **Generalized Cross-Correlation (GCC)**.  
Các phương pháp được đánh giá:

- **CC_time** – Tương quan chéo trong miền thời gian
- **GCC** – IFFT{Pxy} (tương quan chéo phổ)
- **PHAT** – Pxy / |Pxy|
- **ROTH** – Pxy / Pxx
- **SCOT** – Pxy / sqrt(Pxx * Pyy)
- **ECKART** – Bộ lọc Eckart
- **ML (HT)** – Phương pháp Maximum Likelihood (Hannan-Thompson)

Chương trình chạy mô phỏng Monte Carlo, chèn nhiễu Gaussian theo SNR, và tính **bias**, **variance**, **RMSE** để so sánh độ chính xác của các thuật toán.

---

## ⚙️ Cấu trúc tệp

| Tên tệp | Chức năng |
|----------|------------|
| `gcc_full.m` | Chương trình chính – chạy mô phỏng và vẽ biểu đồ |
| `Parameter_Script_cohF.m` | Tệp tham số (N, Fs, p, h_Length, …) |
| `sEMG_Generator.m` | Sinh tín hiệu sEMG đầu vào (2 kênh) |

> ⚠️ Hai tệp `Parameter_Script_cohF.m` và `sEMG_Generator.m` cần được cung cấp để chương trình chạy hoàn chỉnh.

---

## 💻 Yêu cầu hệ thống

- MATLAB **R2016a** trở lên (khuyến nghị R2018+)
- Signal Processing Toolbox (dùng các hàm `cpsd`, `hann`, `xcorr`, …)
- Nếu MATLAB cũ không có `tiledlayout`, mã đã có cơ chế tự động dùng `subplot` thay thế.

---

## ▶️ Cách chạy mô phỏng

1. Đặt tất cả các tệp trong cùng một thư mục MATLAB.
2. Mở MATLAB và chuyển tới thư mục đó:
   ```matlab
   cd('C:\path\to\your\folder')
