% SCRIPTANALYTICALSOL Entry point for analytical-only cooling-law evaluation.

clear;
close all;

config = GetDefaultCoolingConfig();

% Problem's analytical solution
[TempExact, TempAsymp] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

% Build a dense time grid for analytical inspection.
numPoints = 256;
t = linspace(config.tStart, config.tMax, numPoints)';
tempExactVals = TempExact(t);
tempAsympVals = TempAsymp(t);

fprintf('Analytical-only run complete.\n');
fprintf('T(0) = %.6f, T(tMax) = %.6f, T_asym = %.6f\n', ...
    tempExactVals(1), tempExactVals(end), tempAsympVals(end));