# LaTeX Supplementary Materials

## 📁 Cấu trúc thư mục

```
paper/
├── README.md                      # File này
├── gcc_theory_detailed.tex        # Lý thuyết GCC chi tiết
├── experimental_results.tex       # Kết quả thực nghiệm chi tiết
├── references.bib                 # Tài liệu tham khảo (BibTeX)
└── figures/                       # Thư mục chứa hình ảnh (cần tạo)
```

## 📝 Mô tả các file

### 1. `gcc_theory_detailed.tex`

File này chứa phần bổ sung chi tiết về lý thuyết Generalized Cross-Correlation (GCC), bao gồm:

- **Giới thiệu chung về GCC**: Lịch sử phát triển, ứng dụng
- **Mô hình tín hiệu**: Giả thiết, phương trình toán học
- **Hàm tương quan chéo**: Định nghĩa, tính chất
- **GCC trong miền tần số**: Biến đổi Fourier, hàm trọng số
- **7 phương pháp GCC chi tiết**:
  - Cross-Correlation (CC)
  - GCC cơ bản
  - ROTH Processor
  - SCOT (Smoothed Coherence Transform)
  - PHAT (Phase Transform)
  - ECKART Filter
  - Hannan-Thomson (HT) / Maximum Likelihood
- **Nội suy Parabolic**: Công thức, ý nghĩa
- **Bảng so sánh**: Ưu/nhược điểm từng phương pháp

**Số trang**: ~15-20 trang

**Số công thức toán học**: 40+ equations

**Số bảng**: 1 bảng so sánh chi tiết

### 2. `experimental_results.tex`

File này chứa phần phân tích kết quả thực nghiệm chi tiết, bao gồm:

- **Thiết lập thực nghiệm**: Tham số mô phỏng Monte Carlo
- **Mô hình tín hiệu sEMG**: Phương trình Farina-Merletti
- **Kết quả RMSE**: Bảng số liệu với độ tin cậy 95%
- **Phân tích Bias vs Variance**: Thành phần MSE
- **Thời gian tính toán**: So sánh hiệu năng
- **Độ sắc nét đỉnh**: Peak-to-Sidelobe Ratio (PSR)
- **Phân tích phổ tần số**: Hiệu ứng các bộ lọc
- **Hiệu ứng nội suy**: Cải thiện độ chính xác
- **Ảnh hưởng Monte Carlo**: Số lần lặp tối ưu
- **So sánh với các nghiên cứu trước**: Literature review
- **Khuyến nghị**: Lựa chọn phương pháp theo ứng dụng
- **Hạn chế và hướng cải tiến**

**Số trang**: ~20-25 trang

**Số bảng**: 10 bảng dữ liệu

**Số hình**: 1 hình (placeholder)

### 3. `references.bib`

File BibTeX chứa 40+ tài liệu tham khảo, phân loại theo:

- Lý thuyết GCC (Knapp & Carter, Benesty, Omologo)
- Tín hiệu sEMG và MFCV (Farina, Merletti, Lindstrom)
- Phương pháp xử lý tín hiệu (Oppenheim, Proakis)
- Ứng dụng y sinh (SENIAM, McGill)
- Machine Learning (Phinyomark, Faust)
- Thống kê (Montgomery, Wasserman)
- Cơ sở lý thuyết (Kay, Hannan-Thomson, Eckart)
- Cơ sở sinh lý (Guyton, Basmajian)
- Databases (NinaPro, Atzori)

## 🔗 Cách sử dụng

### Tích hợp vào file main.tex chính

#### Bước 1: Thêm phần lý thuyết GCC

Trong file `main.tex` chính, sau phần giới thiệu về MFCV (khoảng dòng 550-650), thêm:

```latex
% Sau section 2.4 "Các phương pháp ước lượng MFCV"
% Thêm phần chi tiết về GCC

\input{paper/gcc_theory_detailed.tex}
```

#### Bước 2: Thêm phần kết quả thực nghiệm

Trong Chương 4 (Thực nghiệm và đánh giá kết quả), thay thế hoặc bổ sung:

```latex
% Trong Chapter 4
% Sau phần mô tả quy trình thực nghiệm

\input{paper/experimental_results.tex}
```

#### Bước 3: Thêm bibliography

Ở cuối file `main.tex`, trước `\end{document}`:

```latex
% Tài liệu tham khảo
\bibliographystyle{ieeetr}  % hoặc plain, alpha, tùy theo yêu cầu
\bibliography{paper/references}

\end{document}
```

### Compile LaTeX

#### Sử dụng XeLaTeX (khuyến nghị cho tiếng Việt):

```bash
xelatex main.tex
bibtex main
xelatex main.tex
xelatex main.tex
```

#### Hoặc sử dụng latexmk (tự động):

