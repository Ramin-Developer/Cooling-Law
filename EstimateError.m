function error = EstimateError(N, timeDisc, TempEx, TempNum)

TempExForComp = TempEx(timeDisc);

% Calculate variance and standard deviation of the error:
var = sum((TempExForComp(2:end) - TempNum(2:end)).^2) / (N - 1);
error = sqrt(var);

% Present the result
SciFormat = '%10.5e';
errorStr = num2str(error, SciFormat);
fprintf('\nN =\t\t%d\nError =\t%s\n\n', N, errorStr);
