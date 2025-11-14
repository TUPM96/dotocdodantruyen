%% ================== gcc_sim_standardized.m ==================
% Mo ta:
% - Mo phong uoc luong do tre giua 2 kenh sEMG bang cac bien the GCC:
%   CC (xcorr thoi gian), GCC (Pxy), PHAT, ROTH, SCOT, ECKART, HT.
% - Tinh bias, Var, ecart_type (Std), EQM (MSE) theo tung muc SNR.
% - Ve nhieu chart rieng tung phuong phap (khong gop chart).
% - Giu day du cac ma tran khoi tao rong .
% Chu y:
% - Yeu cau file Parameter_Script_cohF.(mat|m) de co N, Fs, p, h_Length.
% - Yeu cau ham sEMG_Generator('simu_semg', N, p, delai_attendu, Fs).

close all; clear all; clc;

%% ===== Nap tham so =====
if exist('Parameter_Script_cohF.mat','file')
    load Parameter_Script_cohF;            % ky vong co: N, Fs, p, h_Length
elseif exist('Parameter_Script_cohF.m','file')
    run('Parameter_Script_cohF.m');
end
% Gia tri an toan neu chua co
if ~exist('N','var'),        N  = 2048;    end
if ~exist('Fs','var'),       Fs = 2048;    end
if ~exist('p','var'),        p  = 0.5;     end
if ~exist('h_Length','var') || isempty(h_Length), h_Length = 128; end

%% ===== Cau hinh =====
delai_attendu = 4.9;                          % delay ky vong (mau)
CV_attendu    = 5.10^-3/(4.9/2048);           % 
Nm            = 100;                           % so lan Monte Carlo
SNR           = [0 10 20];                     % cac muc SNR (dB)
nfft          = N;

x = 1:7; %#ok<NASGU> % 

%% ===== Khoi tao ma tran rong () =====
D=zeros(Nm,length(SNR));        Ds=zeros(Nm,length(SNR));
Dgcc=zeros(Nm,length(SNR));     Dgccs=zeros(Nm,length(SNR));
Dphat=zeros(Nm,length(SNR));    Dphats=zeros(Nm,length(SNR));
DRoth=zeros(Nm,length(SNR));    DRoths=zeros(Nm,length(SNR));
Dml=zeros(Nm,length(SNR));      Dmls=zeros(Nm,length(SNR));
DScot=zeros(Nm,length(SNR));    Dscots=zeros(Nm,length(SNR));
DEckart=zeros(Nm,length(SNR));  DEckarts=zeros(Nm,length(SNR));

delai_estime=zeros(length(SNR),1);        delai_estime_s=zeros(length(SNR),1);
delai_estime_gcc=zeros(length(SNR),1);    delai_estime_gcc_s=zeros(length(SNR),1);
delai_estime_phat=zeros(length(SNR),1);   delai_estime_phat_s=zeros(length(SNR),1);
delai_estime_ml=zeros(length(SNR),1);     delai_estime_ml_s=zeros(length(SNR),1);
delai_estime_Roth=zeros(length(SNR),1);   delai_estime_Roth_s=zeros(length(SNR),1);
delai_estime_scot=zeros(length(SNR),1);   delai_estime_scot_s=zeros(length(SNR),1);
delai_estime_Eckart=zeros(length(SNR),1); delai_estime_Eckart_s=zeros(length(SNR),1);

ccmaximum=zeros(Nm,1);    gccmaximum=zeros(Nm,1);
phatmaximum=zeros(Nm,1);  mlmaximum=zeros(Nm,1);
Rothmaximum=zeros(Nm,1);  Scotmaximum=zeros(Nm,1);
Eckartmaximum=zeros(Nm,1);

cctime=zeros(Nm,1);    gcctime=zeros(Nm,1);
phattime=zeros(Nm,1);  mltime=zeros(Nm,1);
Rothtime=zeros(Nm,1);  Scottime=zeros(Nm,1);
Eckarttime=zeros(Nm,1);

