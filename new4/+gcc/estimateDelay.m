% ==============================================================================
% TEN FILE: estimateDelay.m
% CHUC NANG: Uoc luong do tre bang noi suy Parabola
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Tim vi tri cuc dai trong ham tuong quan, sau do su dung noi suy 
%        Parabola de tang do chinh xac uoc luong do tre
%
% Nguyen ly: Gia su ham tuong quan co dang Parabola quanh diem cuc dai
%            Su dung 3 diem (cuc dai va 2 diem ben canh) de tim dinh Parabola
%
function delay = estimateDelay(correlation, peak_idx, N)

% Tinh uoc luong do tre ban dau (chua noi suy)
estime = abs(N/2 - peak_idx + 1);

% Noi suy Parabola
% Cong thuc: delay = estime - 0.5 * (y(i+1) - y(i-1)) / (y(i+1) - 2*y(i) + y(i-1))
% Trong do: y(i) la gia tri tai diem cuc dai, y(i+1) va y(i-1) la 2 diem ben canh
delay = estime - 0.5 * (correlation(peak_idx+1) - correlation(peak_idx-1)) / ...
        (correlation(peak_idx+1) - 2*correlation(peak_idx) + correlation(peak_idx-1));

end

