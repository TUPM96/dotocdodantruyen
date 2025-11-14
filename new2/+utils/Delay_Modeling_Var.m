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
% Tham khao: Y.T. Chan et al., "Modeling of time delay and it's application
%            to estimation on non stationry delays", IEEE Transactions on
%            Accoustics, Speech and Signal Processing, Vol. ASSP-29, No 3, June 1981
%
function [Signal_D] = Delay_Modeling_Var(Signal, Start, p, D, N)

% Tham so toan cuc
DeltaStart = Start - 1;

% Kiem tra D la hang so hay vector
if size(D) == size(1)
    Delay = ones(1, N) * D;        % Vector do tre hang so
else
    Delay = D;                     % Vector do tre bien thien
end

Signal_D = zeros(N, 1);

% Bat dau chuong trinh
for n = 1:N
    % Tach do tre thanh phan nguyen va phan thap phan
    % Vi du: D = 1.45 => D = [1 0.45]
    %        D = -1.45 => D = [-2 +0.55]
    temp = Delay(n);
    D_split = zeros(1, 2);
    D_split(1) = floor(temp);     % Phan nguyen
    D_split(2) = temp - D_split(1);  % Phan thap phan
    
    % Thuc hien dich chuyen so nguyen truoc (D_split(1))
    % Sau do ap dung bo loc cho phan thap phan (D_split(2))
    
    % Tinh gioi han chi so k cho bo loc
    kmin = max(-p, DeltaStart + n + D_split(1) - length(Signal));
    kmax = min(p-1, DeltaStart + n + D_split(1) - 1);
    
    % Kiem tra chi so co hop le khong
    if DeltaStart + n + D_split(1) - kmax < 0 || ...
       DeltaStart + n + D_split(1) - kmin > length(Signal)
        Signal_D(n) = 0;
        return
    end
    
    % Tao bo loc sinc
    k = kmin:kmax;
    Filt = sinc(D_split(2) + k);
    
    % Lay mau tin hieu tuong ung
    % Dao nguoc vi chi so bat dau lon hon chi so ket thuc
    Sig = fliplr(Signal(DeltaStart + n + D_split(1) - kmax : ...
                        DeltaStart + n + D_split(1) - kmin));
    
    % Tinh tich vo huong de co gia tri tin hieu sau khi tre
    Signal_D(n) = Filt * Sig';
end

end

