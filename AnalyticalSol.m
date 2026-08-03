function [TempExact, TempAsym] = AnalyticalSol(k, TempAmb, Temp0)

% Calculate analytical solutions:
if (Temp0 > TempAmb)
    TempExact = @(t) TempAmb + (Temp0 - TempAmb) * exp(-k * t);
else
    TempExact = @(t) TempAmb - (TempAmb - Temp0) * exp(-k * t);
end;

% Calculate asymptotical line:
TempAsym = @(t) TempAmb * ones(size(t));
