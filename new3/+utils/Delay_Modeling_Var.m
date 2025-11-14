% ==============================================================================
% TEN FILE: Delay_Modeling_Var.m
% CHUC NANG: Tao do tre phan so su dung bo loc FIR
% MODULE: utils
% ==============================================================================
%
function [Signal_D] = Delay_Modeling_Var(Signal, Start, p, D, N)

DeltaStart = Start - 1;

if size(D) == size(1)
    Delay = ones(1, N) * D;
else
    Delay = D;
end

Signal_D = zeros(N, 1);

for n = 1:N
    temp = Delay(n);
    D_split = zeros(1, 2);
    D_split(1) = floor(temp);
    D_split(2) = temp - D_split(1);
    
    kmin = max(-p, DeltaStart + n + D_split(1) - length(Signal));
    kmax = min(p-1, DeltaStart + n + D_split(1) - 1);
    
    if DeltaStart + n + D_split(1) - kmax < 0 || ...
       DeltaStart + n + D_split(1) - kmin > length(Signal)
        Signal_D(n) = 0;
        return
    end
    
    k = kmin:kmax;
    Filt = sinc(D_split(2) + k);
    
    Sig = fliplr(Signal(DeltaStart + n + D_split(1) - kmax : ...
                        DeltaStart + n + D_split(1) - kmin));
    
    Signal_D(n) = Filt * Sig';
end

end

