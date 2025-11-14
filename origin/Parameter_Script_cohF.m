
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
N_MonteCarlo    = 100;
Duration        =  0.125;               % Durée de la simulation en seconde.
Fs              = 2048;                 % Fréquence d'échantillonnage.
nfft            = 2048;                 % Number of sample for the tfrstft function.
N               = Duration*Fs;          % Nombre de points total pour 1 signal.
p               = 40;                   % Nombre de coefficients pour la création du filtre délais (utilisé dans la fonction sEMG_Generator)
%SNR             = [-10 -5  0 5 10 ];                   % SNR en dB
Bandwidth       = [15 200];                               % Bande passante pour l'estimation 
RegLinStart     = round(Bandwidth(1)*nfft/Fs + 1);      % On récupère l'indice (en échantillons) de début de l'axe fréquenciel pour la régression linéaire.
RegLinStop      = round(Bandwidth(2)*nfft/Fs + 1);      % On récupère l'indice (en échantillons) de fin de l'axe fréquenciel pour la régression linéaire.
nF              = (0:nfft-1)/nfft;                      % Normalized Frequency axis for the data display (0 to 1).
f               = nF(RegLinStart:RegLinStop)*Fs;        % Conversion de l'axe des Fréquences en échantillons. 
n               = 1:N;                      % Frequency axis for the data display
h_Length        = [128];     % Ponderation windows size.
CV_Scale        = [2 6];             % Min and Max de la Vitesse de Conduction (Conduction Velociity-CV)
DeltaE          = 5*10^(-3);         % Interelectrode distance in mm.
phi=0.0;
Nl=5;
Nc=13;
for nc=1:Nc
    for nl=1:Nl
        
            CV = (CV_Scale(2) - CV_Scale(1))/2*sin(2*pi*n/N) + (CV_Scale(2) + CV_Scale(1))/2;
            CV=((nc-1)*sin(phi)+(nl-1)*cos(phi)).*CV;
            %[Vec_Signal(:,3,i)] = Delay_Modeling_Var(Signal, 1, p, 2*Delay, N)      % Creation of the signal n°3.
            %pause
            %[Vec_Signal(:,4,i)] = Delay_Modeling_Var(Signal, 1, p, 3*Delay, N)      % Creation of the signal n°4.
            %pause
            %Vec_Signal(:,1,i)   = Signal(1:N)
            Delay          = DeltaE*Fs./CV;
        
    end
end
%CV = (CV_Scale(2) - CV_Scale(1))/2*sin(2*pi*n/N) + (CV_Scale(2) + CV_Scale(1))/2; 
      % Sinusoidal CV.
% CV       = (CV_Scale(2) - CV_Scale(1))./(1+exp(-8/5*(n/Fs-Duration/2))) +
% CV_Scale(1);      % Sigmoide CV : Delay       =
% 5./(1+exp(-8/5*(n/Fs-2.5))) + 3;
Delay           = DeltaE*Fs./CV;       % Delay en m.s-1
Est_Delta_CVmax = 1;    % Amplitude maximale tolérée physiologiquement entre la valeur de la CV estimée à l'intant n par rapport à la valeur médiane calculée sur les M valeurs précédentes.
Delay_Threshold = Est_Delta_CVmax/(Fs*DeltaE)*min(Delay).^2;        % On supprime tout les point pour lesquels on a une variation supérieure ou inférieure à 1 m/s par rapport à la médiane sur les 10 précédentes estimations.
Delta           = 10;             % Nombre de points temporels pour le moyennage de la phase de la cohérence instantanée.
Med_Windows     = 20;       % Largeur de la fenêtre médiane pour supprimer les points aberrants.
% Sauvegarde des parametres de simulations spécifique au. 
% Script_Interspectrum_Phase_d10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save Parameter_Script_cohF