ccestime=zeros(Nm,1);      gccestime=zeros(Nm,1);
phatestime=zeros(Nm,1);    mlestime=zeros(Nm,1);
Rothestime=zeros(Nm,1);    Scotestime=zeros(Nm,1);
Eckartestime=zeros(Nm,1);

bias=zeros(length(SNR),1);         bias_s=zeros(length(SNR),1);
bias_gcc=zeros(length(SNR),1);     bias_gcc_s=zeros(length(SNR),1);
bias_phat=zeros(length(SNR),1);    bias_phat_s=zeros(length(SNR),1);
bias_ml=zeros(length(SNR),1);      bias_ml_s=zeros(length(SNR),1);
bias_Roth=zeros(length(SNR),1);    bias_Roth_s=zeros(length(SNR),1);
bias_scot=zeros(length(SNR),1);    bias_scot_s=zeros(length(SNR),1);
bias_Eckart=zeros(length(SNR),1);  bias_Eckart_s=zeros(length(SNR),1);

Var=zeros(length(SNR),1);         Var_s=zeros(length(SNR),1);
Var_gcc=zeros(length(SNR),1);     Var_gcc_s=zeros(length(SNR),1);
Var_phat=zeros(length(SNR),1);    Var_phat_s=zeros(length(SNR),1);
Var_Roth=zeros(length(SNR),1);    Var_Roth_s=zeros(length(SNR),1);
Var_ml=zeros(length(SNR),1);      Var_ml_s=zeros(length(SNR),1);
Var_scot=zeros(length(SNR),1);    Var_scot_s=zeros(length(SNR),1);
Var_Eckart=zeros(length(SNR),1);  Var_Eckart_s=zeros(length(SNR),1);

ecart_type=zeros(length(SNR),1);        ecart_type_s=zeros(length(SNR),1);
ecart_type_gcc=zeros(length(SNR),1);    ecart_type_gcc_s=zeros(length(SNR),1);
ecart_type_phat=zeros(length(SNR),1);   ecart_type_phat_s=zeros(length(SNR),1);
ecart_type_ml=zeros(length(SNR),1);     ecart_type_ml_s=zeros(length(SNR),1);
ecart_type_Roth=zeros(length(SNR),1);   ecart_type_Roth_s=zeros(length(SNR),1);
ecart_type_scot=zeros(length(SNR),1);   ecart_type_scot_s=zeros(length(SNR),1);
ecart_type_Eckart=zeros(length(SNR),1); ecart_type_Eckart_s=zeros(length(SNR),1);

EQM=zeros(length(SNR),1);        EQM_s=zeros(length(SNR),1);
EQM_gcc=zeros(length(SNR),1);    EQM_gcc_s=zeros(length(SNR),1);
EQM_phat=zeros(length(SNR),1);   EQM_phat_s=zeros(length(SNR),1);
EQM_ml=zeros(length(SNR),1);     EQM_ml_s=zeros(length(SNR),1);
EQM_Roth=zeros(length(SNR),1);   EQM_Roth_s=zeros(length(SNR),1);
EQM_scot=zeros(length(SNR),1);   EQM_scot_s=zeros(length(SNR),1);
EQM_Eckart=zeros(length(SNR),1); EQM_Eckart_s=zeros(length(SNR),1);

%% ===== PSD sEMG (Farina - Merletti) =====
maximum = delai_attendu + 20;
minimum = delai_attendu - 20;

fh = 120; fl = 60; k = 1;
f  = linspace(0,Fs,N);
PSD = k*fh.^4.*f.^2 ./ ((f.^2+fl.^2).*(f.^2+fh.^2).^2);
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];
PSD = PSD./max(PSD);

%% ===== Ham phu tro: noi suy parabol an toan bien =====
parabolic = @(r, idx) ...
    ( idx>1 && idx<numel(r) ) .* ...
    ( idx - 0.5*(r(idx+1)-r(idx-1)) / max(r(idx+1)-2*r(idx)+r(idx-1),eps) ) + ...
    ( (idx<=1 || idx>=numel(r)) .* idx );

