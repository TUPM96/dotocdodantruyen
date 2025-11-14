% ==============================================================================
% TEN FILE: ccTime.m
% CHUC NANG: Phuong phap CC_time - Tuong quan cheo mien thoi gian
% MODULE: gcc
% ==============================================================================
%
% Mo ta: Tinh tuong quan cheo giua hai tin hieu trong mien thoi gian
%        Tim vi tri cuc dai de uoc luong do tre
%
% Phuong phap: Su dung ham xcorr de tinh tuong quan cheo
%              Tim diem cuc dai va noi suy Parabola de tang do chinh xac
%
function delay = ccTime(s1_noise, s2_noise, N)

% Tinh tuong quan cheo giua hai tin hieu
% xcorr tra ve tuong quan cheo va lag (do tre)
[Rx1x2, lag1] = xcorr(s1_noise, s2_noise, length(s1_noise)/2);
Rx1x2 = Rx1x2(1:end-1);
lag1 = lag1(1:end-1);

% Tim vi tri cuc dai
[~, cctime] = max(Rx1x2);
ccestime = abs(N/2 - cctime + 1);

% Noi suy Parabola de tang do chinh xac
delay = ccestime - 0.5 * (Rx1x2(cctime+1) - Rx1x2(cctime-1)) / ...
        (Rx1x2(cctime+1) - 2*Rx1x2(cctime) + Rx1x2(cctime-1));

end

