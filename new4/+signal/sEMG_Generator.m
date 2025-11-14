% ==============================================================================
% TEN FILE: sEMG_Generator.m
% CHUC NANG: Tao tin hieu sEMG gia lap voi cac kenh co do tre khac nhau
% MODULE: signal
% ==============================================================================
%
% Mo ta: Tao tin hieu sEMG (surface Electromyography) gia lap
%        voi cac kenh co do tre thoi gian khac nhau
%
% Dau vao:
%   Signal_Type: Loai tin hieu ('gwn', 'simu_semg', 'real_semg')
%   N: So diem tin hieu
%   p: So he so cho bo loc tao do tre
%   D: Do tre (mau) - co the la hang so hoac vector
%   Fe: Tan so lay mau (Hz)
%   Signal_Name: Ten file tin hieu (neu Signal_Type = 'real_semg')
%
% Dau ra:
%   Vec_Signal: Ma tran Nx4 chua 4 kenh tin hieu
%   T: Vector thoi gian
%   b: He so bo loc (neu Signal_Type = 'simu_semg')
%
function [Vec_Signal,T,b] = sEMG_Generator(Signal_Type, N, p, D, Fe, Signal_Name)
% Tao vector do tre: Neu D la hang so thi tao vector hang so
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(size(D) == size(1))
    Delay = ones(1,N)*D;        % The vector is a constant delay.
else
    Delay = D;                  % The vector is not a constant delay.
end

Np = N;     % Number of sample to create the signal 'Signal'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global parameters                                                  % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 1:N;
DeltaStart = max([0 (p - n - floor(Delay))]);           % Get the number of samples that need to be had to the signal to supress the edge effects.
DeltaStop  = max([0 (n + floor(Delay) + p -N)]);        % Get the number of samples that need to be had to the signal to supress the edge effects.

if(DeltaStart < 0)
    DeltaStart = 0;                      % If DeltaStart < 0, ne don't move the indice 1 towards the right of |DeltaStart| values.
end % if(DeltaStart < 0)

if(DeltaStop < 0)  
    DeltaStop = 0;
end % if(DeltaStart > 0)
    
Np = Np + 3*(DeltaStart + DeltaStop);       % We need Np values in the original signal to create the delay versions, without edge effects. 
b = [];                                     % Only used with the 'simu_semg' part.
M = 4;                                      % We are creating 4 delay signals.
Vec_Signal = zeros(N,M);                    % Output vector that will keep the delayed signals.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creation of the original signals                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(Signal_Type)               % Signal selection.
    case 'gwn'                          % The EMG signal is here a Gaussian White Noise.
        Signal = randn(1,Np);           
        
    case 'simu_semg'
    fh = 120;       % 120 Hz
    fl = 60;        % 60 Hz
    k = 1;
    Fs = Fe;
    f = linspace(0,Fs,N);
    PSD = k*fh.^4.*f.^2./((f.^2+fl.^2).*(f.^2+fh.^2).^2);       % Ref : D. Farina and R. Merletti, "Comparison of algorithms for estimation of EMG variables during
                                                                % voluntary contractions", Journal of Electromyography and Kinesiology, vol. 10, pp. 337-349, 2000. 
    PSD = [PSD(1:N/2+1) fliplr(PSD(2:N/2)) ];                   % Creation of the second part of the spectrum.
    PSD = PSD./max(PSD);       save PSD;                                 % Normalization.
    
    Signal = randn(1,Np);       % Start of the simulated sEMG signal.
    b = fftshift(real(ifft(sqrt(PSD))));
    Ncoef = round(Fs/4096*100);                                 % Size of the filter, at Fe = 1024, Ncoef = 100. 
    b = b(N/2+1-Ncoef/2:N/2+1+Ncoef/2) ;                     % Filter size dependant of the sample frequency.
    Signal = filtfilt(b,1,Signal); 
    case 'real_semg'
    load Signal_Name;
    Signal = sEMG(1:round(4096/Fe):Np*round(4096/Fe));
end
T = linspace(0,N,N)./Fe;
% Su dung module utils de tao do tre
[Vec_Signal(:,2)] = utils.Delay_Modeling_Var(Signal, 1, p, Delay, N);         % Creation of the signal n2.
[Vec_Signal(:,3)] = utils.Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);       % Creation of the signal n3.
[Vec_Signal(:,4)] = utils.Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);       % Creation of the signal n4.
Vec_Signal(:,1)   = Signal(1:N);                                        % Creation of the signal n1.