%% ===== Vong lap mo phong =====
for ns = 1:length(SNR)
    for nN = 1:length(h_Length)
        win       = hanning(h_Length(nN));
        n_overlap = length(win)/2;

        for i = 1:Nm
            % --- Sinh tin hieu ---
            [Vec_Signal, T, b] = sEMG_Generator('simu_semg', N, p, delai_attendu, Fs); %#ok<ASGLU>
            s1 = Vec_Signal(:,1);
            s2 = Vec_Signal(:,2);

            % --- Chen nhieu theo SNR ---
            s1_noise = s1 + sqrt(var(s1)*10^(-SNR(ns)/10)) * randn(size(s1));
            s2_noise = s2 + sqrt(var(s2)*10^(-SNR(ns)/10)) * randn(size(s2));

            % --- PSD/ CPSD two-sided ---
            Pxx = cpsd(s1_noise, s1_noise, win, n_overlap, nfft, Fs, 'twosided');
            Pyy = cpsd(s2_noise, s2_noise, win, n_overlap, nfft, Fs, 'twosided');
            Pxy = cpsd(s1_noise, s2_noise, win, n_overlap, nfft, Fs, 'twosided');

            % --- DSP xap xi cho hai kenh  ---
            Gn1n1 = var(s1)*10^(-SNR(ns)/10);
            Gn2n2 = var(s2)*10^(-SNR(ns)/10);
            Gx1x1 = PSD.'*var(s1)/mean(PSD) + Gn1n1;    % vector cot
            Gx2x2 = PSD.'*var(s2)/mean(PSD) + Gn2n2;    % vector cot
            Gss   = PSD.';                               % dung lai o mot so bo loc

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 1) CC (mien thoi gian)
            [Rx1x2, lag1] = xcorr(s1_noise, s2_noise, length(s1_noise)/2);
            Rx1x2 = Rx1x2(1:end-1); lag1 = lag1(1:end-1);
            [ccmaximum(i), cctime(i)] = max(Rx1x2);              % vi tri dinh
            ccestime(i) = abs(N/2 - cctime(i) + 1);
            % noi suy parabol quanh dinh
            idx = cctime(i);
            if idx>1 && idx<numel(Rx1x2)
                D(i,ns) = ccestime(i) - 0.5*(Rx1x2(idx+1)-Rx1x2(idx-1)) / ...
                                     max(Rx1x2(idx+1)-2*Rx1x2(idx)+Rx1x2(idx-1), eps);
            else
                D(i,ns) = ccestime(i);
            end
            delai_estime(ns) = mean(D(:,ns));
            bias(ns)         = delai_estime(ns) - delai_attendu;
            Var(ns)          = var(D(:,ns));
            ecart_type(ns)   = sqrt(Var(ns));
            EQM(ns)          = bias(ns)^2 + Var(ns);            % MSE

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 2) GCC (khong loc)
            gcccorrelation = fftshift(ifft(Pxy));
            [gccmaximum(i), gcctime(i)] = max(gcccorrelation);
            gccestime(i) = abs(N/2 - gcctime(i) + 1);
            idx = gcctime(i);
            if idx>1 && idx<numel(gcccorrelation)
                Dgcc(i,ns) = gccestime(i) - 0.5*(gcccorrelation(idx+1)-gcccorrelation(idx-1)) / ...
                                           max(gcccorrelation(idx+1)-2*gcccorrelation(idx)+gcccorrelation(idx-1), eps);
            else
                Dgcc(i,ns) = gccestime(i);
            end
            delai_estime_gcc(ns) = mean(Dgcc(:,ns));
            bias_gcc(ns)         = delai_estime_gcc(ns) - delai_attendu;
            Var_gcc(ns)          = var(Dgcc(:,ns));
            ecart_type_gcc(ns)   = sqrt(Var_gcc(ns));
            EQM_gcc(ns)          = bias_gcc(ns)^2 + Var_gcc(ns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 3) ROTH
            Rothcorrelation = fftshift(ifft(Pxy ./ Gx1x1));
            [Rothmaximum(i), Rothtime(i)] = max(Rothcorrelation);
            Rothestime(i) = abs(N/2 - Rothtime(i) + 1);
            idx = Rothtime(i);
            if idx>1 && idx<numel(Rothcorrelation)
                DRoth(i,ns) = Rothestime(i) - 0.5*(Rothcorrelation(idx+1)-Rothcorrelation(idx-1)) / ...
                                           max(Rothcorrelation(idx+1)-2*Rothcorrelation(idx)+Rothcorrelation(idx-1), eps);
            else
                DRoth(i,ns) = Rothestime(i);
            end
            delai_estime_Roth(ns) = mean(DRoth(:,ns));
            bias_Roth(ns)         = delai_estime_Roth(ns) - delai_attendu;
            Var_Roth(ns)          = var(DRoth(:,ns));
            ecart_type_Roth(ns)   = sqrt(Var_Roth(ns));
            EQM_Roth(ns)          = bias_Roth(ns)^2 + Var_Roth(ns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 4) SCOT
            Scotcorrelation = fftshift(ifft(Pxy ./ sqrt(Gx1x1.*Gx2x2)));
            [Scotmaximum(i), Scottime(i)] = max(Scotcorrelation);
            Scotestime(i) = abs(N/2 - Scottime(i) + 1);
            idx = Scottime(i);
            if idx>1 && idx<numel(Scotcorrelation)
                DScot(i,ns) = Scotestime(i) - 0.5*(Scotcorrelation(idx+1)-Scotcorrelation(idx-1)) / ...
                                           max(Scotcorrelation(idx+1)-2*Scotcorrelation(idx)+Scotcorrelation(idx-1), eps);
            else
                DScot(i,ns) = Scotestime(i);
            end
            delai_estime_scot(ns) = mean(DScot(:,ns));
            bias_scot(ns)         = delai_estime_scot(ns) - delai_attendu;
            Var_scot(ns)          = var(DScot(:,ns));
            ecart_type_scot(ns)   = sqrt(Var_scot(ns));
            EQM_scot(ns)          = bias_scot(ns)^2 + Var_scot(ns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 5) PHAT 
            phatcorrelation = fftshift(ifft(Pxy ./ (Gss + 0.1)));
            [phatmaximum(i), phattime(i)] = max(phatcorrelation);
            phatestime(i) = abs(N/2 - phattime(i) + 1);
            idx = phattime(i);
            if idx>1 && idx<numel(phatcorrelation)
                Dphat(i,ns) = phatestime(i) - 0.5*(phatcorrelation(idx+1)-phatcorrelation(idx-1)) / ...
                                           max(phatcorrelation(idx+1)-2*phatcorrelation(idx)+phatcorrelation(idx-1), eps);
            else
                Dphat(i,ns) = phatestime(i);
            end
            delai_estime_phat(ns) = mean(Dphat(:,ns));
            bias_phat(ns)         = delai_estime_phat(ns) - delai_attendu;
            Var_phat(ns)          = var(Dphat(:,ns));
            ecart_type_phat(ns)   = sqrt(Var_phat(ns));
            EQM_phat(ns)          = bias_phat(ns)^2 + Var_phat(ns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 6) ECKART (sua bien cho dung: dung Gx2x2 thay cho Gyy)
            Eckartcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gn1n1.*Gn2n2)));
            [Eckartmaximum(i), Eckarttime(i)] = max(Eckartcorrelation);
            Eckartestime(i) = abs(N/2 - Eckarttime(i) + 1);
            idx = Eckarttime(i);
            if idx>1 && idx<numel(Eckartcorrelation)
                DEckart(i,ns) = Eckartestime(i) - 0.5*(Eckartcorrelation(idx+1)-Eckartcorrelation(idx-1)) / ...
                                             max(Eckartcorrelation(idx+1)-2*Eckartcorrelation(idx)+Eckartcorrelation(idx-1), eps);
            else
                DEckart(i,ns) = Eckartestime(i);
            end
            delai_estime_Eckart(ns) = mean(DEckart(:,ns));
            bias_Eckart(ns)         = delai_estime_Eckart(ns) - delai_attendu;
            Var_Eckart(ns)          = var(DEckart(:,ns));
            ecart_type_Eckart(ns)   = sqrt(Var_Eckart(ns));
            EQM_Eckart(ns)          = bias_Eckart(ns)^2 + Var_Eckart(ns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 7) HT (Hannan-Thompson / ML don gian)
            mlcorrelation = fftshift(ifft(Pxy .* Gss ./ (Gss.*(Gn1n1+Gn2n2) + Gn1n1.*Gn2n2)));
            [mlmaximum(i), mltime(i)] = max(mlcorrelation);
            mlestime(i) = abs(N/2 - mltime(i) + 1);
            idx = mltime(i);
            if idx>1 && idx<numel(mlcorrelation)
                Dml(i,ns) = mlestime(i) - 0.5*(mlcorrelation(idx+1)-mlcorrelation(idx-1)) / ...
                                        max(mlcorrelation(idx+1)-2*mlcorrelation(idx)+mlcorrelation(idx-1), eps);
            else
                Dml(i,ns) = mlestime(i);
            end
            delai_estime_ml(ns) = mean(Dml(:,ns));
            bias_ml(ns)         = delai_estime_ml(ns) - delai_attendu;
            Var_ml(ns)          = var(Dml(:,ns));
            ecart_type_ml(ns)   = sqrt(Var_ml(ns));
            EQM_ml(ns)          = bias_ml(ns)^2 + Var_ml(ns);

            % Luu tam ()
            % save gcc;
        end
    end