```bash
latexmk -xelatex -interaction=nonstopmode main.tex
```

## 📊 Tạo hình ảnh

File `experimental_results.tex` có placeholder cho hình vẽ. Bạn cần tạo hình minh họa:

### Hình cần thiết:

1. **Phổ tần số các phương pháp GCC**
   - File: `figures/gcc_spectrum.pdf`
   - Nội dung: So sánh phổ của 7 phương pháp GCC

2. **Biểu đồ RMSE theo SNR**
   - File: `figures/rmse_vs_snr.pdf`
   - Nội dung: Line plot, 7 curves, x-axis: SNR, y-axis: RMSE

3. **Hàm tương quan của các phương pháp**
   - File: `figures/correlation_functions.pdf`
   - Nội dung: Subplot 3x2, mỗi subplot là một hàm tương quan

### Tạo hình từ MATLAB:

```matlab
% Trong file main.m, sau khi vẽ biểu đồ, lưu hình:

% Lưu biểu đồ RMSE
saveas(gcf, 'paper/figures/rmse_vs_snr.pdf');
saveas(gcf, 'paper/figures/rmse_vs_snr.png', 'png');

% Lưu hàm tương quan
saveas(gcf, 'paper/figures/correlation_functions.pdf');

% Lưu phổ GCC
saveas(gcf, 'paper/figures/gcc_spectrum.pdf');
```

## ✏️ Tùy chỉnh

### Thay đổi font size của bảng

Nếu bảng quá lớn, thêm:

```latex
\begin{table}[h!]
\centering
\small  % hoặc \footnotesize, \scriptsize
\caption{...}
...
\end{table}
```

### Xoay bảng ngang (landscape)

```latex
\usepackage{rotating}

\begin{sidewaystable}
\centering
\caption{...}
...
\end{sidewaystable}
```

### Thay đổi style citation

Trong preamble của `main.tex`:

```latex
% IEEE style (khuyến nghị cho báo cáo kỹ thuật)
\bibliographystyle{ieeetr}

% Harvard style
\bibliographystyle{agsm}

% Numeric style
\bibliographystyle{unsrt}
```

## 📈 Thống kê nội dung

### gcc_theory_detailed.tex

- Số sections: 1 main section với 5 subsections
- Số equations: 42 equations
- Số tables: 1 comparison table
- Số figures: 0 (pure theory)
- Ước tính số trang: 18-22 trang

### experimental_results.tex

- Số sections: 1 main section với 7 subsections
- Số equations: 15 equations
- Số tables: 10 detailed tables
- Số figures: 1 (placeholder)
- Ước tính số trang: 22-28 trang

### references.bib

- Số tài liệu: 43 references
- Phân loại:
  - Journal articles: 28
  - Books: 9
  - Conference papers: 3
  - Theses: 1
  - Technical reports: 2

## 🔍 Kiểm tra

### Checklist trước khi compile:

- [ ] Đã tạo thư mục `paper/figures/`
- [ ] Đã có file ảnh logo: `iuh.jpg` (nếu cần)
- [ ] Đã cài đặt XeLaTeX và BibTeX
- [ ] Đã có font Times New Roman (cho tiếng Việt)
- [ ] Đã add `\input{paper/...}` vào đúng vị trí trong main.tex
- [ ] Đã kiểm tra các label cross-reference

### Compile thử:

```bash
# Test compile chỉ lý thuyết GCC
xelatex paper/gcc_theory_detailed.tex

# Test compile chỉ kết quả
xelatex paper/experimental_results.tex

# Test compile full
xelatex main.tex
```

## 💡 Tips

1. **Tốc độ compile**: File này rất dài, dùng `draft` mode khi chỉnh sửa:
   ```latex
   \documentclass[draft]{report}
   ```

2. **Cross-reference**: Tất cả equations, tables, figures đều có label riêng, dễ dàng cite:
   ```latex
   Như đã trình bày trong phương trình~\eqref{eq:psi_phat}...
   Bảng~\ref{tab:rmse_results} cho thấy...
   ```

3. **Chú thích công thức**: Mỗi equation đều có giải thích chi tiết các ký hiệu

4. **Thống nhất ký hiệu**:
   - $\tau$ cho time delay
   - $\omega$ cho frequency
   - $\Psi$ cho weighting function
   - $G$ cho PSD/CPSD

## 📧 Contact

Nếu có vấn đề khi compile hoặc cần sửa đổi, liên hệ qua repository issues.

## 📜 License

Nội dung này thuộc về đề tài khóa luận tốt nghiệp. Sử dụng cho mục đích học thuật.

---

**Cập nhật lần cuối**: 2025-01-14

**Tác giả**: Nguyễn Ngọc Trung – Lê Bùi Tiến Hưng

**Giảng viên hướng dẫn**: TS. Lưu Gia Thiện
