% SCRIPTMAIN Entry point for analytical vs numerical cooling-law comparison.

% clc;
clear;
close all;

config = GetDefaultCoolingConfig();
config.enablePlot = false;

result = RunCoolingLaw(config);
error = result.error;