end

%% ===== Ve bieu do (khong gop chart, ) =====
% Ecart-type: CC
figure; bar(ecart_type, 'DisplayName', 'ecart_type'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)'); legend('CC');

% Ecart-type: Eckart
figure; bar(ecart_type_Eckart, 'DisplayName', 'ecart_type_Eckart'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)');
title('Phuong phap: "Eckart"');

% Ecart-type: Roth
figure; bar(ecart_type_Roth, 'DisplayName', 'ecart_type_Roth'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)');
title('Phuong phap: "Roth"');

% Ecart-type: HT
figure; bar(ecart_type_ml, 'DisplayName', 'ecart_type_ml'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)');
title('Phuong phap: "HT"');

% Ecart-type: PHAT
figure; bar(ecart_type_phat, 'DisplayName', 'ecart_type_phat'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)');
title('Phuong phap: "PHAT"');

% Ecart-type: SCOT
figure; bar(ecart_type_scot, 'DisplayName', 'ecart_type_scot'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('Ecart-type (echantillon)'); xlabel('RSB (dB)');
title('Phuong phap: "SCOT"');

% EQM (MSE): CC
figure; bar(EQM, 'DisplayName', 'EQM'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "CC"');

% EQM (MSE): Eckart
figure; bar(EQM_Eckart, 'DisplayName', 'EQM_Eckart'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "Eckart"');

% EQM (MSE): Roth
figure; bar(EQM_Roth, 'DisplayName', 'EQM_Roth'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "Roth"');

% EQM (MSE): HT
figure; bar(EQM_ml, 'DisplayName', 'EQM_ml'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "HT"');

% EQM (MSE): SCOT
figure; bar(EQM_scot, 'DisplayName', 'EQM_scot'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "SCOT"');

% EQM (MSE): PHAT
figure; bar(EQM_phat, 'DisplayName', 'EQM_phat'); figure(gcf);
set(gca,'XTick',1:length(SNR)), set(gca,'XTickLabel',['0 ';'10';'20']);
ylabel('EQM (echantillon^2)'); xlabel('RSB (dB)');
title('Phuong phap: "PHAT"');

%% ===== Ghi chu ve nhan truc X cho bieu do so sanh phuong phap =====
% set(gca,'XTickLabel',[ 'CC    '; 'ROTH  '; 'SCOT  '; 'Eckart'; 'PHAT  '; 'HT    ']);
