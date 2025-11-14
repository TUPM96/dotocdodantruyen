%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      *****  *   *  *****  ******  *****  *****                    %                                     
%                        *    *   *  *      *         *    *                        %
%                        *    *****  ***    ******    *    *****                    %
%                        *    *   *  *           *    *        *                    %
%                        *    *   *  ****   ******  *****  *****                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %
% Project name                  : THESIS                                            %
% Project part                  : Conducton Velocity estimation                     % 
%                                                                                   %
% File                          : Delay_Modeling.m                                  %
% File version                  : 1.00                                              %
% Author(s)                     : Frederic LECLERC                                  %
% Laboratory                    : Laboratory of Electronic, Signals, Images         %
% Origin                        : /                                                 %
% Date of creation              : 11 September 2006                                 %
% Comments                      :                                                   %
%                                                                                   %
% Date of mofification(s)       : 20 September 2006                                 % 
% Reason of the modification(s) : Add of comments.                                  %
%                                                                                   %
%                                                                                   %
%                               DESCRIPTION OF THE ALGORITHM:                       %
%                                                                                   %
%   This file was created to simulate a delay between 2 signals. The particularity  %
% of this program is that the delay can be a no-integer value of sample and also    %
% that it's based on a FIR model. So, we just need a set of coefficients to create  %
% the desired delay. Like this, a variable delay accross time can be made.          %
%    See the original aticle of Y.T. Chan and al., "Modeling of time delay and it's %
% application to estimation on non stationry delays", IEEE Transactions on          %
% Accoustics, Speeech and Signak Processing, Vol. ASSP-29, No 3, June 1981.         %
%   The original article present a varying delay that can be create between 0 and 1 %
% sample. For the negative case, nothing was proposed. To create a delay that is    %
% < 0, we separate the delay as a negative integer part and a positive part as :    %
% -3.56 = -4 + 0.44.                                                                %
%                                                                                   %
%                   ==============================================                  %
%                                                                                   %
%                                       INPUT PARMETERS (none)                      %
%                                                                                   %
% - Signal  : Original signal to delay, on N samples,                               %
% - D       : delay in sample (Ex. 4.56). The ddelay expression is Sd(t) = s(t+D).  %
%             So, for D positive, Sd(t) is in advance; for D negative, Sd(t) is     %
%             delayed in comparison to s(t).                                        %
% - NbCoef  : half of the number of coeficients for the FIR filter (p value in the  %
%             original article),                                                    %
% - Correct : '1' if the correction option is used; '0' else. This option can be    %
%             used to reduce the theorical error of the asked delay,                %
% - Resol   : used with the Correct option, specifies the resolution to estimate    %
%             the corrected delay.                                                  %
%                                                                                   %
%                                   OUTPUT PARMETERS (none)                         %
%                                                                                   %
% - Signal_D : delay version of the original signal.                                %
% - Dp       : pratical delay. This the Correct option is used, the Dp value is     %
%              different from the Delay value. Otherwise; these values are equal.   %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Signal_D] = Delay_Modeling_Var(Signal, Start, p, D, N)       % Length of signal can be different from the length of Signal_D.

% Global parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%N = length(Signal);         % Number of sample in the signal.
DeltaStart = Start-1; 
if(size(D) == size(1))
    Delay = ones(1:N)*D;        % The vector is a constant delay.
else
    Delay = D;                  % The vector is not a constant delay.
end
Signal_D = zeros(N,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start of the program                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:N;
    % Separation of the delay in integer part and decimal part D = D(1) + D(2);
    % Ex 1 : D = 1.45 => D = [1 0.45]; 
    % Ex 2 : D = -1.45 => D = [-2 +0.55]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = Delay(n);        % Copy of the delay in a tempory variable.
    D = zeros(1,2);         % Creation of a vector of 1 row, 2 columns. 
    D(1) =  floor(temp);
    D(2) = temp - D(1);   
    % We first make the translation of the signal by the integer part (D(2)), 
    % and then by the no integer part (D(1)).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    kmin = max(-p,DeltaStart + n + D(1) - length(Signal));       % Extraction of the kmin value.
    kmax = min(p-1,DeltaStart + n + D(1) - 1);      % Extraction of the kmax value.
    if(DeltaStart + n + D(1) - kmax < 0 || DeltaStart + n + D(1) - kmin > length(Signal))        % Test if the indice of Signal is defined.
        Signal_D(n) = 0;
        return
    end
    k = kmin:kmax;                                                    % Used to create the sinc
    Filt = sinc(D(2) + k);                                            % First vector;
    Sig = fliplr(Signal(DeltaStart + n + D(1) - kmax : DeltaStart + n + D(1) - kmin));      % Inverse the element of the matrix because without this                                                                                      % operation the start indice of Signal is inferior to the 
                          % stop indice; -(kmin) > -kmax because we are centered around 0.    
    Signal_D(n) = Filt*Sig';        % Scalar product.
end %for n=1:N;





