function config = GetDefaultCoolingConfig()
%GETDEFAULTCOOLINGCONFIG Return default configuration for cooling-law runs.

config = struct();
config.k = 0.08;
config.tempAmbient = 20;
config.tempInitial = 250;
config.tStart = 0;
config.tMax = 30;
config.numIntervals = 128;
config.enablePlot = false;
config.plotFileName = 'Comparison.pdf';
