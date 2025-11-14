% ==============================================================================
% TEN FILE: Delay_Modeling_Var.m
% CHUC NANG: Tao do tre phan so su dung bo loc FIR
% MODULE: utils
% ==============================================================================
%
% Mo ta: Mo phong do tre giua 2 tin hieu
%        Dac biet: Do tre co the la gia tri khong phai so nguyen (phan so)
%        Su dung mo hinh bo loc FIR, chi can mot tap he so de tao do tre mong muon
%        Co the tao do tre bien thien theo thoi gian
%
% Nguyen ly: Su dung ham sinc de tao bo loc FIR
%            Tach do tre thanh phan nguyen va phan thap phan
%            Thuc hien dich chuyen so nguyen truoc, sau do ap dung bo loc cho phan thap phan
%
% Dau vao:
%   Signal: Tin hieu goc (co the dai hon Signal_D)
%   Start: Chi so bat dau (thuong la 1)
%   p: So he so cho bo loc FIR (bac cua bo loc)
%   D: Do tre (mau) - co the la hang so hoac vector
%   N: Do dai tin hieu dau ra
%
% Dau ra:
%   Signal_D: Tin hieu sau khi tre
%
function [Signal_D] = Delay_Modeling_Var(Signal, Start, p, D, N)

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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = Delay(n);        % Copy of the delay in a tempory variable.
    D = zeros(1,2);         % Creation of a vector of 1 row, 2 columns. 
    D(1) =  floor(temp);
    D(2) = temp - D(1);   
    % We first make the translation of the signal by the integer part (D(2)), 
    % and then by the no integer part (D(1)).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
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

