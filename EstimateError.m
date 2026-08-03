function error = EstimateError(N, timeDisc, TempEx, TempNum)
%ESTIMATEERROR Compute RMS error of numerical solution vs exact values.

TempExForComp = TempEx(timeDisc);

% Calculate variance and standard deviation of the error:
errVariance = sum((TempExForComp(2:end) - TempNum(2:end)).^2) / (N - 1);
error = sqrt(errVariance);

% Present the result
SciFormat = '%10.5e';
errorStr = num2str(error, SciFormat);
fprintf('\nN =\t\t%d\nError =\t%s\n\n', N, errorStr);
