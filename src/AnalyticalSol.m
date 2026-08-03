function [TempExact, TempAsym] = AnalyticalSol(k, TempAmb, Temp0)
%ANALYTICALSOL Return exact and asymptotic temperature function handles.

validateattributes(k, {'numeric'}, {'scalar', 'real', 'finite', 'positive'}, mfilename, 'k');
validateattributes(TempAmb, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'TempAmb');
validateattributes(Temp0, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'Temp0');

% Exact solution of Newton's cooling law.
TempExact = @(t) TempAmb + (Temp0 - TempAmb) * exp(-k * t);

% Asymptotic temperature line.
TempAsym = @(t) TempAmb * ones(size(t));
