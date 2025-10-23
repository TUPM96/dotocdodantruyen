%% ================== Delay_Modeling_Var.m ==================
function [Signal_D] = Delay_Modeling_Var(Signal, Start, p, D, N)
DeltaStart = Start - 1;
if numel(D) == 1
    Delay = ones(1, N) * D;
else
    Delay = D;
end

Signal_D = zeros(N, 1);
for n = 1:N
    temp = Delay(n);
    Dv = [floor(temp), temp - floor(temp)];
    kmin = max(-p, DeltaStart + n + Dv(1) - length(Signal));
    kmax = min(p-1, DeltaStart + n + Dv(1) - 1);
    if (DeltaStart + n + Dv(1) - kmax < 0) || ...
       (DeltaStart + n + Dv(1) - kmin > length(Signal))
        Signal_D(n) = 0;
        continue;
    end
    % Nội suy FIR
    for k = kmin:kmax
        Signal_D(n) = Signal_D(n) + Signal(DeltaStart + n + Dv(1) - k) * sinc(k - Dv(2));
    end
end
end
