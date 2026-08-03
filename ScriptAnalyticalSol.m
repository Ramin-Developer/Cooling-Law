
clear;

% Problem constants of Newton's Law of Cooling
[k, TempAmb, Temp0, tStart, tMax, N] = ProblemConstants;

% Problem's numerical solution using sentral difference schema
[tNum, TempNum] = ...
    DifferenceSolution(k, TempAmb, Temp0, tStart, tMax, N);

% Problem's analytical solution
[TempEx, TempAsymptote] = AnalyticalSolution(k, TempAmb, Temp0, tNum);

% Estimation of the numerical error;
error = EstimateError(tNum, TempEx, TempNum, TempAsymptote);