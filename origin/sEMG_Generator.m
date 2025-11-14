%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      *****  *   *  *****  ******  *****  *****                    %
%                        *    *   *  *      *         *    *                        %
%                        *    *****  ***    ******    *    *****                    %
%                        *    *   *  *           *    *        *                    %
%                        *    *   *  ****   ******  *****  *****                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %
% Project name                  : THESIS                                            %
% Project part                  : sEMG generation                                   %
%                                                                                   %
% File                          : sEMG_Generator.m                                  %
% File version                  : 1.00                                              %
% Author(s)                     : Frederic LECLERC                                  %
% Laboratory                    : Laboratory of Electronic, Signals, Images         %
% Origin                        : /                                                 %
% Date of creation              : 1 février 2007                                    %
% Comments                      :                                                   %
%                                                                                   %
% Date of mofification(s)       : 19 janvier 2008                                   %
% Reason of the modification(s) : In order to evaluate the whitening importance and %
%                                 and the bandwidth, the bbg option was modified.   %
%                                                                                   %
% Date of mofification(s)       : 20 janvier 2008                                   %
% Reason of the modification(s) : Creation of 1 signal + 2 delayed version.         %
%                                                                                   %
%                               DESCRIPTION OF THE ALGORITHM                        %
%                                                                                   %
% This script propose to create 3 possible signals :                                %
% - a BBG signal,                                                                   %
% - an EMG signal create with a BBG signal and then filtered,                       %
% - loading an existing signal                                                      %
%                                                                                   %
%    The option 'simu_semg' used a bbg signal that is passed throug a filter.       %
% Coefficients of this filter are ing to the spectral shape and to the sample       %
% frequency.                                                                        %
%                                                                                   %
%                   ==============================================                  %
%                                                                                   %
%                                       INPUT PARMETERS                             %
%                                                                                   %
% - Signal_Type  : 'BBG', 'sEMG_sim', 'sEMG_raw',                                   %
% - N            : number of sample in the signals 'Signal' and 'Signal_D',         %
% - M            : number of channels that we want to create,                       %
% - p            : p value in the original article,                                 %
% - D            : vector delay. If D is a scalar, a vector is created with a a     %
%                  constant delay D,                                                %
% - Signal_Name  : Name of the signal that you want to used with the option         %
%                  'real_semg'.                                                     %
%                                                                                   %
%                                                                                   %
%                                   OUTPUT PARMETERS                                %
%                                                                                   %
% - Vec_Signal  : Signal with delay. it's NxM matrix where N is the input           %
%                 parameters (number of sample in the signal) and M is the number   % 
%                 of channels.                                                         %
% - T           : Time in second.                                                   %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Vec_Signal,T,b] = sEMG_Generator(Signal_Type, N, p, D, Fe, Signal_Name)
% Create a delay vector of N values if the variable D is scalar
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
[Vec_Signal(:,2)] = Delay_Modeling_Var(Signal, 1, p, Delay, N);         % Creation of the signal n°2.
[Vec_Signal(:,3)] = Delay_Modeling_Var(Signal, 1, p, 2*Delay, N);       % Creation of the signal n°3.
[Vec_Signal(:,4)] = Delay_Modeling_Var(Signal, 1, p, 3*Delay, N);       % Creation of the signal n°4.
Vec_Signal(:,1)   = Signal(1:N);                                        % Creation of the signal n°1.
% Display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;  plot(T,Signal, 'k.-'); hold on 
% plot(T,Signal_D,'r.-'); hold off 
% % plot(sEMG(1: Np),'g.-'); 
% grid on
% title('Signal (in black) and it''s delay version (in red)','FontName','Times','FontWeight','bold','FontSize',11); 
% xlabel('Time (sec)','FontName','Times','FontWeight','bold','FontSize',11); 
% ylabel('Amplitude (AU)','FontName','Times','FontWeight','bold','FontSize',11)




















