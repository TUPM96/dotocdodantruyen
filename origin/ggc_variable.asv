close all; clear all;
load Parameter_Script_cohF; delai_attendu=[4.9]; CV_attendu=5.10^-3/(4.2/2048);
Nm=100; % N MOtecarlo
SNR=[0 5 10 15];
nfft=N;
x=1:7;
maximum=delai_attendu+20;
minimum=delai_attendu-20;
fh = 120;           % 120 Hz
fl = 60;                % 60 Hz
k = 1;
f = linspace(0,Fs,N);
PSD = k*fh.^4.*f.^2./((f.^2+fl.^2).*(f.^2+fh.^2).^2);       % Ref : D. Farina and R. Merletti, "Comparison of algorithms for estimation of EMG variables during
% voluntary contractions", Journal of Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000.
PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2)) ];                   % Creation of the second part of the spectrum.
PSD = PSD./max(PSD);
for ns=1:length(SNR),
    for nN=1:length(h_Length),
        win=hanning(h_Length(nN));
        n_overlap=length(win)/2;
        for i=1:Nm,
            [Vec_Signal,T,b] = sEMG_Generator('simu_semg', N, p,Delay, Fs);
            s1=Vec_Signal(:,1);
            s2=Vec_Signal(:,2);
            s1_noise = Vec_Signal(:,1) + sqrt(var(Vec_Signal(:,1))*10^(-SNR(ns)/10))*randn(size(Vec_Signal(:,1)));
            s2_noise = Vec_Signal(:,2) + sqrt(var(Vec_Signal(:,2))*10^(-SNR(ns)/10))*randn(size(Vec_Signal(:,2)));
            [Pxx] = cpsd( s1_noise, s1_noise, win, n_overlap, nfft, Fs,'twoside');
            [Pyy] = cpsd( s2_noise, s2_noise, win, n_overlap, nfft, Fs,'twoside');
            [Pxy] = cpsd( s1_noise, s2_noise, win, n_overlap, nfft, Fs,'twoside');
            Gn1n1 =var(s1)*10^(-SNR(ns)/10);
            Gn2n2= var(s2)*10^(-SNR(ns)/10);
            Gx1x1=PSD+Gn1n1; Gx1x1=Gx1x1';%./max(Gx1x1);
            Gx2x2=PSD+Gn2n2; Gx2x2=Gx2x2';%./max(Gx2x2);
            Gss=PSD';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (temporel)
            [Rx1x2,lag1] = xcorr(s1_noise,s2_noise,length(s1_noise)/2);Rx1x2=Rx1x2(1:end-1);lag1=lag1(1:end-1);
            [Rx1,lag2]   = xcorr(s1_noise,length(s1_noise)/2);Rx1=Rx1(1:end-1);lag2=lag2(1:end-1);
            [Rx2,lag3]   = xcorr(s2_noise,length(s2_noise)/2);Rx2=Rx2(1:end-1);lag3=lag3(1:end-1);
            % determine the lag
            [ccmaximum(i) cctime(i)]=max(Rx1x2);
            ccestime(i)=abs(N/2-cctime(i)+1);
            % paraplolique interpolation
            D(i,nN)=ccestime(i)-0.5*(Rx1x2(cctime(i)+1)-Rx1x2(cctime(i)-1))/(Rx1x2(cctime(i)+1)-2*Rx1x2(cctime(i))+Rx1x2(cctime(i)-1));
            % Shanon interpolation
            Ds(i,nN)=ccestime(i)+Rx1x2(cctime(i)+1)/(Rx1x2(cctime(i))+Rx1x2(cctime(i)+1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GCC filter (fréquentiel)
            %gcc=Gx1x2;
            gcccorrelation =fftshift(ifft(Pxy));
            [gccmaximum(i),gcctime(i)]=max(gcccorrelation);
            gccestime(i)=abs(N/2-gcctime(i)+1);
            % parabolique interpolation
            Dgcc(i,nN)=gccestime(i)-0.5*(gcccorrelation(gcctime(i)+1)-gcccorrelation(gcctime(i)-1))/(gcccorrelation(gcctime(i)+1)-2*gcccorrelation(gcctime(i))+gcccorrelation(gcctime(i)-1));
            % Shanon interpolation
            Dgccs(i,nN)=gccestime(i)+gcccorrelation(gcctime(i)+1)/(gcccorrelation(gcctime(i))+gcccorrelation(gcctime(i)+1));
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
            DRoth(i,nN)=Rothestime(i)-0.5*(Rothcorrelation(Rothtime(i)+1)-Rothcorrelation(Rothtime(i)-1))/(Rothcorrelation(Rothtime(i)+1)-2*Rothcorrelation(Rothtime(i))+Rothcorrelation(Rothtime(i)-1));
            % Shanon interpolation
            DRoths(i,nN)=Rothestime(i)+Rothcorrelation(Rothtime(i)+1)/(Rothcorrelation(Rothtime(i))+Rothcorrelation(Rothtime(i)+1));
            % %       Affichage
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
            DScot(i,nN)=Scotestime(i)-0.5*(Scotcorrelation(Scottime(i)+1)-Scotcorrelation(Scottime(i)-1))/(Scotcorrelation(Scottime(i)+1)-2*Scotcorrelation(Scottime(i))+Scotcorrelation(Scottime(i)-1));
            % Shanon interpolation
            Dscots(i,nN)=Scotestime(i)+Scotcorrelation(Scottime(i)+1)/(Scotcorrelation(Scottime(i))+Scotcorrelation(Scottime(i)+1));
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
            Dphat(i,nN)=phatestime(i)-0.5*(phatcorrelation(phattime(i)+1)-phatcorrelation(phattime(i)-1))/(phatcorrelation(phattime(i)+1)-2*phatcorrelation(phattime(i))+phatcorrelation(phattime(i)-1));
            % Shanon interpolation
            Dphats(i,nN)=phatestime(i)+phatcorrelation(phattime(i)+1)/(phatcorrelation(phattime(i))+phatcorrelation(phattime(i)+1));
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
            DEckart(i,nN)=Eckartestime(i)-0.5*(Eckartcorrelation(Eckarttime(i)+1)-Eckartcorrelation(Eckarttime(i)-1))/(Eckartcorrelation(Eckarttime(i)+1)-2*Eckartcorrelation(Eckarttime(i))+Eckartcorrelation(Eckarttime(i)-1));
            % Shanon interpolation
            DEckarts(i,nN)=Eckartestime(i)+Eckartcorrelation(Eckarttime(i)+1)/(Eckartcorrelation(Eckarttime(i))+Eckartcorrelation(Eckarttime(i)+1));
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
            Dml(i,nN)=mlestime(i)-0.5*(mlcorrelation(mltime(i)+1)-mlcorrelation(mltime(i)-1))/(mlcorrelation(mltime(i)+1)-2*mlcorrelation(mltime(i))+mlcorrelation(mltime(i)-1));
            % Shanon interpolation
            Dmls(i,nN)=mlestime(i)+mlcorrelation(mltime(i)+1)/(mlcorrelation(mltime(i))+mlcorrelation(mltime(i)+1));
            %      %   Affichage
            %         figure(i);subplot(236),plot(lag1,mlcorrelation);axis([minimum maximum -inf inf]);
            %         legend('HT');grid on;xlabel('Nombre d''échantillons');ylabel('Fonction d''Intercorrélation ');
            % %         set(gcf,'Position',get(0,'ScreenSize'))
            %         S = sprintf('estime = %f ech, attendu : %f ech, RSB=%f',Dml(i,ns),delai_attendu, SNR(ns));title(S);
            %         figure(2);subplot(236),plot(abs(Pxy.*Gss./(Gss.*(Gn1n1+Gn2n2)+Gn1n1.*Gn2n2)));legend('HT');grid on;xlabel('Fréquences');ylabel('DSP corrigée');
            %         set(gcf,'Position',get(0,'ScreenSize'))
        end
        %     delai_estime(nN)=mean(D(:,nN));
        %     bias(nN)=delai_estime(nN)-delai_attendu;
        %     Var(nN)=var(D(:,nN));
        %     ecart_type(nN)=sqrt(Var(nN));
        %     EQM(nN)=bias(nN)^2+Var(nN);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GCC filter (temporel)
        % paraplolique interpolation
        delai_estime(nN)=mean(D(:,nN));
        bias(nN)=delai_estime(nN)-delai_attendu;
        Var(nN)=var(D(:,nN));
        ecart_type(nN)=sqrt(Var(nN));
        EQM(nN)=bias(nN)^2+Var(nN);
        % Shanon interpolation
        delai_estime_s(nN)=mean(Ds(:,nN));
        bias_s(nN)=delai_estime_s(nN)-delai_attendu;
        Var_s(nN)=var(Ds(:,nN));
        ecart_type_s(nN)= sqrt(Var_s(nN));
        EQM_s(nN)=bias_s(nN)^2+Var_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GCC filter (fréquentiel)
        % parabolique interpolation
        delai_estime_gcc(nN)=mean(Dgcc(:,nN));
        bias_gcc(nN)=delai_estime_gcc(nN)-delai_attendu;
        Var_gcc(nN)=var(Dgcc(:,nN));
        ecart_type_gcc(nN)=sqrt(Var_gcc(nN));
        EQM_gcc(nN)=bias_gcc(nN)^2+Var_gcc(nN);
        % Shanon interpolation
        delai_estime_gcc_s(nN)=mean(Dgccs(:,nN));
        bias_gcc_s(nN)=delai_estime_gcc_s(nN)-delai_attendu;
        Var_gcc_s(nN)=var(Dgccs(:,nN));
        ecart_type_gcc_s(nN)=sqrt(Var_gcc(nN));
        EQM_gcc_s(nN)=bias_gcc_s(nN)^2+Var_gcc_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GCC method using the Roth filter;
        % paraplolique interpolation
        delai_estime_Roth(nN)=mean(DRoth(:,nN));
        bias_Roth(nN)=delai_estime_Roth(nN)-delai_attendu;
        Var_Roth(nN)=var(DRoth(:,nN));
        ecart_type_Roth(nN)=sqrt(Var_Roth(nN));
        EQM_Roth(nN)=bias_Roth(nN)^2+Var_Roth(nN);
        % Shanon interpolation
        delai_estime_Roth_s(nN)=mean(DRoths(:,nN));
        bias_Roth_s(nN)=delai_estime_Roth_s(nN)-delai_attendu;
        Var_Roth_s(nN)=var(DRoths(:,nN));
        ecart_type_Roth_s(nN)=sqrt(Var_Roth_s(nN));
        EQM_Roth_s(nN)=bias_Roth_s(nN)^2+Var_Roth_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GCC method; using the SCOT filter;
        % paraplolique interpolation
        delai_estime_scot(nN)=mean(DScot(:,nN));
        bias_scot(nN)=delai_estime_scot(nN)-delai_attendu;
        Var_scot(nN)=var(DScot(:,nN));
        ecart_type_scot(nN)=sqrt(Var_scot(nN));
        EQM_scot(nN)=bias_scot(nN)^2+Var_scot(nN);
        % Shanon interpolation
        delai_estime_scot_s(nN)=mean(Dscots(:,nN));
        bias_scot_s(nN)=delai_estime_scot_s(nN)-delai_attendu;
        Var_scot_s(nN)=var(Dscots(:,nN));
        ecart_type_scot_s(nN)=sqrt(Var_scot_s(nN));
        EQM_scot_s(nN)=bias_scot_s(nN)^2+Var_scot_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Phat filter
        % paraplolique interpolation
        delai_estime_phat(nN)=mean(Dphat(:,nN));
        bias_phat(nN)=delai_estime_phat(nN)-delai_attendu;
        Var_phat(nN)=var(Dphat(:,nN));
        ecart_type_phat(nN)=sqrt(Var_phat(nN));
        EQM_phat(nN)=bias_phat(nN)^2+Var_phat(nN);
        % Shanon interpolation
        delai_estime_phat_s(nN)=mean(Dphats(:,nN));
        bias_phat_s(nN)=delai_estime_phat_s(nN)-delai_attendu;
        Var_phat_s(nN)=var(Dphats(:,nN));
        ecart_type_phat_s(nN)=sqrt(Var_phat_s(nN));
        EQM_phat_s(nN)=bias_phat_s(nN)^2+Var_phat_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %GCC method; using the eckark filter;
        % paraplolique interpolation
        delai_estime_Eckart(nN)=mean(DEckart(:,nN));
        bias_Eckart(nN)=delai_estime_Eckart(nN)-delai_attendu;
        Var_Eckart(nN)=var(DEckart(:,nN));
        ecart_type_Eckart(nN)=sqrt(Var_Eckart(nN));
        EQM_Eckart(nN)=bias_Eckart(nN)^2+Var_Eckart(nN);
        % Shanon interpolation
        delai_estime_Eckart_s(nN)=mean(DEckarts(:,nN));
        bias_Eckart_s(nN)=delai_estime_Eckart_s(nN)-delai_attendu;
        Var_Eckart_s(nN)=var(DEckarts(:,nN));
        ecart_type_Eckart_s(nN)=sqrt(Var_Eckart_s(nN));
        EQM_Eckart_s(nN)=bias_Eckart_s(nN)^2+Var_Eckart_s(nN);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ml filter Hannan Thompson
        % paraplolique interpolation
        delai_estime_ml(nN)=mean(Dml(:,nN));
        bias_ml(nN)=delai_estime_ml(nN)-delai_attendu;
        Var_ml(nN)=var(Dml(:,nN));
        ecart_type_ml(nN)=sqrt(Var_ml(nN));
        EQM_ml(nN)=bias_ml(nN).^2+Var_ml(nN);
        % Shanon interpolation
        delai_estime_ml_s(nN)=mean(Dmls(:,nN));
        bias_ml_s(nN)=delai_estime_ml_s(nN)-delai_attendu;
        Var_ml_s(nN)=var(Dmls(:,nN));
        ecart_type_ml_s(nN)=sqrt(Var_ml_s(nN));
        EQM_ml_s(nN)=bias_ml_s(nN)^2+Var_ml_s(nN);
    end;
    save gcc;
    figure
    X = 1:length(h_Length);
    Y1=delai_estime_Eckart;
    E1=ecart_type_Eckart;
    errorbar(X,Y1,E1,'g --');
    Y2=delai_estime_ml;
    E2=ecart_type_ml;hold;
    errorbar(X,Y2,E2,'b--');
    set(gca,'XTick',1:length(h_Length)),
    set(gca,'XTickLabel',{h_Length})
    ylabel('Ecart_type en échantillon');
    xlabel('Largeurs des fenêtres (en échantillon)');
    S1=sprintf('Ecart-type en function des largeurs des fenêtres, SNR=%d dB',SNR(ns));
    title(S1);
    hold on;
    plot(X,delai_attendu.*ones(size(X)),'*r');
    legend('Eckart','HT', 'True value');
    grid on;
    hold on;
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
    figure;
    stem(X,EQM_Eckart,'r');
    set(gca,'XTick',1:length(h_Length)),
    set(gca,'XTickLabel',{h_Length})
    ylabel('EQM (échantillon)');
    xlabel('Largeurs des fenêtres (échantillon)');
    S1=sprintf('EQM en function des largeurs des fenêtres, SNR=%d dB',SNR(ns));
    title(S1);hold on;
    stem(X,EQM_ml,'b');
    set(gca,'XTick',1:length(h_Length)),
    set(gca,'XTickLabel',{h_Length})
    ylabel('EQM (échantillon)');
    xlabel('Largeurs des fenêtres (échantillon)');
    legend('Eckart','HT');
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
