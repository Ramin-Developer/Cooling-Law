function [TempExact, TempAsym] = AnalyticalSol(k, TempAmb, Temp0)
%ANALYTICALSOL Return exact and asymptotic temperature function handles.

% Exact solution of Newton's cooling law.
TempExact = @(t) TempAmb + (Temp0 - TempAmb) * exp(-k * t);

% Asymptotic temperature line.
TempAsym = @(t) TempAmb * ones(size(t));
