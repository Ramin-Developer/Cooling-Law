function [k, TempAmb, Temp0, tStart, tMax] = ProblemConstants
%PROBLEMCONSTANTS Return default model parameters for cooling-law runs.

config = GetDefaultCoolingConfig();
k = config.k;
TempAmb = config.tempAmbient;
Temp0 = config.tempInitial;
tStart = config.tStart;
tMax = config.tMax;
