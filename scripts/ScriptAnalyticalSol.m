% SCRIPTANALYTICALSOL Entry point for analytical-only cooling-law evaluation.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
addpath(fullfile(projectRoot, 'src'));

config = GetDefaultCoolingConfig();

% Problem's analytical solution
[tempExactFn, tempAsymFn] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

% Build a dense time grid for analytical inspection.
numPoints = 256;
t = linspace(config.tStart, config.tMax, numPoints)';
tempExactVals = tempExactFn(t);
tempAsymVals = tempAsymFn(t);

fprintf('Analytical-only run complete.\n');
fprintf('T(0) = %.6f, T(tMax) = %.6f, T_asym = %.6f\n', ...
    tempExactVals(1), tempExactVals(end), tempAsymVals(end));