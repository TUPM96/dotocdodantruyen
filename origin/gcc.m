close all; clear all;
load Parameter_Script_cohF; delai_attendu=[4.9]; CV_attendu=5.10^-3/(4.9/2048);
Nm=100; % N MOtecarlo
SNR=[0 10 20];
nfft=N;
x=1:7;
D=zeros(Nm,length(SNR));
Ds=zeros(Nm,length(SNR));
Dgcc=zeros(Nm,length(SNR));
Dgccs=zeros(Nm,length(SNR));
Dphat=zeros(Nm,length(SNR));
Dphats=zeros(Nm,length(SNR));
DRoth=zeros(Nm,length(SNR));
DRoths=zeros(Nm,length(SNR));
Dml=zeros(Nm,length(SNR));
Dmls=zeros(Nm,length(SNR));
DScot=zeros(Nm,length(SNR));
Dscots=zeros(Nm,length(SNR));
DEckart=zeros(Nm,length(SNR));
DEckarts=zeros(Nm,length(SNR));
delai_estime=zeros(length(SNR),1);
delai_estime_s=zeros(length(SNR),1);
delai_estime_gcc=zeros(length(SNR),1);
delai_estime_gcc_s=zeros(length(SNR),1);
delai_estime_phat=zeros(length(SNR),1);
delai_estime_phat_s=zeros(length(SNR),1);
delai_estime_ml=zeros(length(SNR),1);
delai_estime_ml_s=zeros(length(SNR),1);
delai_estime_Roth=zeros(length(SNR),1);
delai_estime_Roth_s=zeros(length(SNR),1);
delai_estime_scot=zeros(length(SNR),1);
delai_estime_scot_s=zeros(length(SNR),1);
delai_estime_Eckart=zeros(length(SNR),1);
delai_estime_Eckart_s=zeros(length(SNR),1);
ccmaximum=zeros(Nm,1);
gccmaximum=zeros(Nm,1);
phatmaximum=zeros(Nm,1);
mlmaximum=zeros(Nm,1);
Rothmaximum=zeros(Nm,1);
Scotmaximum=zeros(Nm,1);
Eckartmaximum=zeros(Nm,1);
cctime=zeros(Nm,1);
gcctime=zeros(Nm,1);
phattime=zeros(Nm,1);
mltime=zeros(Nm,1);
Rothtime=zeros(Nm,1);
Scottime=zeros(Nm,1);
Eckarttime=zeros(Nm,1);
ccestime=zeros(Nm,1);
gccestime=zeros(Nm,1);
phatestime=zeros(Nm,1);
mlestime=zeros(Nm,1);
Rothestime=zeros(Nm,1);
Scotestime=zeros(Nm,1);
Eckartestime=zeros(Nm,1);
bias=zeros(length(SNR),1);
bias_s=zeros(length(SNR),1);
bias_gcc=zeros(length(SNR),1);
bias_gcc_s=zeros(length(SNR),1);
bias_phat=zeros(length(SNR),1);
bias_phat_s=zeros(length(SNR),1);
bias_ml=zeros(length(SNR),1);
bias_ml_s=zeros(length(SNR),1);
bias_Roth=zeros(length(SNR),1);
bias_Roth_s=zeros(length(SNR),1);
bias_scot=zeros(length(SNR),1);
bias_scot_s=zeros(length(SNR),1);
bias_Eckart=zeros(length(SNR),1);
bias_Eckart_s=zeros(length(SNR),1);
Var=zeros(length(SNR),1);
Var_s=zeros(length(SNR),1);
Var_gcc=zeros(length(SNR),1);
Var_gcc_s=zeros(length(SNR),1);
Var_phat=zeros(length(SNR),1);
Var_phat_s=zeros(length(SNR),1);
Var_Roth=zeros(length(SNR),1);
Var_Roth_s=zeros(length(SNR),1);
Var_ml=zeros(length(SNR),1);
Var_ml_s=zeros(length(SNR),1);
Var_scot=zeros(length(SNR),1);
Var_scot_s=zeros(length(SNR),1);
Var_Eckart=zeros(length(SNR),1);
Var_Eckart_s=zeros(length(SNR),1);
ecart_type=zeros(length(SNR),1);
ecart_type_s=zeros(length(SNR),1);
ecart_type_gcc=zeros(length(SNR),1);
ecart_type_gcc_s=zeros(length(SNR),1);
ecart_type_phat=zeros(length(SNR),1);
ecart_type_phat_s=zeros(length(SNR),1);
ecart_type_ml=zeros(length(SNR),1);
ecart_type_ml_s=zeros(length(SNR),1);
ecart_type_Roth=zeros(length(SNR),1);
ecart_type_Roth_s=zeros(length(SNR),1);
ecart_type_scot=zeros(length(SNR),1);
ecart_type_scot_s=zeros(length(SNR),1);
ecart_type_Eckart=zeros(length(SNR),1);
ecart_type_Eckart_s=zeros(length(SNR),1);
EQM=zeros(length(SNR),1);
EQM_s=zeros(length(SNR),1);
EQM_gcc=zeros(length(SNR),1);
EQM_gcc_s=zeros(length(SNR),1);
EQM_phat=zeros(length(SNR),1);
EQM_phat_s=zeros(length(SNR),1);
EQM_ml=zeros(length(SNR),1);
EQM_ml_s=zeros(length(SNR),1);
EQM_Roth=zeros(length(SNR),1);
EQM_Roth_s=zeros(length(SNR),1);
EQM_scot=zeros(length(SNR),1);
EQM_scot_s=zeros(length(SNR),1);
EQM_Eckart=zeros(length(SNR),1);
EQM_Eckart_s=zeros(length(SNR),1);
% RR12=zeros(20480,Nm,length(SNR));
% gcc=zeros(20480,Nm,length(SNR));
% phatgcc=zeros(20480,Nm,length(SNR));
% Rothgcc=zeros(20480,Nm,length(SNR));
% Scotgcc=zeros(20480,Nm,length(SNR));
% Eckartgcc=zeros(20480,Nm,length(SNR));
% mlgcc=zeros(20480,Nm,length(SNR));
%coeff=zeros(length(SNR),Nm,2);
% coeff_gcc=zeros(length(SNR),Nm);
% coeff_phat=zeros(length(SNR),Nm);
% coeff_Roth=zeros(length(SNR),Nm);
% coeff_scot=zeros(length(SNR),Nm);
% coeff_ml=zeros(length(SNR),Nm);
% coeff_Eckart=zeros(length(SNR),Nm);
% beta_gcc=zeros(length(SNR),Nm);
% beta_phat=zeros(length(SNR),Nm);
% beta_Roth=zeros(length(SNR),Nm);
% beta_scot=zeros(length(SNR),Nm);
% beta_ml=zeros(length(SNR),Nm);
% beta_Eckart=zeros(length(SNR),Nm);
% thetaestime_gcc=zeros(length(SNR),1);
% thetaestime_phat=zeros(length(SNR),1);
% thetaestime_Roth=zeros(length(SNR),1);
% thetaestime_scot=zeros(length(SNR),1);
% thetaestime_ml=zeros(length(SNR),1);
% thetaestime_Eckart=zeros(length(SNR),1);
% bias_phase_gcc=zeros(length(SNR),1);
% bias_phase_phat=zeros(length(SNR),1);
% bias_phase_ml=zeros(length(SNR),1);
% bias_phase_Roth=zeros(length(SNR),1);
% bias_phase_scot=zeros(length(SNR),1);
% bias_phase_Eckart=zeros(length(SNR),1);
% ecart_type_phase_gcc=zeros(length(SNR),1);
% ecart_type_phase_phat=zeros(length(SNR),1);
% ecart_type_phase_ml=zeros(length(SNR),1);
% ecart_type_phase_Roth=zeros(length(SNR),1);
% ecart_type_phase_scot=zeros(length(SNR),1);
% ecart_type_phase_Eckart=zeros(length(SNR),1);
% Var_phase_gcc=zeros(length(SNR),1);
% Var_phase_phat=zeros(length(SNR),1);
% Var_phase_ml=zeros(length(SNR),1);
% Var_phase_Roth=zeros(length(SNR),1);
% Var_phase_scot=zeros(length(SNR),1);
% Var_phase_Eckart=zeros(length(SNR),1);
% EQM_phase_gcc=zeros(length(SNR),1);
% EQM_phase_phat=zeros(length(SNR),1);
% EQM_phase_ml=zeros(length(SNR),1);
% EQM_phase_Roth=zeros(length(SNR),1);
% EQM_phase_scot=zeros(length(SNR),1);
% EQM_phase_Eckart=zeros(length(SNR),1);
maximum=delai_attendu+20;
minimum=delai_attendu-20;
fh = 120;           % 120 Hz
fl = 60;                % 60 Hz
k = 1;
f = linspace(0,Fs,N);
PSD = k*fh.^4.*f.^2./((f.^2+fl.^2).*(f.^2+fh.^2).^2);       % Ref : D. Farina and R. Merletti, "Comparison of algorithms for estimation of EMG variables during
% voluntary contractions", Journal of Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2))];                   % Creation of the second part of the spectrum.
PSD = PSD./max(PSD);
for ns=1:length(SNR),
    for nN=1:length(h_Length),
        win=hanning(h_Length(nN));
        n_overlap=length(win)/2;
        for i=1:Nm,
            [Vec_Signal,T,b] = sEMG_Generator('simu_semg', N, p,delai_attendu, Fs);
            s1=Vec_Signal(:,1);
            s2=Vec_Signal(:,2);
            s1_noise = Vec_Signal(:,1) + sqrt(var(Vec_Signal(:,1))*10^(-SNR(ns)/10))*randn(size(Vec_Signal(:,1)));
            s2_noise = Vec_Signal(:,2) + sqrt(var(Vec_Signal(:,2))*10^(-SNR(ns)/10))*randn(size(Vec_Signal(:,2)));
            [Pxx] = cpsd( s1_noise, s1_noise, win, n_overlap, nfft, Fs,'twoside');
            [Pyy] = cpsd( s2_noise, s2_noise, win, n_overlap, nfft, Fs,'twoside');
            [Pxy] = cpsd( s1_noise, s2_noise, win, n_overlap, nfft, Fs,'twoside');
            Gn1n1 =var(s1)*10^(-SNR(ns)/10);
            Gn2n2= var(s2)*10^(-SNR(ns)/10);
            Gx1x1=PSD*var(s1)/mean(PSD)+Gn1n1; Gx1x1=Gx1x1';%./max(Gx1x1);
            Gx2x2=PSD*var(s2)/mean(PSD)+Gn2n2; Gx2x2=Gx2x2';%./max(Gx2x2);
            Gss=PSD';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (temporel)
            [Rx1x2,lag1] = xcorr(s1_noise,s2_noise,length(s1_noise)/2);Rx1x2=Rx1x2(1:end-1);lag1=lag1(1:end-1);
            [Rx1,lag2]   = xcorr(s1_noise,length(s1_noise)/2);Rx1=Rx1(1:end-1);lag2=lag2(1:end-1);
            [Rx2,lag3]   = xcorr(s2_noise,length(s2_noise)/2);Rx2=Rx2(1:end-1);lag3=lag3(1:end-1);
            % determine the lag.
            [ccmaximum(i) cctime(i)]=max(Rx1x2);
            ccestime(i)=abs(N/2-cctime(i)+1);
            % paraplolique interpolation
            D(i,ns)=ccestime(i)-0.5*(Rx1x2(cctime(i)+1)-Rx1x2(cctime(i)-1))/(Rx1x2(cctime(i)+1)-2*Rx1x2(cctime(i))+Rx1x2(cctime(i)-1));
            delai_estime(ns)=mean(D(:,ns));
            bias(ns)=delai_estime(ns)-delai_attendu;
            Var(ns)=var(D(:,ns));
            ecart_type(ns)=sqrt(Var(ns));
            EQM(ns)=bias(ns)^2+Var(ns);
            % Shanon interpolation
            %Ds(i,nN)=ccestime(i)+Rx1x2(cctime(i)+1)/(Rx1x2(cctime(i))+Rx1x2(cctime(i)+1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (fréquentiel)
            %gcc=Gx1x2;
            gcccorrelation =fftshift(ifft(Pxy));
            [gccmaximum(i),gcctime(i)]=max(gcccorrelation);
            gccestime(i)=abs(N/2-gcctime(i)+1);
            % parabolique interpolation
            Dgcc(i,ns)=gccestime(i)-0.5*(gcccorrelation(gcctime(i)+1)-gcccorrelation(gcctime(i)-1))/(gcccorrelation(gcctime(i)+1)-2*gcccorrelation(gcctime(i))+gcccorrelation(gcctime(i)-1));
            delai_estime_gcc(ns)=mean(Dgcc(:,ns));
            bias_gcc(ns)=delai_estime_gcc(ns)-delai_attendu;
            Var_gcc(ns)=var(Dgcc(:,ns));
            ecart_type_gcc(ns)=sqrt(Var_gcc(ns));
            % Shanon interpolation
            % Dgccs(i,nN)=gccestime(i)+gcccorrelation(gcctime(i)+1)/(gcccorrelation(gcctime(i))+gcccorrelation(gcctime(i)+1));
            %        % Affichage
            %         figure(i);subplot(231),plot(lag1,gcccorrelation);axis([minimum maximum -inf inf]);
            %         legend('GCC simple');grid on;xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',Dgcc(i,ns),delai_attendu, SNR(ns));title(S);
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %         figure(2);subplot(231),plot(abs(Pxy));legend('GCC simple');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenSize'))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method using the Roth filter;
            %Rothfilter=Pxx;Roth=Pxy./Rothfilter;
            Rothcorrelation=fftshift(ifft(Pxy./Gx1x1));%Rothgcc(:,ns,i)=Rothcorrelation;
            %         Rothgcc(:,i,ns)=Rothcorrelation;
            %         RothgccSNR=mlgcc(:,:,ns); %
            % GCC method:find the peak postion of the filtered crosscorrelation;
            %Rothcorrelation=abs(Rothcorrelation);
            [Rothmaximum(i),Rothtime(i)]=max(Rothcorrelation);
            Rothestime(i)=abs(N/2-Rothtime(i)+1);
            % paraplolique interpolation
            DRoth(i,ns)=Rothestime(i)-0.5*(Rothcorrelation(Rothtime(i)+1)-Rothcorrelation(Rothtime(i)-1))/(Rothcorrelation(Rothtime(i)+1)-2*Rothcorrelation(Rothtime(i))+Rothcorrelation(Rothtime(i)-1));
            delai_estime_Roth(ns)=mean(DRoth(:,ns));
            bias_Roth(ns)=delai_estime_Roth(ns)-delai_attendu;
            Var_Roth(ns)=var(DRoth(:,ns));
            ecart_type_Roth(ns)=sqrt(Var_Roth(ns));
            % Shanon interpolation
            % DRoths(i,nN)=Rothestime(i)+Rothcorrelation(Rothtime(i)+1)/(Rothcorrelation(Rothtime(i))+Rothcorrelation(Rothtime(i)+1));
            %        Affichage
            %         figure(i);subplot(232),plot(lag1,Rothcorrelation);axis([minimum maximum -inf inf]);
            %         legend('Roth');grid on;xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',DRoth(i,ns),delai_attendu, SNR(ns));title(S);
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %         figure(2);subplot(232),plot(abs(Pxy./Gx1x1));legend('Roth');grid on; xlabel('Fréquences');ylabel('DSP corrigée');
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method; using the SCOT filter;
            %Scotfilter=sqrt(Gx1x1.*Pyy);Scot=Pxy./Scotfilter;
            Scotcorrelation=fftshift((ifft(Pxy./sqrt(Gx1x1.*Gx2x2))));%Scotgcc(:,ns,i)= Scotcorrelation;
            %         Scotgcc(ns,i,:)=Scotcorrelation;
            %         ScotgccSNR(:,ns)=Scotgcc(:,ns,:); %
            % GCC method:find the peak postion of the filtered crosscorrelation;
            %Scotcorrelation=abs(Scotcorrelation);
            [Scotmaximum(i),Scottime(i)]=max(Scotcorrelation);
            Scotestime(i)=abs(N/2-Scottime(i)+1);
            % paraplolique interpolation
            DScot(i,ns)=Scotestime(i)-0.5*(Scotcorrelation(Scottime(i)+1)-Scotcorrelation(Scottime(i)-1))/(Scotcorrelation(Scottime(i)+1)-2*Scotcorrelation(Scottime(i))+Scotcorrelation(Scottime(i)-1));
            delai_estime_scot(i,ns)=mean(DScot(:,ns));
            bias_scot(ns)=delai_estime_scot(ns)-delai_attendu;
            Var_scot(ns)=var(DScot(:,ns));
            ecart_type_scot(ns)=sqrt(Var_scot(ns));
            % Shanon interpolation
            %Dscots(i,nN)=Scotestime(i)+Scotcorrelation(Scottime(i)+1)/(Scotcorrelation(Scottime(i))+Scotcorrelation(Scottime(i)+1));
            % %        Affichage
            %         figure(i);subplot(233),plot(lag1,Scotcorrelation);axis([minimum maximum -inf inf]);
            %         legend('scott');grid on;xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',DScot(i,ns),delai_attendu, SNR(ns));title(S);
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %         figure(2);subplot(233),plot(abs(Pxy./sqrt(Gx1x1.*Gx2x2)));legend('scot');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenSize'))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Phat filter
            %phatfilter=abs(Pxy);phat=Pxy./phatfilter;
            phatcorrelation=fftshift(ifft(Pxy./(Gss+0.1)));%phatgcc(ns,i,:)=phatcorrelation;
            %        phatgcc(:,i,ns)=phatcorrelation;
            %         phatgccSNR=phatgcc(:,ns,i); %
            %phatfilter=real(Gx1x2);
            %phatcorrelation=abs(phatcorrelation);
            [phatmaximum(i),phattime(i)]=max(phatcorrelation);
            phatestime(i)=abs(N/2-phattime(i)+1);
            % paraplolique interpolation
            Dphat(i,ns)=phatestime(i)-0.5*(phatcorrelation(phattime(i)+1)-phatcorrelation(phattime(i)-1))/(phatcorrelation(phattime(i)+1)-2*phatcorrelation(phattime(i))+phatcorrelation(phattime(i)-1));
            delai_estime_phat(ns)=mean(Dphat(:,ns));
            bias_phat(ns)=delai_estime_phat(ns)-delai_attendu;
            Var_phat(ns)=var(Dphat(:,ns));
            ecart_type_phat(ns)=sqrt(Var_phat(ns));
            % Shanon interpolation
            %Dphats(i,nN)=phatestime(i)+phatcorrelation(phattime(i)+1)/(phatcorrelation(phattime(i))+phatcorrelation(phattime(i)+1));
            %       % Affichage
            %         figure(i);subplot(234),plot(lag1,phatcorrelation);axis([minimum maximum -inf inf]);
            %         legend('phat');grid on;xlabel('Nombre d''échantillonN');ylabel('Fonction d''Intercorrélation ');
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',Dphat(i,nN),delai_attendu, SNR(nN));title(S);
            % %         set(gcf,'Position',get(0,'ScreenNize'))
            %         figure(2);subplot(234),plot(abs(Pxy./(Gss+0.1)));legend('phat');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenNize'))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method; using the eckark filter;
            %AbsPxy=abs(Pxy);Eckartfilter=Pxy.*AbsPxy./((Gx1x1-AbsPxy).*(Gyy-AbsPxy));Eckart=Pxy./Eckartfil
            %Eckart=Pxy./Eckartfilter;
            Eckartcorrelation=fftshift(ifft(Pxy.*Gss./(Gn1n1.*Gn2n2)));
            % Eckartcorrelation=abs(Eckartcorrelation);
            %         Eckartgcc(:,i,nN)=Eckartcorrelation;
            %         EckartgccSNR=Eckartgcc(:,:,nN); %
            % Eckartgcc(:,nN,i)=Eckartcorrelation;
            % GCC method:find the peak postion of the filtered
            % crosscorrelation;
            [Eckartmaximum(i),Eckarttime(i)]=max(Eckartcorrelation);
            Eckartestime(i)=abs(N/2-Eckarttime(i)+1);
            % paraplolique interpolation
            DEckart(i,ns)=Eckartestime(i)-0.5*(Eckartcorrelation(Eckarttime(i)+1)-Eckartcorrelation(Eckarttime(i)-1))/(Eckartcorrelation(Eckarttime(i)+1)-2*Eckartcorrelation(Eckarttime(i))+Eckartcorrelation(Eckarttime(i)-1));
            delai_estime_Eckart(ns)=mean(DEckart(:,ns));
            bias_Eckart(ns)=delai_estime_Eckart(ns)-delai_attendu;
            Var_Eckart(ns)=var(DEckart(:,ns));
            ecart_type_Eckart(ns)=sqrt(Var_Eckart(ns));
            % Shanon interpolation
            %DEckarts(i,nN)=Eckartestime(i)+Eckartcorrelation(Eckarttime(i)+1)/(Eckartcorrelation(Eckarttime(i))+Eckartcorrelation(Eckarttime(i)+1));
            %      %  Affichage
            %         figure(i);subplot(235),plot(lag1,Eckartcorrelation);axis([minimum maximum -inf inf]);
            %         legend('Eckart');grid on; xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',DEckart(i,nN),delai_attendu, SNR(nN));title(S);
            % %         set(gcf,'Position',get(0,'ScreenNize'))
            %         figure(2);subplot(235),plot(abs(Pxy.*Gss./(Gn1n1.*Gn2n2)));legend('Eckart');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenNize'))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ml filter Hannan Thompson
            %squaremlGamma12_carreerence=Cx1x2.^2;
            %mlfilter=squaremlGamma12_carreerence.*Gx1x2/(phatfilter.*(1-squaremlGamma12_carreerence));
            %Gamma12_carre  = abs(Pxy).^2./(Gx1x1.*Gx2x2);
            %mlfilter=phat.*Gamma12_carre./(1-Gamma12_carre);
            mlcorrelation=fftshift(ifft(Pxy.*Gss./(Gss.*(Gn1n1+Gn2n2)+Gn1n1.*Gn2n2)));
            %         mlgcc(:,i,nN)=mlcorrelation;
            %         mlgccSNR=mlgcc(:,:,nN); %
            %mlgcc(:,nN,i)=mlcorrelation;
            % ML method:find the peak postion of ML correlation;
            % mlcorrelation=abs(mlcorrelation);
            [mlmaximum(i),mltime(i)]=max(mlcorrelation);
            mlestime(i)=abs(N/2-mltime(i)+1);
            % paraplolique interpolation
            Dml(i,ns)=mlestime(i)-0.5*(mlcorrelation(mltime(i)+1)-mlcorrelation(mltime(i)-1))/(mlcorrelation(mltime(i)+1)-2*mlcorrelation(mltime(i))+mlcorrelation(mltime(i)-1));
            delai_estime_ml(ns)=mean(Dml(:,ns));
            bias_ml(ns)=delai_estime_ml(ns)-delai_attendu;
            Var_ml(ns)=var(Dml(:,ns));
            ecart_type_ml(ns)=sqrt(Var_ml(ns));
            EQM_gcc(ns)=sqrt(bias_gcc(ns)^2+Var_gcc(ns));
            EQM_Roth(ns)=sqrt(bias_Roth(ns)^2+Var_Roth(ns));
            EQM_scot(ns)=sqrt(bias_scot(ns)^2+Var_scot(ns));
            EQM_ml(ns)=sqrt(bias_ml(ns).^2+Var_ml(ns));
            EQM_phat(ns)=sqrt(bias_phat(ns)^2+Var_phat(ns));
            EQM_Eckart(ns)=sqrt(bias_Eckart(ns)^2+Var_Eckart(ns));
            
            % Shanon interpolation
            %Dmls(i,nN)=mlestime(i)+mlcorrelation(mltime(i)+1)/(mlcorrelation(mltime(i))+mlcorrelation(mltime(i)+1));
            %      %   Affichage
            %         figure(i);subplot(236),plot(lag1,mlcorrelation);axis([minimum maximum -inf inf]);
            %         legend('HT');grid on;xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',Dml(i,ns),delai_attendu, SNR(ns));title(S);
            %         figure(2);subplot(236),plot(abs(Pxy.*Gss./(Gss.*(Gn1n1+Gn2n2)+Gn1n1.*Gn2n2)));legend('HT');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenSize'))
            
            %     delai_estime(nN)=mean(D(:,nN));
            %     bias(nN)=delai_estime(nN)-delai_attendu;
            %     Var(nN)=var(D(:,nN));
            %     ecart_type(nN)=sqrt(Var(nN));
            %     EQM(nN)=bias(nN)^2+Var(nN);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (temporel)
            %
            
            % Shanon interpolation
            %         delai_estime_s(nN)=mean(Ds(:,nN));
            %         bias_s(nN)=delai_estime_s(nN)-delai_attendu;
            %         Var_s(nN)=var(Ds(:,nN));
            %         ecart_type_s(nN)= sqrt(Var_s(nN));
            %         %EQM_s(nN)=bias_s(nN)^2+Var_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (fréquentiel)
            % parabolique interpolation
            
            
            %         % Shanon interpolation
            %         delai_estime_gcc_s(nN)=mean(Dgccs(:,nN));
            %         bias_gcc_s(nN)=delai_estime_gcc_s(nN)-delai_attendu;
            %         Var_gcc_s(nN)=var(Dgccs(:,nN));
            %         ecart_type_gcc_s(nN)=sqrt(Var_gcc(nN));
            %         EQM_gcc_s(nN)=bias_gcc_s(nN)^2+Var_gcc_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method using the Roth filter;
            % paraplolique interpolation
            
            
            % Shanon interpolation
            %         delai_estime_Roth_s(nN)=mean(DRoths(:,nN));
            %         bias_Roth_s(nN)=delai_estime_Roth_s(nN)-delai_attendu;
            %         Var_Roth_s(nN)=var(DRoths(:,nN));
            %         ecart_type_Roth_s(nN)=sqrt(Var_Roth_s(nN));
            %         EQM_Roth_s(nN)=bias_Roth_s(nN)^2+Var_Roth_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method; using the SCOT filter;
            % paraplolique interpolation
            
            
            % Shanon interpolation
            %         delai_estime_scot_s(nN)=mean(Dscots(:,nN));
            %         bias_scot_s(nN)=delai_estime_scot_s(nN)-delai_attendu;
            %         Var_scot_s(nN)=var(Dscots(:,nN));
            %         ecart_type_scot_s(nN)=sqrt(Var_scot_s(nN));
            %         EQM_scot_s(nN)=bias_scot_s(nN)^2+Var_scot_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Phat filter
            % paraplolique interpolation
            
            
            % Shanon interpolation
            %         delai_estime_phat_s(nN)=mean(Dphats(:,nN));
            %         bias_phat_s(nN)=delai_estime_phat_s(nN)-delai_attendu;
            %         Var_phat_s(nN)=var(Dphats(:,nN));
            %         ecart_type_phat_s(nN)=sqrt(Var_phat_s(nN));
            %         EQM_phat_s(nN)=bias_phat_s(nN)^2+Var_phat_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %GCC method; using the eckark filter;
            % paraplolique interpolation
            
            
            % Shanon interpolation
            %         delai_estime_Eckart_s(nN)=mean(DEckarts(:,nN));
            %         bias_Eckart_s(nN)=delai_estime_Eckart_s(nN)-delai_attendu;
            %         Var_Eckart_s(nN)=var(DEckarts(:,nN));
            %         ecart_type_Eckart_s(nN)=sqrt(Var_Eckart_s(nN));
            %         EQM_Eckart_s(nN)=bias_Eckart_s(nN)^2+Var_Eckart_s(nN);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ml filter Hannan Thompson
            % paraplolique interpolation
            
            % Shanon interpolation
            %         delai_estime_ml_s(nN)=mean(Dmls(:,nN));
            %         bias_ml_s(nN)=delai_estime_ml_s(nN)-delai_attendu;
            %         Var_ml_s(nN)=var(Dmls(:,nN));
            %         ecart_type_ml_s(nN)=sqrt(Var_ml_s(nN));
            %         EQM_ml_s(nN)=bias_ml_s(nN)^2+Var_ml_s(nN);
            
            
            % paraplolique interpolation
            
            save gcc;
            %     X=1:length(h_Length)
            %     bar(ecart_type)
            %     legend('0 dB' ,'5 dB', '10 dB' ,'15 dB', '20 dB', '25 dB', '30 dB')
            %     Y2=delai_estime_ml;
            %     E2=ecart_type_ml;hold;
            %     errorbar(X,Y2,E2,'b--');
            %     set(gca,'XTick',1:length(h_Length)),
            %     set(gca,'XTickLabel',{h_Length})
            %     ylabel('Ecart_type en échantillon');
            %     xlabel('Largeurs des fenêtres (en échantillon)');
            %     S1=sprintf('Ecart-type en function des largeurs des fenêtres, SNR=%d dB',SNR(ns));
            %     title(S1);
            %     hold on;
            %     plot(X,delai_attendu.*ones(size(X)),'*r');
            %     legend('Eckart','HT', 'True value');
            %     grid on;
            %     hold on;
            %     figure;
            %     Y=delai_estime_ml;
            %     E=ecart_type_ml;
            %      errorbar(X,Y,E)
            %     set(gca,'XTick',1:length(h_Length)),
            %     set(gca,'XTickLabel',{h_Length})
            %     ylabel('Ecart_type en échantillon');
            %     xlabel('Largeurs des fenêtres (en échantillon)');
            %     S1=sprintf('Ecart-type en function des largeurs des fenêtres,Méthode "HT", SNR=%d dB',SNR(ns));
            %     title(S1);
            %     hold
            %     plot(X,delai_attendu.*ones(size(X)),'*r');
            %      legend('Standard deviation','True value');
            %     grid on;
            %     hold on;
            %EQM
            %     figure;
            %     stem(X,EQM_Eckart,'r');
            %     set(gca,'XTick',1:length(h_Length)),
            %     set(gca,'XTickLabel',{h_Length})
            %     ylabel('EQM (échantillon)');
            %     xlabel('Largeurs des fenêtres (échantillon)');
            %     S1=sprintf('EQM en function des largeurs des fenêtres, SNR=%d dB',SNR(ns));
            %     title(S1);hold on;
            %     stem(X,EQM_ml,'b');
            %     set(gca,'XTick',1:length(h_Length)),
            %     set(gca,'XTickLabel',{h_Length})
            %     ylabel('EQM (échantillon)');
            %     xlabel('Largeurs des fenêtres (échantillon)');
            %     legend('Eckart','HT');
        end;
    end;
end;
% save resultats_interp_parabol D Dgcc Dphat Dml DRoth DScot SNR Fs  delai_attendu Var bias ecart_type Var_gcc bias_gcc ecart_type_gcc Var_phat ecart_type_phat bias_phat Var_scot bias_scot ecart_type_scot Var_Roth bias_Roth ecart_type_Roth Var_ml bias_ml ecart_type_ml Var_Eckart bias_Eckart ecart_type_Eckart
% save resultats_interp_shannon Ds Dgccs Dphats Dmls DRoths Dscots SNR Fs  delai_attendu Var_s bias_s ecart_type_s Var_gcc_s bias_gcc_s ecart_type_gcc_s Var_phat_s ecart_type_phat_s bias_phat_s Var_scot_s bias_scot_s ecart_type_scot_s Var_Roth_s bias_Roth_s ecart_type_Roth_s Var_ml_s bias_ml_s ecart_type_ml_s Var_Eckart_s bias_Eckart_s ecart_type_Eckart_s
% save crosscorelationgenere2
% %Affichage les resultats stastistiques
% for ns=1:length(SNR),
%     figure
%     x=[1:6];
%     y=[delai_estime_gcc(ns),delai_estime_Roth(ns),delai_estime_scot(ns),delai_estime_Eckart(ns),delai_estime_phat(ns),delai_estime_ml(ns)];
%     e=[ecart_type_gcc(ns),ecart_type_Roth(ns),ecart_type_scot(ns),ecart_type_Eckart(ns),ecart_type_phat(ns),ecart_type_ml(ns)];
%     errorbar(x,y,e);
%     xlabel('Methods')
%     ylabel('Time delay (samples)')
%     S1=sprintf(' SNR=%d dB',SNR(ns));
%     title(S1);
%     set(gca,'XTick',1:6);
%     set(gca,'XTickLabel',[ 'CC    '; 'ROTH  ';'SCOT  ';'Eckart' ;'PHAT  ';'HT    ']);
%     hold on ;
%     plot(x,delai_attendu.*ones(size(x)),'*r');
%     legend('Standard deviation','True value');
%     axis([0 7 delai_attendu-0.5 delai_attendu+0.5]);
%     figure;
%     z=[EQM_gcc(ns),EQM_Roth(ns),EQM_scot(ns),EQM_Eckart(ns),EQM_phat(ns),EQM_ml(ns)];
%     %errorbar(x,delai_attendu.*ones(size(x)),z);
%     stem(x,z)
%     xlabel('Methods')
%     ylabel('  MSE(samples)');
%     S2=sprintf('SNR=%d dB',SNR(ns));
%     title(S2 );
%     set(gca,'XTick',1:6)
%     set(gca,'XTickLabel',[ 'CC    '; 'ROTH  ';'SCOT  ';'Eckart' ;'PHAT  ';'HT    ']);
%     axis([0 7 0 0.05])
% end
% figure
% plot(EQM_Eckart); hold ; plot(EQM_ml,'r');
% legend('Eckart','HT'),
% set(gca,'XTick',1:6);
% set(gca,'XTickLabel',[ '2 ';'4 ';'6 ';'8 ';'10';'12']);
% ylabel('EQM en échantillon');
% xlabel('RSB en dB');
% title('Erreur quadratique moyenne en function de RSB');
% 
% affichage
figure;
 bar(ecart_type, 'DisplayName', 'ecart_type', 'YDataSource', 'ecart_type'); figure(gcf);
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('Ecart-type en échantillon');
 xlabel('RSB en dB');
 legend('CC')
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure;
 bar(ecart_type_Eckart, 'DisplayName', 'ecart_type_Eckart', 'YDataSource', 'ecart_type_Eckart'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('Ecart-type en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "Filtre d''Eckart" ')
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure;
 bar(ecart_type_Roth, 'DisplayName', 'ecart_type_Roth', 'YDataSource', 'ecart_type_Roth'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('Ecart-type en échantillon');
 xlabel('RSB en dB');
 title(' Méthode: "Roth" ');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure
 bar(ecart_type_ml, 'DisplayName', 'ecart_type_Roth', 'YDataSource', 'ecart_type_Roth'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('Ecart-type en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "HT" ');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure
 bar(ecart_type_phat, 'DisplayName', 'ecart_type_phat', 'YDataSource', 'ecart_type_phat'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('Ecart-type en échantillon');
 xlabel('RSB en dB');
 title('Méthode : "PHAT" ');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure;
 bar(EQM, 'DisplayName', 'EQM', 'YDataSource', 'EQM'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title('Méthode : "Corrélation simple" ');
 figure;
 bar(EQM_Eckart, 'DisplayName', 'EQM_Eckart', 'YDataSource', 'EQM_Eckart'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "Filtre d''Eckart" ')
 figure;
 bar(EQM_Roth, 'DisplayName', 'EQM_Roth', 'YDataSource', 'EQM_Roth'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "Roth" ');
 figure;
 bar(EQM_ml, 'DisplayName', 'EQM_ml', 'YDataSource', 'EQM_ml'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "HT" ');
 figure;
 bar(EQM_scot, 'DisplayName', 'EQM_scot', 'YDataSource', 'EQM_scot'); figure(gcf);
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title('Méthode : "scot" ');
 figure;
 bar(EQM_phat, 'DisplayName', 'EQM_phat', 'YDataSource', 'EQM_phat'); figure(gcf)
 set(gca,'XTick',1:length(SNR)),
 set(gca,'XTickLabel',['0 ';'10';'20']);
 ylabel('EQM en échantillon');
 xlabel('RSB en dB');
 title(' Méthode : "PHAT" '); 