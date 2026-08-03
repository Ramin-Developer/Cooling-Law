% SCRIPTMAIN Entry point for analytical vs numerical cooling-law comparison.

clear;
close all;

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
addpath(fullfile(projectRoot, 'src'));

config = GetDefaultCoolingConfig();
config.verbose = true;
config.enablePlot = false;

result = RunCoolingLaw(config);
solverError = result.error;
